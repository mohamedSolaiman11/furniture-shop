import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'luxe_shimmer.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final store = ctx.watch<StoreProvider>();
    final wishlisted = store.isWishlisted(widget.product.id);
    final p = widget.product;

    return FadeTransition(
      opacity: _fadeIn,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _isHovered ? AppColors.gold : theme.dividerColor,
                width: _isHovered ? 1 : 0.5,
              ),
              boxShadow: _isHovered 
                ? [BoxShadow(color: AppColors.gold.withOpacity(0.08), blurRadius: 20, spreadRadius: 2)]
                : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with Cache & Shimmer
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'prod_${p.id}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 800),
                            scale: _isHovered ? 1.05 : 1.0,
                            child: CachedNetworkImage(
                              imageUrl: p.images.first,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const LuxeShimmer(width: double.infinity, height: double.infinity),
                              errorWidget: (context, url, error) => Container(
                                color: theme.brightness == Brightness.dark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                                child: Icon(Icons.image_outlined, color: theme.textTheme.bodyMedium?.color, size: 32),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (p.discountPercent != null)
                        Positioned(
                          top: 12, left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            color: AppColors.gold,
                            child: Text('-${p.discountPercent!.toInt()}%',
                                style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      Positioned(
                        top: 10, right: 10,
                        child: GestureDetector(
                          onTap: () => store.toggleWishlist(p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: wishlisted ? AppColors.gold : Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              wishlisted ? Icons.favorite : Icons.favorite_border,
                              color: wishlisted ? Colors.black : Colors.white, 
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info Section
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name.toUpperCase(),
                          style: theme.textTheme.titleLarge?.copyWith(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.material,
                          style: TextStyle(fontSize: 10, color: theme.textTheme.bodySmall?.color?.withOpacity(0.6)),
                          maxLines: 1,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${p.finalPrice.toStringAsFixed(0)} ج.م',
                                    style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Cormorant Garamond')),
                                if (p.discountPercent != null)
                                  Text('${p.price.toStringAsFixed(0)} ج.م',
                                      style: TextStyle(fontSize: 9, decoration: TextDecoration.lineThrough, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5))),
                              ],
                            ),
                            _smallActionBtn(Icons.add_shopping_cart, () {
                              store.addToCart(p);
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('${p.name} added'), behavior: SnackBarBehavior.floating, width: 200, backgroundColor: AppColors.gold));
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallActionBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(border: Border.all(color: AppColors.gold.withOpacity(0.5)), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.gold, size: 14),
      ),
    );
  }
}
