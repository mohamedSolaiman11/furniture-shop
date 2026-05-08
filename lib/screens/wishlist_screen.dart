import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final wishlist = store.wishlist;
    final width = MediaQuery.of(ctx).size.width;
    final bool isDesktop = width > 900;

    if (wishlist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, color: AppColors.gold, size: 80),
            const SizedBox(height: 24),
            Text(s.wishlistEmpty, 
              style: Theme.of(ctx).textTheme.displayMedium?.copyWith(fontSize: 20, letterSpacing: 2)),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => store.setTab(1),
              child: Text(s.isAr ? "اكتشف المجموعة" : "BROWSE COLLECTION"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: isDesktop ? 60 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.wishlist.toUpperCase(), style: Theme.of(ctx).textTheme.headlineLarge?.copyWith(letterSpacing: 6)),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width > 1100 ? 4 : (width > 700 ? 3 : 2),
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: wishlist.length,
                    itemBuilder: (_, i) => ProductCard(
                      product: wishlist[i],
                      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: wishlist[i]))),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
