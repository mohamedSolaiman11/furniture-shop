import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final theme = Theme.of(ctx);

    final filtered = store.filteredProducts;

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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.piecesFound(filtered.length).toUpperCase(), 
                  style: const TextStyle(fontSize: 10, letterSpacing: 2, color: AppColors.gold, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => _showPriceFilter(ctx, s, theme),
                  icon: const Icon(Icons.tune_outlined, color: AppColors.gold, size: 20),
                ),
              ],
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(s.noProducts, style: TextStyle(color: theme.textTheme.bodyMedium?.color)))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(ctx).size.width > 800 ? 4 : 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ProductCard(
                      product: filtered[i],
                      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: filtered[i]))),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext ctx, String label, String id) {
    final store = ctx.read<StoreProvider>();
    final isSelected = store.selectedCategoryId == id;
    final theme = Theme.of(ctx);
    return GestureDetector(
      onTap: () => store.updateFilters(catId: id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.gold : Colors.transparent, width: 2)),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? AppColors.gold : theme.textTheme.bodyMedium?.color,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  void _showPriceFilter(BuildContext ctx, s, ThemeData theme) {
    final store = ctx.read<StoreProvider>();
    showModalBottomSheet(
      context: ctx,
      backgroundColor: theme.dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      builder: (bctx) => StatefulBuilder(
        builder: (sctx, setSt) => Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.maxPrice.toUpperCase(), style: const TextStyle(fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.gold)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$0', style: theme.textTheme.bodySmall),
                  Text('\$${store.maxPrice.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.gold)),
                ],
              ),
              Slider(
                value: store.maxPrice,
                min: 0, max: 20000,
                onChanged: (v) { setSt(() => store.updateFilters(price: v)); },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Navigator.pop(bctx), child: Text(s.save.toUpperCase())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
