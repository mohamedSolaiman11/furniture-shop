// ─── lib/models/category.dart ───────────────────────────────────────────────
class Category {
  final String id;
  String name;
  String icon;
  String? imageUrl;

  Category({required this.id, required this.name, required this.icon, this.imageUrl});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image_url': imageUrl,
    };
  }
}

// ─── lib/models/product.dart ─────────────────────────────────────────────────
class Review {
  final String author;
  final double rating;
  final String comment;
  final DateTime date;

  Review({required this.author, required this.rating, required this.comment, required this.date});

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      author: map['author'],
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}

class Product {
  final String id;
  String name;
  String description;
  double price;
  double? discountPercent;
  String categoryId;
  List<String> images;
  String material;
  List<Review> reviews;
  int viewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPercent,
    required this.categoryId,
    required this.images,
    required this.material,
    required this.reviews,
    this.viewCount = 0,
  });

  double get finalPrice => discountPercent != null ? price * (1 - discountPercent! / 100) : price;
  double get avgRating => reviews.isEmpty ? 0 : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      discountPercent: map['discount_percent'] != null ? (map['discount_percent'] as num).toDouble() : null,
      categoryId: map['category_id'],
      images: List<String>.from(map['images'] ?? []),
      material: map['material'],
      reviews: (map['reviews'] as List? ?? []).map((r) => Review.fromMap(r)).toList(),
      viewCount: map['view_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_percent': discountPercent,
      'category_id': categoryId,
      'images': images,
      'material': material,
      'reviews': reviews.map((r) => r.toMap()).toList(),
      'view_count': viewCount,
    };
  }
}

// ─── lib/models/cart_item.dart ───────────────────────────────────────────────
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.finalPrice * quantity;
}

// ─── lib/models/order.dart ───────────────────────────────────────────────────
enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class Order {
  final String id;
  final List<CartItem> items;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.status = OrderStatus.pending,
    required this.createdAt,
  });

  double get total => items.fold(0, (sum, i) => sum + i.total);

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerName: map['customer_name'],
      customerEmail: map['customer_email'],
      customerPhone: map['customer_phone'],
      status: OrderStatus.values.firstWhere((e) => e.name == map['status']),
      createdAt: DateTime.parse(map['created_at']),
      items: (map['items'] as List).map((i) => CartItem(
        product: Product.fromMap(i['product']),
        quantity: i['quantity'],
      )).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'items': items.map((i) => {
        'product': i.product.toMap(),
        'quantity': i.quantity,
      }).toList(),
    };
  }
}

// ─── lib/models/inquiry.dart ─────────────────────────────────────────────────
class Inquiry {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final DateTime createdAt;
  bool isRead;

  Inquiry({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory Inquiry.fromMap(Map<String, dynamic> map) {
    return Inquiry(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      message: map['message'],
      createdAt: DateTime.parse(map['created_at']),
      isRead: map['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}
