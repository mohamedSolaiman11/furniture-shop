import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<StoreProvider>();
      final s = context.read<SettingsProvider>().strings;
      
      if (store.pendingQuoteProduct != null) {
        setState(() {
          _msgCtrl.text = s.isAr 
              ? "أود الاستفسار عن تفاصيل وسعر قطعة: ${store.pendingQuoteProduct}"
              : "I would like to inquire about: ${store.pendingQuoteProduct}";
        });
        store.clearPendingQuote();
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit(s) {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _msgCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.isAr ? "برجاء ملء الحقول المطلوبة" : "Please fill required fields"), 
          backgroundColor: AppColors.error
        )
      );
      return;
    }

    context.read<StoreProvider>().submitInquiry(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
      message: _msgCtrl.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.messageSent), backgroundColor: AppColors.success)
    );

    _nameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext ctx) {
    final s = ctx.watch<SettingsProvider>().strings;
    final theme = Theme.of(ctx);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.contactUs.toUpperCase(), style: theme.textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(s.contactSubtitle, style: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 40),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                _buildField(s.fullName, _nameCtrl, 'John Doe', Icons.person_outline),
                const SizedBox(height: 20),
                _buildField(s.phone, _phoneCtrl, '+20 1xx xxx xxxx', Icons.phone_outlined, keyboard: TextInputType.phone),
                const SizedBox(height: 20),
                _buildField(s.email, _emailCtrl, 'john@example.com', Icons.email_outlined, keyboard: TextInputType.emailAddress),
                const SizedBox(height: 20),
                _buildField(s.message, _msgCtrl, 'How can we help you?', Icons.chat_bubble_outline, maxLines: 4),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submit(s),
                    child: Text(s.sendMessage.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          _infoTile(Icons.location_on_outlined, s.isAr ? "الموقع" : "LOCATION", "123 Luxe Design District, Cairo"),
          const SizedBox(height: 24),
          _infoTile(Icons.access_time_outlined, s.isAr ? "ساعات العمل" : "WORKING HOURS", "10:00 AM - 10:00 PM"),
          
          const SizedBox(height: 48),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => launchUrl(Uri.parse("https://wa.me/20123456789")),
              icon: const Icon(Icons.chat_outlined, size: 20),
              label: const Text("WHATSAPP SUPPORT"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(220, 55),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint, IconData icon, {int maxLines = 1, TextInputType? keyboard}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.gold)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData i, String t, String sub) => Row(
    children: [
      Icon(i, color: AppColors.gold, size: 22),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
        Text(sub, style: const TextStyle(color: AppColors.gold, fontSize: 12)),
      ]),
    ],
  );
}
