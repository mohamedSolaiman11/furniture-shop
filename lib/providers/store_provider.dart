import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class StoreProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  StoreProvider() {
    fetchInitialData();
    _loadLocalData(); // تحميل السلة والمفضلة المحفوظة
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // ── Navigation & Filter State ─────────────────────────────────────────────
  int _currentTab = 0;
  int get currentTab => _currentTab;
  
  String _searchQuery = '';
  String _selectedCategoryId = 'all';
  double _maxPrice = 200000;

  String get searchQuery => _searchQuery;
  String get selectedCategoryId => _selectedCategoryId;
  double get maxPrice => _maxPrice;

  String? _pendingQuoteProduct;
  String? get pendingQuoteProduct => _pendingQuoteProduct;

  void setTab(int index, {String? categoryId, String? quoteProduct}) {
    _currentTab = index;
    if (categoryId != null) _selectedCategoryId = categoryId;
    if (quoteProduct != null) _pendingQuoteProduct = quoteProduct;
    notifyListeners();
  }

  void updateFilters({String? q, String? catId, double? price}) {
    if (q != null) _searchQuery = q;
    if (catId != null) _selectedCategoryId = catId;
    if (price != null) _maxPrice = price;
    notifyListeners();
  }

  void clearPendingQuote() {
    _pendingQuoteProduct = null;
    notifyListeners();
  }

  // ── Supabase Auth ─────────────────────────────────────────────────────────
  bool get isOwner => _supabase.auth.currentSession != null;

  Future<bool> login(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  // ── Remote Data ───────────────────────────────────────────────────────────
  List<Category> _categories = [];
  List<Product> _products = [];
  List<Order> _orders = [];
  List<Inquiry> _inquiries = [];

  List<Category> get categories => List.unmodifiable(_categories);
  List<Product> get products => List.unmodifiable(_products);
  List<Order> get orders => List.unmodifiable(_orders);
  List<Inquiry> get inquiries => List.unmodifiable(_inquiries);

  Future<void> fetchInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final catsData = await _supabase.from('categories').select();
      _categories = (catsData as List).map((e) => Category.fromMap(e)).toList();

      final prodsData = await _supabase.from('products').select();
      _products = (prodsData as List).map((e) => Product.fromMap(e)).toList();

      if (isOwner) {
        final ordersData = await _supabase.from('orders').select().order('created_at', ascending: false);
        _orders = (ordersData as List).map((e) => Order.fromMap(e)).toList();

        final inqsData = await _supabase.from('inquiries').select().order('created_at', ascending: false);
        _inquiries = (inqsData as List).map((e) => Inquiry.fromMap(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> get filteredProducts {
    return _products.where((p) {
      final matchQ = _searchQuery.isEmpty || p.name.contains(_searchQuery) || p.material.contains(_searchQuery);
      final matchCat = _selectedCategoryId == 'all' || p.categoryId == _selectedCategoryId;
      final matchPrice = p.finalPrice <= _maxPrice;
      return matchQ && matchCat && matchPrice;
    }).toList();
  }

  // ── Actions ──────────────────────────────────────────────────────────────
  Future<void> submitInquiry({required String name, required String email, required String phone, required String message}) async {
    final inq = Inquiry(id: '', name: name, email: email, phone: phone, message: message, createdAt: DateTime.now());
    await _supabase.from('inquiries').insert(inq.toMap());
    fetchInitialData();
  }

  Future<void> placeOrder({required String name, required String email, required String phone}) async {
    if (_cart.isEmpty) return;
    final orderId = DateTime.now().millisecondsSinceEpoch.toString().substring(5);
    final order = Order(id: orderId, items: List.from(_cart), customerName: name, customerEmail: email, customerPhone: phone, createdAt: DateTime.now());
    await _supabase.from('orders').insert(order.toMap());
    _cart.clear();
    _saveLocalData();
    fetchInitialData();
  }

  Future<void> addReview(String productId, Review review) async {
    final p = _products.firstWhere((p) => p.id == productId);
    final updatedReviews = List<Review>.from(p.reviews)..add(review);
    await _supabase.from('products').update({
      'reviews': updatedReviews.map((e) => e.toMap()).toList()
    }).eq('id', productId);
    fetchInitialData();
  }

  Future<void> incrementView(String id) async {
    try {
      final p = _products.firstWhere((p) => p.id == id);
      await _supabase.from('products').update({'view_count': p.viewCount + 1}).eq('id', id);
    } catch (_) {}
  }

  // ── Cart & Wishlist (Persistent) ──────────────────────────────────────────
  List<CartItem> _cart = [];
  List<Product> _wishlist = [];

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Product> get wishlist => List.unmodifiable(_wishlist);
  int get cartCount => _cart.fold(0, (s, i) => s + i.quantity);
  double get cartTotal => _cart.fold(0, (s, i) => s + i.total);
  
  void addToCart(Product p) {
    final idx = _cart.indexWhere((i) => i.product.id == p.id);
    if (idx >= 0) { _cart[idx].quantity++; } else { _cart.add(CartItem(product: p)); }
    _saveLocalData();
    notifyListeners();
  }
  void removeFromCart(String id) { _cart.removeWhere((i) => i.product.id == id); _saveLocalData(); notifyListeners(); }
  void updateQty(String id, int qty) { 
    final i = _cart.indexWhere((item) => item.product.id == id);
    if (i != -1) { if (qty < 1) { _cart.removeAt(i); } else { _cart[i].quantity = qty; } _saveLocalData(); notifyListeners(); }
  }

  bool isWishlisted(String id) => _wishlist.any((p) => p.id == id);
  void toggleWishlist(Product p) {
    if (isWishlisted(p.id)) { _wishlist.removeWhere((w) => w.id == p.id); }
    else { _wishlist.add(p); }
    _saveLocalData();
    notifyListeners();
  }

  // ── Local Persistence ──
  Future<void> _saveLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(_cart.map((e) => {'product': e.product.toMap(), 'quantity': e.quantity}).toList()));
    await prefs.setString('wishlist', jsonEncode(_wishlist.map((e) => e.toMap()).toList()));
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartStr = prefs.getString('cart');
    final wishStr = prefs.getString('wishlist');
    if (cartStr != null) {
      _cart = (jsonDecode(cartStr) as List).map((e) => CartItem(product: Product.fromMap(e['product']), quantity: e['quantity'])).toList();
    }
    if (wishStr != null) {
      _wishlist = (jsonDecode(wishStr) as List).map((e) => Product.fromMap(e)).toList();
    }
    notifyListeners();
  }

  // ── Admin Actions ─────────────────────────────────────────────────────────
  Future<void> addProduct(Product p) async { 
    var map = p.toMap(); map.remove('id');
    await _supabase.from('products').insert(map); 
    fetchInitialData(); 
  }
  Future<void> updateProduct(Product p) async { await _supabase.from('products').update(p.toMap()).eq('id', p.id); fetchInitialData(); }
  Future<void> deleteProduct(String id) async { await _supabase.from('products').delete().eq('id', id); fetchInitialData(); }
  Future<void> addCategory(String name, String icon, {String? img}) async { await _supabase.from('categories').insert({'name': name, 'icon': icon, 'image_url': img}); fetchInitialData(); }
  Future<void> updateCategory(String id, String name, String icon, {String? img}) async { await _supabase.from('categories').update({'name': name, 'icon': icon, 'image_url': img}).eq('id', id); fetchInitialData(); }
  Future<void> deleteCategory(String id) async { await _supabase.from('categories').delete().eq('id', id); fetchInitialData(); }
  Future<void> updateOrderStatus(String id, OrderStatus s) async { await _supabase.from('orders').update({'status': s.name}).eq('id', id); fetchInitialData(); }
  Future<void> markInquiryRead(String id) async { await _supabase.from('inquiries').update({'is_read': true}).eq('id', id); fetchInitialData(); }

  double get totalRevenue => _orders.where((o) => o.status != OrderStatus.cancelled.name).fold(0, (s, o) => s + o.total);
  int get totalOrders => _orders.length;
  int get unreadInquiries => _inquiries.where((i) => !i.isRead).length;
  List<dynamic> get topViewedProducts => (List.from(_products)..sort((a, b) => b.viewCount.compareTo(a.viewCount))).take(5).toList();
}
