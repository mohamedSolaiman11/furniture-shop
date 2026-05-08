import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final theme = Theme.of(ctx);
    final width = MediaQuery.of(ctx).size.width;
    final bool isDesktop = width > 900;
    
    // تحديد عدد المنتجات المميزة بناءً على عرض الشاشة
    final featuredCount = width > 1400 ? 10 : (width > 900 ? 8 : 4);
    final featured = store.products.where((p) => p.discountPercent != null || p.viewCount > 100).take(featuredCount).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cinematic Hero Banner ──
          Container(
            height: isDesktop ? MediaQuery.of(ctx).size.height * 0.85 : MediaQuery.of(ctx).size.height * 0.7,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=1600&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? width * 0.1 : 32, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.heroTitle, 
                          style: TextStyle(
                            color: AppColors.gold, 
                            fontSize: isDesktop ? 92 : 64, 
                            letterSpacing: isDesktop ? 16 : 12, 
                            fontWeight: FontWeight.w200, 
                            fontFamily: 'Cormorant Garamond'
                          )),
                        Text(s.heroSubtitle, 
                          style: TextStyle(color: Colors.white, fontSize: isDesktop ? 20 : 16, letterSpacing: 6, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 24),
                        Container(width: 100, height: 1, color: AppColors.gold),
                        const SizedBox(height: 24),
                        Text(s.heroTagline, 
                          style: TextStyle(color: Colors.white70, fontSize: isDesktop ? 24 : 18, fontStyle: FontStyle.italic, letterSpacing: 1)),
                        const SizedBox(height: 48),
                        ElevatedButton(
                          onPressed: () => store.setTab(1),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 48, vertical: 24),
                          ),
                          child: Text(s.exploreCollection.toUpperCase()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 48 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _sectionHeader(ctx, s.collections),
                    const SizedBox(height: 32),
                    
                    // ── Luxury Collection Cards ──
                    SizedBox(
                      height: isDesktop ? 300 : 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: store.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, i) => _CollectionItem(category: store.categories[i], isDesktop: isDesktop),
                      ),
                    ),

                    const SizedBox(height: 100),
                    _brandStory(ctx, s, isDesktop),
                    const SizedBox(height: 100),

                    _sectionHeader(ctx, s.featuredPieces),
                    const SizedBox(height: 32),
                    
                    // ── Smart Responsive Grid ──
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width > 1600 ? 5 : (width > 1100 ? 4 : (width > 800 ? 3 : 2)), 
                        childAspectRatio: isDesktop ? 0.8 : 0.75, 
                        crossAxisSpacing: 24, 
                        mainAxisSpacing: 24,
                      ),
                      itemCount: featured.length,
                      itemBuilder: (_, i) => ProductCard(
                        product: featured[i],
                        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: featured[i]))),
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                    _featuresRow(ctx, s, isDesktop),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String t) =>
      Text(t.toUpperCase(), style: Theme.of(context).textTheme.headlineLarge?.copyWith(letterSpacing: 4, fontWeight: FontWeight.bold));

  Widget _brandStory(BuildContext ctx, s, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 64 : 32),
      decoration: BoxDecoration(
        color: Theme.of(ctx).cardTheme.color,
        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(width: 2, height: isDesktop ? 120 : 80, color: AppColors.gold),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.isAr ? "دقة التفاصيل" : "THE ART OF DETAIL", 
                  style: const TextStyle(color: AppColors.gold, letterSpacing: 4, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(
                  s.isAr 
                    ? "نحن نؤمن أن الأثاث ليس مجرد قطع خشبية، بل هو استثمار في راحة وجمال منزلك للأجيال القادمة. كل قطعة نختارها تروي قصة إتقان." 
                    : "We believe that furniture is not just wood and fabric, but an investment in your home's comfort and legacy.",
                  style: Theme.of(ctx).textTheme.displaySmall?.copyWith(height: 1.5, fontSize: isDesktop ? 28 : 18, fontFamily: 'Cormorant Garamond'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuresRow(BuildContext ctx, s, bool isDesktop) {
    final features = [
      {'icon': Icons.auto_awesome_outlined, 'title': s.isAr ? 'تصميم فريد' : 'UNIQUE DESIGN'},
      {'icon': Icons.verified_user_outlined, 'title': s.isAr ? 'ضمان ممتد' : 'WARRANTY'},
      {'icon': Icons.local_shipping_outlined, 'title': s.isAr ? 'توصيل آمن' : 'SAFE DELIVERY'},
      {'icon': Icons.support_agent_outlined, 'title': s.isAr ? 'دعم متواصل' : '24/7 SUPPORT'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: features.map((f) => Expanded(
        child: Column(
          children: [
            Icon(f['icon'] as IconData, color: AppColors.gold, size: isDesktop ? 36 : 28),
            const SizedBox(height: 16),
            Text(f['title'] as String, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      )).toList(),
    );
  }
}

class _CollectionItem extends StatelessWidget {
  final dynamic category;
  final bool isDesktop;
  const _CollectionItem({required this.category, required this.isDesktop});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: () => ctx.read<StoreProvider>().setTab(1, categoryId: category.id),
      child: Container(
        width: isDesktop ? 240 : 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          image: DecorationImage(
            image: NetworkImage(category.imageUrl ?? 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.85), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomCenter,
          child: Text(category.name.toUpperCase(), 
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
        ),
      ),
    );
  }
}
