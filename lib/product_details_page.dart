import 'package:flutter/material.dart';
import 'package:furniture_store/models.dart';
import 'package:furniture_store/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.product.images[0];
  }

  void _launchWhatsApp() async {
    final url = "https://wa.me/1234567890?text=أنا مهتم بمنتج: ${widget.product.name}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: isDesktop ? size.width * 0.1 : 20,
          ),
          child: Column(
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildGallery()),
                    const SizedBox(width: 60),
                    Expanded(child: _buildProductInfo()),
                  ],
                )
              else
                Column(
                  children: [
                    _buildGallery(),
                    const SizedBox(height: 40),
                    _buildProductInfo(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Image.network(selectedImage, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.product.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => selectedImage = widget.product.images[index]),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: selectedImage == widget.product.images[index]
                          ? AppTheme.accentColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.product.category,
            style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Text(widget.product.name, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 16),
        Text(widget.product.price,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
        const SizedBox(height: 32),
        const Text("وصف المنتج", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(widget.product.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: _launchWhatsApp,
          icon: const Icon(Icons.chat),
          label: const Text("استفسار عبر واتساب"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 60),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),
        _buildSpecRow("الخامة", "خشب طبيعي، أقمشة فاخرة"),
        _buildSpecRow("المقاسات", "220سم × 90سم × 85سم"),
        _buildSpecRow("الضمان", "ضمان لمدة عامين"),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
