import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/store_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard.dart';
import 'home_screen.dart';
import 'products_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'contact_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext ctx) {
    final store = ctx.watch<StoreProvider>();
    final settings = ctx.watch<SettingsProvider>();
    final s = settings.strings;
    final width = MediaQuery.of(ctx).size.width;
    final bool isDesktop = width > 800;

    if (store.isOwner) return const DashboardScreen();

    if (store.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 40, height: 40,
                child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
              ),
              const SizedBox(height: 24),
              Text(s.isAr ? "جاري تحميل المجموعة الفاخرة..." : "LOADING LUXURY COLLECTION...",
                style: const TextStyle(color: AppColors.gold, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    final screens = [
      const HomeScreen(),
      const ProductsScreen(),
      const WishlistScreen(),
      const CartScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isDesktop ? 90 : 60,
        backgroundColor: Theme.of(ctx).appBarTheme.backgroundColor,
        centerTitle: false,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Row(
              children: [
                Text(s.heroTitle, 
                  style: TextStyle(
                    letterSpacing: isDesktop ? 12 : 6, 
                    fontSize: isDesktop ? 28 : 20,
                    fontFamily: 'Cormorant Garamond',
                    fontWeight: FontWeight.w300,
                    color: AppColors.gold,
                  )
                ),
                if (isDesktop) ...[
                  const Spacer(),
                  _navBtn(ctx, 0, s.home, store.currentTab == 0),
                  _navBtn(ctx, 1, s.shop, store.currentTab == 1),
                  _navBtn(ctx, 2, s.wishlist, store.currentTab == 2, hasDot: store.wishlist.isNotEmpty),
                  _navBtn(ctx, 3, s.cart, store.currentTab == 3, hasDot: store.cartCount > 0, labelDot: store.cartCount.toString()),
                  _navBtn(ctx, 4, s.contact, store.currentTab == 4),
                ] else const Spacer(),
              ],
            ),
          ),
        ),
        actions: isDesktop ? null : [
          IconButton(
            icon: Icon(settings.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: AppColors.gold),
            onPressed: settings.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.gold),
            onPressed: () => _showLoginDialog(ctx, s),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: store.currentTab,
        children: screens,
      ),
      bottomNavigationBar: isDesktop ? _buildDesktopFooter(ctx, settings, s) : BottomNavigationBar(
        currentIndex: store.currentTab,
        onTap: (i) => store.setTab(i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: s.home),
          BottomNavigationBarItem(icon: const Icon(Icons.grid_view_outlined), activeIcon: const Icon(Icons.grid_view), label: s.shop),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.favorite_outline),
              if (store.wishlist.isNotEmpty) Positioned(right: -2, top: -2, child: _dot()),
            ]),
            activeIcon: const Icon(Icons.favorite),
            label: s.wishlist,
          ),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.shopping_bag_outlined),
              if (store.cartCount > 0) Positioned(right: -2, top: -2, child: _dot(store.cartCount.toString())),
            ]),
            activeIcon: const Icon(Icons.shopping_bag),
            label: s.cart,
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.mail_outline), activeIcon: const Icon(Icons.mail), label: s.contact),
        ],
      ),
      floatingActionButton: store.currentTab != 4 ? FloatingActionButton(
        onPressed: () => launchUrl(Uri.parse("https://wa.me/20123456789")),
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat_outlined, color: Colors.white, size: 28),
      ) : null,
    );
  }

  Widget _buildDesktopFooter(BuildContext ctx, SettingsProvider settings, s) {
    return Container(
      height: 40,
      color: Theme.of(ctx).appBarTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: settings.toggleLocale,
            child: Text(settings.isAr ? 'ENGLISH' : 'العربية', style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(settings.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: AppColors.gold, size: 16),
            onPressed: settings.toggleTheme,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.gold, size: 16),
            onPressed: () => _showLoginDialog(ctx, s),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(BuildContext ctx, int idx, String label, bool isSelected, {bool hasDot = false, String? labelDot}) {
    return TextButton(
      onPressed: () => ctx.read<StoreProvider>().setTab(idx),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Text(label.toUpperCase(), 
                style: TextStyle(
                  color: isSelected ? AppColors.gold : AppColors.darkMuted,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )
              ),
              if (hasDot) Positioned(right: -12, top: -6, child: _dot(labelDot)),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 24 : 0,
            height: 1.5,
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }

  Widget _dot([String? label]) => Container(
    padding: const EdgeInsets.all(2),
    decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
    child: Center(
      child: Text(label ?? "", 
        style: const TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
    ),
  );

  void _showLoginDialog(BuildContext ctx, s) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(s.ownerAccess, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: s.email, prefixIcon: const Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: s.enterPassword, prefixIcon: const Icon(Icons.lock_outline)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel, style: const TextStyle(color: AppColors.gold))),
          ElevatedButton(
            onPressed: () async {
              final ok = await ctx.read<StoreProvider>().login(emailCtrl.text, passCtrl.text);
              if (ok) {
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(s.wrongPassword), backgroundColor: AppColors.error));
              }
            },
            child: Text(s.enter),
          ),
        ],
      ),
    );
  }
}
