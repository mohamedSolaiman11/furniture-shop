class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}

class Product {
  final String id;
  final String name;
  final String price;
  final String description;
  final List<String> images;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
  });
}

final List<Category> demoCategories = [
  Category(
    name: "غرف المعيشة",
    imageUrl: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80",
  ),
  Category(
    name: "غرف النوم",
    imageUrl: "https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=800&q=80",
  ),
  Category(
    name: "غرف الطعام",
    imageUrl: "https://images.unsplash.com/photo-1615066390971-03e4e1c36ddf?w=800&q=80",
  ),
  Category(
    name: "أثاث مكتبي",
    imageUrl: "https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800&q=80",
  ),
];

final List<Product> demoProducts = [
  Product(
    id: "1",
    name: "كنبة مخملية زمردية",
    price: "12,500 ج.م",
    description: "كنبة فاخرة من القماش المخملي مع أرجل مطلية بالذهب، مثالية لغرف المعيشة الحديثة. تتميز بالراحة والمتانة والتصميم العصري الذي يضيف لمسة من الرقي لمنزلك.",
    images: [
      "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80",
      "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=800&q=80",
      "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&q=80",
      "https://images.unsplash.com/photo-1550254478-ead40cc54513?w=800&q=80",
    ],
    category: "غرف المعيشة",
  ),
  Product(
    id: "2",
    name: "سرير بلوط مودرن",
    price: "18,000 ج.م",
    description: "إطار سرير من خشب البلوط الصلب بتصميم بسيط ومريح. يجمع بين المتانة والشكل الجمالي ليوفر لك تجربة نوم هادئة وفاخرة.",
    images: [
      "data:image/webp;base64,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",
      "https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=800&q=80",
      "https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800&q=80",
      "https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=800&q=80",
    ],
    category: "غرف النوم",
  ),
  Product(
    id: "3",
    name: "طاولة طعام رخامية",
    price: "تواصل لمعرفة السعر",
    description: "طاولة طعام رائعة بسطح رخامي طبيعي مع كراسي مبطنة مريحة. تصميم يجمع بين الفخامة والعملية ليناسب التجمعات العائلية الراقية.",
    images: [
      "https://images.unsplash.com/photo-1615066390971-03e4e1c36ddf?w=800&q=80",
      "https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=800&q=80",
      "https://images.unsplash.com/photo-1544233726-9f1d2b27be8b?w=800&q=80",
    ],
    category: "غرف الطعام",
  ),
  Product(
    id: "4",
    name: "كرسي مكتب مريح",
    price: "4,200 ج.م",
    description: "كرسي مكتب من الجلد الطبيعي مصمم لدعم الظهر وتوفير أقصى درجات الراحة أثناء العمل الطويل. قابل للتعديل ومزود بعجلات صامتة.",
    images: [
      "https://images.unsplash.com/photo-1592078615290-033ee584e267?w=800&q=80",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3laGcEfLIYdZVkciQCNs225yeRVX9Fpk5Mg&s"
      "https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=800&q=80",
      "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=800&q=80",
    ],
    category: "أثاث مكتبي",
  ),
];
