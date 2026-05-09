import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/luxe_shimmer.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final theme = Theme.of(ctx);
    final width = MediaQuery.of(ctx).size.width;
    final bool isDesktop = width > 900;

    return Scaffold(
      body: Column(
        children: [
          // ── Search & Filter Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => store.updateFilters(q: v),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: s.search,
                        prefixIcon: const Icon(Icons.search, color: AppColors.gold, size: 20),
                        filled: true,
                        fillColor: theme.brightness == Brightness.dark ? AppColors.darkBg : AppColors.lightBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _filterChip(ctx, s.all, 'all'),
                          ...store.categories.map((c) => _filterChip(ctx, c.name, c.id)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Product Grid Area ──
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: store.isLoading 
                  ? _buildShimmerGrid(width) 
                  : store.filteredProducts.isEmpty
                    ? _buildEmptyState(s, theme)
                    : _buildProductGrid(ctx, store.filteredProducts, width),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext ctx, List filtered, double width) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 1400 ? 5 : (width > 1000 ? 4 : (width > 700 ? 3 : 2)),
        childAspectRatio: 0.78,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) => ProductCard(
        product: filtered[i],
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: filtered[i]))),
      ),
    );
  }

  Widget _buildShimmerGrid(double width) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 1400 ? 5 : (width > 1000 ? 4 : (width > 700 ? 3 : 2)),
        childAspectRatio: 0.78,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: 10,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }

  Widget _buildEmptyState(s, theme) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.search_off_outlined, size: 64, color: AppColors.gold),
      const SizedBox(height: 24),
      Text(s.noProducts, style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
    ],
  );

  Widget _filterChip(BuildContext ctx, String label, String id) {
    final store = ctx.read<StoreProvider>();
    final isSelected = store.selectedCategoryId == id;
    final theme = Theme.of(ctx);
    return GestureDetector(
      onTap: () => store.updateFilters(catId: id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.gold : Colors.transparent, width: 2)),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? AppColors.gold : theme.textTheme.bodyMedium?.color,
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
