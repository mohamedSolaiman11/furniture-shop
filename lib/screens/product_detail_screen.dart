import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.isAr ? "شكراً لتقييمك!" : "Thank you!"), backgroundColor: AppColors.success));
  }

  @override
  Widget build(BuildContext ctx) {
    final s = ctx.watch<SettingsProvider>().strings;
    final theme = Theme.of(ctx);
    final p = widget.product;
    final isDesktop = MediaQuery.of(ctx).size.width > 900;

    return Scaffold(
      appBar: isDesktop ? AppBar(title: Text(p.name)) : null,
      body: isDesktop ? _buildDesktop(ctx, p, s, theme) : _buildMobile(ctx, p, s, theme),
      bottomNavigationBar: isDesktop ? null : _buildBottomBar(ctx, p, s, theme),
    );
  }

  // ── Desktop Layout (Side-by-Side) ──
  Widget _buildDesktop(BuildContext ctx, Product p, s, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Image Gallery
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(p.images[_activeImg], fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: p.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => setState(() => _activeImg = i),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: _activeImg == i ? AppColors.gold : theme.dividerColor, width: 2),
                              borderRadius: BorderRadius.circular(2),
                              image: DecorationImage(image: NetworkImage(p.images[i]), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              // Right: Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: theme.textTheme.displayLarge),
                    const SizedBox(height: 16),
                    _ratingStars(p.avgRating),
                    const SizedBox(height: 24),
                    Text('${p.finalPrice.toStringAsFixed(0)} ج.م', style: const TextStyle(color: AppColors.gold, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    _sectionHeader(s.material),
                    Text(p.material, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 32),
                    _sectionHeader(s.description),
                    Text(p.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.8)),
                    const SizedBox(height: 48),
                    _buildBottomBar(ctx, p, s, theme),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          const Divider(),
          _buildReviews(p, s, theme),
        ],
      ),
    );
  }

  // ── Mobile Layout (Original) ──
  Widget _buildMobile(BuildContext ctx, Product p, s, ThemeData theme) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(ctx).size.height * 0.5,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: PageView.builder(
              onPageChanged: (i) => setState(() => _activeImg = i),
              itemCount: p.images.length,
              itemBuilder: (_, i) => Image.network(p.images[i], fit: BoxFit.cover),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _ratingStars(p.avgRating),
                  Text('${p.finalPrice.toStringAsFixed(0)} ج.م', style: const TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 32),
                _sectionHeader(s.material),
                Text(p.material, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                _sectionHeader(s.description),
                Text(p.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                const SizedBox(height: 48),
                const Divider(),
                _buildReviews(p, s, theme),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(Product p, s, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        _sectionHeader(s.reviews),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: theme.cardTheme.color, borderRadius: BorderRadius.circular(4), border: Border.all(color: theme.dividerColor)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.writeReview, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(children: List.generate(5, (i) => IconButton(onPressed: () => setState(() => _userRating = i + 1.0), icon: Icon(i < _userRating ? Icons.star : Icons.star_border, color: AppColors.gold)))),
            TextField(controller: _nameCtrl, decoration: InputDecoration(hintText: s.yourName)),
            const SizedBox(height: 12),
            TextField(controller: _reviewCtrl, maxLines: 2, decoration: InputDecoration(hintText: s.yourReview)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => _submitReview(s), child: Text(s.submit.toUpperCase())),
          ]),
        ),
        const SizedBox(height: 32),
        if (p.reviews.isEmpty) Text(s.noReviews) else ...p.reviews.reversed.map((r) => _reviewTile(r, theme)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext ctx, Product p, s, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, border: Border(top: BorderSide(color: theme.dividerColor))),
      child: Row(children: [
        Expanded(child: ElevatedButton(onPressed: () => ctx.read<StoreProvider>().addToCart(p), child: Text(s.addToCart.toUpperCase()))),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () {
            ctx.read<StoreProvider>().setTab(4, quoteProduct: p.name);
            if (Navigator.canPop(ctx)) Navigator.pop(ctx);
          },
          icon: const Icon(Icons.mail_outline, size: 18),
          label: Text(s.isAr ? "استفسار" : "QUOTE"),
        ),
      ]),
    );
  }

  Widget _sectionHeader(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)));
  Widget _ratingStars(double r) => Row(children: List.generate(5, (i) => Icon(i < r.floor() ? Icons.star : (i < r ? Icons.star_half : Icons.star_border), color: AppColors.gold, size: 16)));
  Widget _reviewTile(Review r, ThemeData theme) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(r.author, style: const TextStyle(fontWeight: FontWeight.bold)), _ratingStars(r.rating)]), const SizedBox(height: 4), Text(r.comment, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13))]));
}
