class AppStrings {
  final String locale;
  const AppStrings(this.locale);

  bool get isAr => locale == 'ar';

  // General
  String get appName => isAr ? 'رقُي للأثاث':'رقُي للأثاث';
  String get search => isAr ? 'بحث...' : 'Search furniture, materials...';
  String get all => isAr ? 'الكل' : 'All';
  String get save => isAr ? 'حفظ' : 'Save';
  String get cancel => isAr ? 'إلغاء' : 'Cancel';
  String get add => isAr ? 'إضافة' : 'Add';
  String get edit => isAr ? 'تعديل' : 'Edit';
  String get delete => isAr ? 'حذف' : 'Delete';
  String get submit => isAr ? 'إرسال' : 'Submit';
  String get noData => isAr ? 'لا توجد بيانات بعد.' : 'No data yet.';

  // Nav
  String get home => isAr ? 'الرئيسية' : 'Home';
  String get shop => isAr ? 'المتجر' : 'Shop';
  String get wishlist => isAr ? 'المفضلة' : 'Wishlist';
  String get cart => isAr ? 'السلة' : 'Cart';
  String get contact => isAr ? 'تواصل' : 'Contact';

  // Home
  String get heroTitle => isAr ? 'رُقي' : 'LUXE';
  String get heroSubtitle => isAr ? 'أثاث' : 'F U R N I T U R E';
  String get heroTagline => isAr ? 'أناقة خالدة للمنزل الراقي' : 'Timeless elegance for the discerning home';
  String get exploreCollection => isAr ? 'استكشف المجموعة' : 'Explore Collection';
  String get collections => isAr ? 'المجموعات' : 'Collections';
  String get featuredPieces => isAr ? 'القطع المميزة' : 'Featured Pieces';

  // Products
  String get maxPrice => isAr ? 'الحد الأقصى للسعر:' : 'Max Price:';
  String piecesFound(int n) => isAr ? '$n قطعة متاحة' : '$n pieces found';
  String get noProducts => isAr ? 'لا توجد منتجات' : 'No products found';
  String get material => isAr ? 'الخامة' : 'Material';
  String get addToCart => isAr ? 'أضف للسلة' : 'Add to Cart';
  String get writeReview => isAr ? 'اكتب تقييماً' : 'Write a Review';
  String get reviews => isAr ? 'التقييمات' : 'Reviews';
  String get noReviews => isAr ? 'لا توجد تقييمات بعد.' : 'No reviews yet.';
  String get yourName => isAr ? 'اسمك' : 'Your name';
  String get yourReview => isAr ? 'تقييمك...' : 'Your review...';
  String get rating => isAr ? 'التقييم:' : 'Rating:';
  String get addedToCart => isAr ? 'تمت الإضافة للسلة' : 'Added to cart';

  // Cart
  String get cartEmpty => isAr ? 'السلة فارغة' : 'Your cart is empty';
  String get total => isAr ? 'الإجمالي' : 'Total';
  String get proceedToOrder => isAr ? 'متابعة الطلب' : 'Proceed to Order';
  String get completeOrder => isAr ? 'إتمام الطلب' : 'Complete Order';
  String get placeOrder => isAr ? 'تأكيد الطلب' : 'Place Order';
  String get orderSuccess => isAr ? 'تم تأكيد الطلب بنجاح!' : 'Order placed successfully!';
  String get fullName => isAr ? 'الاسم الكامل' : 'Full Name';
  String get email => isAr ? 'البريد الإلكتروني' : 'Email';
  String get phone => isAr ? 'رقم الهاتف' : 'Phone';

  // Wishlist
  String get wishlistEmpty => isAr ? 'لا توجد قطع محفوظة بعد' : 'No saved pieces yet';

  // Contact
  String get contactUs => isAr ? 'تواصل معنا' : 'Contact Us';
  String get contactSubtitle => isAr ? 'اطلب عرض سعر أو استفسر عن منتج' : 'Request a Quote or Ask a Question';
  String get message => isAr ? 'الرسالة / طلب عرض سعر' : 'Message / Quote Request';
  String get sendMessage => isAr ? 'إرسال الرسالة' : 'Send Message';
  String get messageSent => isAr ? 'تم الإرسال! سنتواصل معك قريباً.' : 'Message sent! We will contact you soon.';

  // Dashboard
  String get ownerDashboard => isAr ? 'لوحة التحكم' : 'Owner Dashboard';
  String get stats => isAr ? 'إحصائيات' : 'Stats';
  String get products => isAr ? 'المنتجات' : 'Products';
  String get categories => isAr ? 'الأقسام' : 'Categories';
  String get orders => isAr ? 'الطلبات' : 'Orders';
  String get inquiries => isAr ? 'الاستفسارات' : 'Inquiries';
  String get exit => isAr ? 'خروج' : 'Exit';
  String get totalRevenue => isAr ? 'إجمالي الإيرادات' : 'Total Revenue';
  String get totalOrders => isAr ? 'إجمالي الطلبات' : 'Total Orders';
  String get topViewed => isAr ? 'الأكثر مشاهدة' : 'Top Viewed Products';
  String get addProduct => isAr ? 'إضافة منتج' : 'Add Product';
  String get editProduct => isAr ? 'تعديل المنتج' : 'Edit Product';
  String get productName => isAr ? 'اسم المنتج' : 'Product Name';
  String get description => isAr ? 'الوصف' : 'Description';
  String get price => isAr ? 'السعر (\$)' : 'Price (\$)';
  String get discountPercent => isAr ? 'نسبة الخصم %' : 'Discount %';
  String get imageUrls => isAr ? 'روابط الصور (مفصولة بفاصلة)' : 'Image URLs (comma-separated)';
  String get category => isAr ? 'القسم' : 'Category';
  String get addCategory => isAr ? 'إضافة قسم' : 'Add Category';
  String get editCategory => isAr ? 'تعديل القسم' : 'Edit Category';
  String get categoryName => isAr ? 'اسم القسم' : 'Category Name';
  String get emojiIcon => isAr ? 'أيقونة إيموجي (مثل 🛋️)' : 'Emoji Icon (e.g. 🛋️)';
  String get updateStatus => isAr ? 'تحديث الحالة' : 'Update Status';
  String get noOrders => isAr ? 'لا توجد طلبات بعد.' : 'No orders yet.';
  String get noInquiries => isAr ? 'لا توجد استفسارات بعد.' : 'No inquiries yet.';
  String get ownerAccess => isAr ? 'دخول الأونر' : 'Owner Access';
  String get enterPassword => isAr ? 'أدخل كلمة المرور' : 'Enter password';
  String get enter => isAr ? 'دخول' : 'Enter';
  String get wrongPassword => isAr ? 'كلمة المرور غير صحيحة' : 'Incorrect password';
  String get newBadge => isAr ? 'جديد' : 'new';
}