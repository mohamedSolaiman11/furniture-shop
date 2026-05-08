import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final s = ctx.watch<SettingsProvider>().strings;
    final cart = store.cart;
    final theme = Theme.of(ctx);

    if (cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, color: AppColors.gold, size: 64),
            const SizedBox(height: 24),
            Text(s.cartEmpty, style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => store.setTab(1),
              child: Text(s.isAr ? "اكتشف مجموعتنا" : "DISCOVER COLLECTIONS"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: cart.length,
            separatorBuilder: (_, __) => Divider(color: theme.dividerColor, height: 48),
            itemBuilder: (_, i) {
              final item = cart[i];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(
                      item.product.images.first, 
                      width: 100, height: 100, 
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name.toUpperCase(), 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(item.product.material, 
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
                        const SizedBox(height: 12),
                        Text('${item.product.finalPrice.toStringAsFixed(0)} ج.م', 
                          style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          _qtyBtn(Icons.remove, () => store.updateQty(item.product.id, item.quantity - 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          _qtyBtn(Icons.add, () => store.updateQty(item.product.id, item.quantity + 1)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => store.removeFromCart(item.product.id),
                        child: Text(s.delete, style: const TextStyle(color: AppColors.error, fontSize: 10)),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        _buildSummary(ctx, store, s, theme),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => Container(
    width: 28, height: 28,
    decoration: BoxDecoration(border: Border.all(color: AppColors.gold.withOpacity(0.3))),
    child: InkWell(onTap: onTap, child: Icon(icon, size: 14, color: AppColors.gold)),
  );

  Widget _buildSummary(BuildContext ctx, StoreProvider store, s, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? AppColors.darkBgDeep : AppColors.lightSurface2,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.total.toUpperCase(), style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12)),
              Text('${store.cartTotal.toStringAsFixed(0)} ج.م', 
                style: const TextStyle(color: AppColors.gold, fontSize: 24, fontWeight: FontWeight.w300, fontFamily: 'Cormorant Garamond')),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCheckout(ctx, store, s, theme),
              child: Text(s.proceedToOrder.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckout(BuildContext ctx, StoreProvider store, s, ThemeData theme) {
    final name = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: theme.cardTheme.color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(32, 32, 32, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.completeOrder.toUpperCase(), 
              style: const TextStyle(color: AppColors.gold, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _checkoutField(s.fullName, name, 'Ahmed Ali'),
            const SizedBox(height: 20),
            _checkoutField(s.phone, phone, '+20 1xx xxx xxxx', keyboard: TextInputType.phone),
            const SizedBox(height: 20),
            _checkoutField(s.email, email, 'example@mail.com', keyboard: TextInputType.emailAddress),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (name.text.isEmpty || phone.text.isEmpty) return;
                  store.placeOrder(name: name.text, email: email.text, phone: phone.text);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(s.orderSuccess), backgroundColor: AppColors.success));
                },
                child: Text(s.placeOrder.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkoutField(String label, TextEditingController ctrl, String hint, {TextInputType? keyboard}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.bold, color: AppColors.gold)),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          decoration: InputDecoration(hintText: hint, filled: false, contentPadding: const EdgeInsets.symmetric(vertical: 8)),
        ),
      ],
    );
  }
}
