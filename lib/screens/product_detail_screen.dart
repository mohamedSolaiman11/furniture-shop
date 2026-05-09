import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/luxe_shimmer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _activeImg = 0;
  final _reviewCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  double _userRating = 5;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StoreProvider>().incrementView(widget.product.id));
  }

  void _submitReview(s) {
    if (_reviewCtrl.text.isEmpty || _nameCtrl.text.isEmpty) return;
    final review = Review(
      author: _nameCtrl.text,
      rating: _userRating,
      comment: _reviewCtrl.text,
      date: DateTime.now(),
    );
    context.read<StoreProvider>().addReview(widget.product.id, review);
    _reviewCtrl.clear(); _nameCtrl.clear();
    setState(() => _userRating = 5);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.isAr ? "تم إضافة تقييمك بنجاح" : "Review added!"), backgroundColor: AppColors.success));
  }

  @override
  Widget build(BuildContext ctx) {
    final s = ctx.watch<SettingsProvider>().strings;
    final theme = Theme.of(ctx);
    final p = widget.product;
    final isDesktop = MediaQuery.of(ctx).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name.toUpperCase(), style: const TextStyle(fontSize: 14, letterSpacing: 2)),
        elevation: 0,
      ),
      body: isDesktop ? _buildDesktop(ctx, p, s, theme) : _buildMobile(ctx, p, s, theme),
      bottomNavigationBar: isDesktop ? null : _buildBottomBar(ctx, p, s, theme),
    );
  }

  // ── Desktop Layout ──
  Widget _buildDesktop(BuildContext ctx, Product p, s, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Interactive Gallery
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Hero(
                      tag: 'prod_${p.id}',
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: p.images[_activeImg],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const LuxeShimmer(width: double.infinity, height: double.infinity),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: p.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => setState(() => _activeImg = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: _activeImg == i ? AppColors.gold : theme.dividerColor, width: 2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1),
                              child: Image.network(p.images[i], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 80),
              // Right: Detailed Info
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.material.toUpperCase(), style: const TextStyle(color: AppColors.gold, letterSpacing: 3, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(p.name, style: theme.textTheme.displayLarge?.copyWith(fontSize: 48)),
                    const SizedBox(height: 24),
                    _ratingRow(p.avgRating, p.reviews.length),
                    const SizedBox(height: 32),
                    Text('${p.finalPrice.toStringAsFixed(0)} ج.م', style: const TextStyle(color: AppColors.gold, fontSize: 36, fontWeight: FontWeight.w300, fontFamily: 'Cormorant Garamond')),
                    if (p.discountPercent != null)
                       Padding(
                         padding: const EdgeInsets.only(top: 8),
                         child: Text('${p.price.toStringAsFixed(0)} ج.م', style: TextStyle(color: theme.textTheme.bodySmall?.color, decoration: TextDecoration.lineThrough, fontSize: 16)),
                       ),
                    const SizedBox(height: 48),
                    Text(p.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.8, color: theme.textTheme.bodyMedium?.color)),
                    const SizedBox(height: 60),
                    _buildBottomBar(ctx, p, s, theme),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          _buildReviewSection(p, s, theme),
        ],
      ),
    );
  }

  // ── Mobile Layout ──
  Widget _buildMobile(BuildContext ctx, Product p, s, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'prod_${p.id}',
            child: AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                onPageChanged: (i) => setState(() => _activeImg = i),
                itemCount: p.images.length,
                itemBuilder: (_, i) => CachedNetworkImage(imageUrl: p.images[i], fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: theme.textTheme.displayMedium),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ratingRow(p.avgRating, p.reviews.length),
                    Text('${p.finalPrice.toStringAsFixed(0)} ج.م', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 32),
                _sectionHeader(s.description),
                Text(p.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                const SizedBox(height: 48),
                _buildReviewSection(p, s, theme),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingRow(double r, int count) => Row(
    children: [
      ...List.generate(5, (i) => Icon(i < r.floor() ? Icons.star : Icons.star_border, color: AppColors.gold, size: 16)),
      const SizedBox(width: 8),
      Text('($count reviews)', style: const TextStyle(fontSize: 12, color: AppColors.darkMuted)),
    ],
  );

  Widget _buildReviewSection(Product p, s, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 48),
        _sectionHeader(s.reviews),
        const SizedBox(height: 32),
        // Review Form
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: theme.cardTheme.color, border: Border.all(color: theme.dividerColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.writeReview, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: List.generate(5, (i) => IconButton(onPressed: () => setState(() => _userRating = i + 1.0), icon: Icon(i < _userRating ? Icons.star : Icons.star_border, color: AppColors.gold)))),
              TextField(controller: _nameCtrl, decoration: InputDecoration(hintText: s.yourName)),
              const SizedBox(height: 12),
              TextField(controller: _reviewCtrl, maxLines: 2, decoration: InputDecoration(hintText: s.yourReview)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => _submitReview(s), child: Text(s.submit.toUpperCase())),
            ],
          ),
        ),
        const SizedBox(height: 40),
        if (p.reviews.isEmpty) Text(s.noReviews) else ...p.reviews.reversed.map((r) => _reviewTile(r, theme)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext ctx, Product p, s, ThemeData theme) {
    return Row(children: [
      Expanded(child: ElevatedButton(onPressed: () => ctx.read<StoreProvider>().addToCart(p), child: Text(s.addToCart.toUpperCase()))),
      const SizedBox(width: 16),
      OutlinedButton.icon(
        onPressed: () {
          ctx.read<StoreProvider>().setTab(4, quoteProduct: p.name);
          if (Navigator.canPop(ctx)) Navigator.pop(ctx);
        },
        icon: const Icon(Icons.mail_outline),
        label: Text(s.isAr ? "استفسار" : "QUOTE"),
        style: OutlinedButton.styleFrom(minimumSize: const Size(120, 56)),
      ),
    ]);
  }

  Widget _sectionHeader(String t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(t.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)));
  Widget _reviewTile(Review r, ThemeData theme) => Padding(padding: const EdgeInsets.only(bottom: 32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(r.author, style: const TextStyle(fontWeight: FontWeight.bold)), Text('${r.date.day}/${r.date.month}', style: const TextStyle(fontSize: 10, color: AppColors.darkMuted))]), const SizedBox(height: 8), _ratingRow(r.rating, 0), const SizedBox(height: 8), Text(r.comment, style: TextStyle(color: theme.textTheme.bodyMedium?.color, height: 1.5))]));
}
