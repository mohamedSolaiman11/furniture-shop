import 'package:flutter/material.dart';
import 'package:furniture_store/main.dart';
import 'package:furniture_store/models.dart';
import 'package:furniture_store/product_details_page.dart';
import 'package:furniture_store/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  void _launchWhatsApp() async {
    const url = "https://wa.me/201014250577"; // استبدله برقمك الحقيقي
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _scrollToSection(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => FurnitureApp.of(context).toggleTheme(),
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(
              onBrowsePressed: () => _scrollToSection(size.height * 0.8),
              onWhatsAppPressed: _launchWhatsApp,
            ),
            const CategoriesSection(),
            const FeaturedProductsSection(),
            const AboutSection(),
            const ContactSection(),
            const Footer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchWhatsApp,
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final VoidCallback onBrowsePressed;
  final VoidCallback onWhatsAppPressed;

  const HeroSection({
    super.key,
    required this.onBrowsePressed,
    required this.onWhatsAppPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Container(
      height: size.height * 0.8,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&q=80&w=2000"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? size.width * 0.1 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "حوّل منزلك إلى تحفة فنية\nبأثاث راقٍ وعصري",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: isDesktop ? 64 : 36,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton(
                  onPressed: onBrowsePressed,
                  child: const Text("تصفح التشكيلة"),
                ),
                OutlinedButton(
                  onPressed: onWhatsAppPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text("تواصل عبر واتساب"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isDesktop ? size.width * 0.1 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("تصفح حسب الفئة", style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: demoCategories.length,
            itemBuilder: (context, index) {
              final cat = demoCategories[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(cat.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                  child: Text(
                    cat.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isDesktop ? size.width * 0.1 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("منتجاتنا المختارة", style: theme.textTheme.displayMedium),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 1,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 0.75,
            ),
            itemCount: demoProducts.length,
            itemBuilder: (context, index) {
              final product = demoProducts[index];
              return ProductCard(product: product);
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(product.images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(product.price, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
              );
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text("عرض التفاصيل ←", style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isDesktop ? size.width * 0.1 : 20,
      ),
      child: Row(
        children: [
          if (isDesktop)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&q=80&w=1000",
                  height: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (isDesktop) const SizedBox(width: 60),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("جودة واتقان منذ عام 1995", style: theme.textTheme.displayMedium),
                const SizedBox(height: 24),
                Text(
                  "نحن نؤمن بأن الأثاث ليس مجرد قطع خشبية، بل هو تعبير عن نمط حياتك. يضم معرضنا تشكيلات مختارة بعناية تجمع بين الجمالية العصرية والراحة الأبدية.",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                const BulletPoint(text: "خشب طبيعي عالي الجودة"),
                const BulletPoint(text: "مواد صديقة للبيئة"),
                const BulletPoint(text: "استشارات تصميم مخصصة"),
                const BulletPoint(text: "توصيل سريع وآمن"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("تواصل معنا", style: theme.textTheme.displayMedium),
          const SizedBox(height: 24),
          Text("تفضل بزيارة معرضنا أو تواصل معنا لأي استفسار.", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 32),
          Text("+20 123 456 7890", style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
          const SizedBox(height: 12),
          Text("123 شارع التصميم، المنطقة الراقية، القاهرة", style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.brightness == Brightness.dark ? Colors.black : AppTheme.primaryColor,
      padding: const EdgeInsets.all(60),
      width: double.infinity,
      child: const Center(
        child: Text(
          "© 2024 معرض الأثاث الفاخر. جميع الحقوق محفوظة.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
