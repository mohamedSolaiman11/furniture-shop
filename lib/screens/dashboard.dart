import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final width = MediaQuery.of(ctx).size.width;
    final bool isDesktop = width > 900;
    
    final tabs = [s.stats, s.products, s.categories, s.orders, s.inquiries];

    return Scaffold(
      appBar: AppBar(
        title: Text(s.ownerDashboard.toUpperCase(), style: const TextStyle(letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined),
            tooltip: s.exit,
            onPressed: () => store.logout(),
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(tabs.length, (i) => GestureDetector(
                    onTap: () => setState(() => _tab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _tab == i ? AppColors.gold : Colors.transparent, width: 2)),
                      ),
                      child: Text(tabs[i].toUpperCase(), style: TextStyle(
                        color: _tab == i ? AppColors.gold : theme.textTheme.bodyMedium?.color,
                        fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold,
                      )),
                    ),
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
      body: store.isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: IndexedStack(
                index: _tab,
                children: const [
                  _StatsTab(),
                  _ProductsTab(),
                  _CategoriesTab(),
                  _OrdersTab(),
                  _InquiriesTab(),
                ],
              ),
            ),
          ),
    );
  }
}

// ── Stats Tab ────────────────────────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  const _StatsTab();
  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final top = store.topViewedProducts;
    final width = MediaQuery.of(ctx).size.width;
    final bool isDesktop = width > 1000;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 40 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: isDesktop ? 4 : (width > 600 ? 2 : 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isDesktop ? 1.8 : 1.5,
            children: [
              _MetricCard(label: s.totalRevenue, value: '${store.totalRevenue.toStringAsFixed(0)} ج.م'),
              _MetricCard(label: s.totalOrders, value: '${store.totalOrders}'),
              _MetricCard(label: s.products, value: '${store.products.length}'),
              _MetricCard(label: s.inquiries, value: '${store.inquiries.length}', badge: store.unreadInquiries > 0 ? '${store.unreadInquiries} ${s.newBadge}' : null),
            ],
          ),
          const SizedBox(height: 60),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark ? AppColors.darkSurface : AppColors.lightSurface2,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.topViewed.toUpperCase(), style: const TextStyle(fontSize: 12, letterSpacing: 3, color: AppColors.gold, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      if (top.isEmpty) 
                        SizedBox(height: 300, child: Center(child: Text(s.noData)))
                      else 
                        SizedBox(
                          height: 300,
                          child: BarChart(BarChartData(
                            backgroundColor: Colors.transparent,
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(
                                showTitles: true, reservedSize: 40,
                                getTitlesWidget: (v, _) {
                                  final idx = v.toInt();
                                  if (idx < 0 || idx >= top.length) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(top[idx].name.split(' ').first, style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10)),
                                  );
                                },
                              )),
                            ),
                            barGroups: top.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
                              BarChartRodData(toY: e.value.viewCount.toDouble(), color: AppColors.gold, width: isDesktop ? 40 : 24, borderRadius: BorderRadius.circular(2)),
                            ])).toList(),
                          )),
                        ),
                    ],
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 32),
              if (isDesktop) 
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    height: 435,
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ? AppColors.darkSurface : AppColors.lightSurface2,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.isAr ? "نظرة سريعة" : "QUICK VIEW", style: const TextStyle(fontSize: 12, letterSpacing: 3, color: AppColors.gold, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 32),
                        _quickStatRow(s.isAr ? "معدل التحويل" : "Conversion", "3.2%"),
                        _quickStatRow(s.isAr ? "زوار اليوم" : "Visitors", "1,240"),
                        _quickStatRow(s.isAr ? "متوسط الطلب" : "Avg. Order", "12,400 ج.م"),
                        const Spacer(),
                        ElevatedButton(onPressed: () {}, child: Text(s.isAr ? "تقرير كامل" : "FULL REPORT")),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickStatRow(String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: const TextStyle(fontSize: 13, color: AppColors.darkMuted)),
        Text(v, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.gold)),
      ],
    ),
  );
}

class _MetricCard extends StatelessWidget {
  final String label, value;
  final String? badge;
  const _MetricCard({required this.label, required this.value, this.badge});
  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? AppColors.darkSurface : AppColors.lightSurface2,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(label.toUpperCase(), style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          FittedBox(
            child: Row(children: [
              Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 28, fontWeight: FontWeight.w300, fontFamily: 'Cormorant Garamond')),
              if (badge != null) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2)), child: Text(badge!, style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)))]
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Products Tab ─────────────────────────────────────────────────────────────
class _ProductsTab extends StatelessWidget {
  const _ProductsTab();
  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final isDesktop = MediaQuery.of(ctx).size.width > 900;

    return Scaffold(
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 16, vertical: 32),
        itemCount: store.products.length,
        separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
        itemBuilder: (_, i) {
          final p = store.products[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: ClipRRect(borderRadius: BorderRadius.circular(2), child: Image.network(p.images.first, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image))),
            title: Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
            subtitle: Text('${p.finalPrice.toStringAsFixed(0)} ج.م', style: const TextStyle(color: AppColors.gold, fontSize: 14)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 22), onPressed: () => _showProductForm(ctx, store, s, p)),
              IconButton(icon: const Icon(Icons.delete_outline, size: 22, color: AppColors.error), onPressed: () => store.deleteProduct(p.id)),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(ctx, store, s, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductForm(BuildContext ctx, StoreProvider store, s, Product? existing) {
    final theme = Theme.of(ctx);
    final nameCtrl = TextEditingController(text: existing?.name);
    final descCtrl = TextEditingController(text: existing?.description);
    final priceCtrl = TextEditingController(text: existing?.price.toStringAsFixed(0));
    final matCtrl = TextEditingController(text: existing?.material);
    final imgCtrl = TextEditingController(text: existing?.images.join(', '));
    final discountCtrl = TextEditingController(text: existing?.discountPercent?.toStringAsFixed(0) ?? '');
    String selCat = existing?.categoryId ?? (store.categories.isNotEmpty ? store.categories.first.id : '');

    showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (context, setSt) => AlertDialog(
          backgroundColor: theme.cardTheme.color,
          title: Text(existing == null ? s.addProduct.toUpperCase() : s.editProduct.toUpperCase(), style: const TextStyle(color: AppColors.gold, letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: nameCtrl, decoration: InputDecoration(labelText: s.productName)),
                const SizedBox(height: 16),
                TextField(controller: descCtrl, maxLines: 3, decoration: InputDecoration(labelText: s.description)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: s.price))),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: discountCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: s.discountPercent))),
                ]),
                const SizedBox(height: 16),
                TextField(controller: matCtrl, decoration: InputDecoration(labelText: s.material)),
                const SizedBox(height: 16),
                TextField(controller: imgCtrl, decoration: InputDecoration(labelText: s.imageUrls)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selCat.isEmpty ? null : selCat,
                  dropdownColor: theme.cardTheme.color,
                  decoration: InputDecoration(labelText: s.category),
                  items: store.categories.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.icon} ${c.name}'))).toList(),
                  onChanged: (v) => setSt(() => selCat = v ?? ""),
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel, style: const TextStyle(color: AppColors.gold))),
            ElevatedButton(
              onPressed: () {
                final imgs = imgCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                final p = Product(
                  id: existing?.id ?? _uuid.v4(),
                  name: nameCtrl.text, 
                  description: descCtrl.text,
                  price: double.tryParse(priceCtrl.text) ?? 0,
                  discountPercent: discountCtrl.text.isEmpty ? null : double.tryParse(discountCtrl.text),
                  categoryId: selCat, 
                  material: matCtrl.text,
                  images: imgs.isEmpty ? ['https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800'] : imgs,
                  reviews: existing?.reviews ?? [], 
                  viewCount: existing?.viewCount ?? 0,
                );
                existing == null ? store.addProduct(p) : store.updateProduct(p);
                Navigator.pop(ctx);
              },
              child: Text(existing == null ? s.add.toUpperCase() : s.save.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Categories Tab ───────────────────────────────────────────────────────────
class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();
  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final isDesktop = MediaQuery.of(ctx).size.width > 900;

    return Scaffold(
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 16, vertical: 32),
        itemCount: store.categories.length,
        separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
        itemBuilder: (_, i) {
          final c = store.categories[i];
          return ListTile(
            leading: Text(c.icon, style: const TextStyle(fontSize: 28)),
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 22), onPressed: () => _showForm(ctx, store, s, c)),
              IconButton(icon: const Icon(Icons.delete_outline, size: 22, color: AppColors.error), onPressed: () => store.deleteCategory(c.id)),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(ctx, store, s, null), child: const Icon(Icons.add)),
    );
  }

  void _showForm(BuildContext ctx, StoreProvider store, s, dynamic existing) {
    final theme = Theme.of(ctx);
    final nameCtrl = TextEditingController(text: existing?.name);
    final iconCtrl = TextEditingController(text: existing?.icon);
    final imgCtrl = TextEditingController(text: existing?.imageUrl);
    
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardTheme.color,
        title: Text(existing == null ? s.addCategory.toUpperCase() : s.editCategory.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: s.categoryName)),
          const SizedBox(height: 16),
          TextField(controller: iconCtrl, decoration: InputDecoration(labelText: s.emojiIcon)),
          const SizedBox(height: 16),
          TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: "Image URL")),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel, style: const TextStyle(color: AppColors.gold))),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;
              existing == null 
                ? store.addCategory(nameCtrl.text, iconCtrl.text.isEmpty ? '🛋️' : iconCtrl.text, img: imgCtrl.text)
                : store.updateCategory(existing.id, nameCtrl.text, iconCtrl.text, img: imgCtrl.text);
              Navigator.pop(ctx);
            },
            child: Text(existing == null ? s.add.toUpperCase() : s.save.toUpperCase()),
          ),
        ],
      ),
    );
  }
}

// ── Orders Tab ────────────────────────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  const _OrdersTab();
  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final theme = Theme.of(ctx);
    final s = ctx.watch<SettingsProvider>().strings;
    final isDesktop = MediaQuery.of(ctx).size.width > 900;

    if (store.orders.isEmpty) return Center(child: Text(s.noOrders, style: TextStyle(color: theme.textTheme.bodyMedium?.color)));

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 16, vertical: 32),
      itemCount: store.orders.length,
      separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
      itemBuilder: (_, i) {
        final o = store.orders[i];
        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 8),
          title: Text('#${o.id} - ${o.customerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
          subtitle: Text('${o.total.toStringAsFixed(0)} ج.م - ${o.statusLabel}', style: TextStyle(color: AppColors.gold, fontSize: 13)),
          children: [
            ...o.items.map((item) => ListTile(title: Text(item.product.name, style: const TextStyle(fontSize: 14)), trailing: Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.bold)))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: DropdownButtonFormField<OrderStatus>(
                value: o.status,
                dropdownColor: theme.cardTheme.color,
                decoration: InputDecoration(labelText: s.updateStatus),
                items: OrderStatus.values.map((st) => DropdownMenuItem(value: st, child: Text(st.name.toUpperCase(), style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (st) => st != null ? store.updateOrderStatus(o.id, st) : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Inquiries Tab ─────────────────────────────────────────────────────────────
class _InquiriesTab extends StatelessWidget {
  const _InquiriesTab();
  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final isDesktop = MediaQuery.of(ctx).size.width > 900;

    if (store.inquiries.isEmpty) return Center(child: Text(s.noInquiries, style: TextStyle(color: theme.textTheme.bodyMedium?.color)));

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 16, vertical: 32),
      itemCount: store.inquiries.length,
      separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
      itemBuilder: (_, i) {
        final inq = store.inquiries[i];
        return InkWell(
          onTap: () => store.markInquiryRead(inq.id),
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: inq.isRead ? Colors.transparent : AppColors.gold.withOpacity(0.03),
              borderRadius: BorderRadius.circular(4),
              border: inq.isRead ? null : Border.all(color: AppColors.gold.withOpacity(0.15)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(inq.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.5)),
                if (!inq.isRead) Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
              ]),
              const SizedBox(height: 6),
              Text(inq.phone, style: TextStyle(color: AppColors.gold, fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Text(inq.message, style: TextStyle(color: theme.textTheme.bodyMedium?.color, height: 1.7, fontSize: 15)),
            ]),
          ),
        );
      },
    );
  }
}
