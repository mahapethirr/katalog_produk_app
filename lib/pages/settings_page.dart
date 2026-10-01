import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'privacy_security_page.dart';
import 'help_page.dart';
import 'about_app_page.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Box appBox = Hive.box('appBox');

  late bool promoNotification;
  late bool orderNotification;
  late bool darkMode;

  @override
  void initState() {
    super.initState();
    promoNotification = appBox.get('promo_notification', defaultValue: true);
    orderNotification = appBox.get('order_notification', defaultValue: true);
    darkMode = appBox.get('dark_mode', defaultValue: widget.isDarkMode);
  }

  void saveSettings() {
    appBox.put('promo_notification', promoNotification);
    appBox.put('order_notification', orderNotification);
    appBox.put('dark_mode', darkMode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    double contentWidth;
    if (width >= 1400) {
      contentWidth = 1280;
    } else if (width >= 1100) {
      contentWidth = 1080;
    } else if (width >= 800) {
      contentWidth = 920;
    } else {
      contentWidth = width;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Pengaturan',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                _buildHeroHeader(),
                const SizedBox(height: 24),
                Text(
                  'Preferensi Aplikasi',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _settingCard(
                  isDark: isDark,
                  icon: Icons.local_offer_outlined,
                  title: 'Notifikasi Promo',
                  subtitle: 'Aktifkan info promo, diskon, dan penawaran terbaru.',
                  value: promoNotification,
                  onChanged: (value) {
                    setState(() {
                      promoNotification = value;
                    });
                    saveSettings();
                  },
                ),
                const SizedBox(height: 16),
                _settingCard(
                  isDark: isDark,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Notifikasi Pesanan',
                  subtitle: 'Status pesanan, pengiriman, dan update checkout.',
                  value: orderNotification,
                  onChanged: (value) {
                    setState(() {
                      orderNotification = value;
                    });
                    saveSettings();
                  },
                ),
                const SizedBox(height: 16),
                _settingCard(
                  isDark: isDark,
                  icon: Icons.dark_mode_outlined,
                  title: 'Mode Gelap',
                  subtitle: 'Gunakan tampilan aplikasi yang lebih gelap dan nyaman.',
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                    widget.onThemeChanged(value);
                    saveSettings();
                  },
                ),
                const SizedBox(height: 28),
                Text(
                  'Informasi Lainnya',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _infoCard(
                  isDark: isDark,
                  context: context,
                  icon: Icons.security_outlined,
                  title: 'Privasi & Keamanan',
                  subtitle: 'Pengaturan dasar untuk keamanan akun dan aktivitas aplikasi.',
                  page: const PrivacySecurityPage(),
                ),
                const SizedBox(height: 16),
                _infoCard(
                  isDark: isDark,
                  context: context,
                  icon: Icons.help_outline_rounded,
                  title: 'Bantuan',
                  subtitle: 'Temukan panduan penggunaan aplikasi dan informasi umum.',
                  page: const HelpPage(),
                ),
                const SizedBox(height: 16),
                _infoCard(
                  isDark: isDark,
                  context: context,
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Aplikasi',
                  subtitle: 'Katalog Produk versi 1.0.0 • Tampilan modern dan premium.',
                  page: const AboutAppPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff8E63FF), Color(0xff5B35D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff6C43E0).withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengaturan Aplikasi',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Atur notifikasi, tampilan, dan preferensi aplikasi sesuai kebutuhan kamu.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.84),
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xff20283A) : Colors.transparent,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1A2130) : const Color(0xffF3EEFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: const Color(0xff7B6DFF),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.68),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xff7B6DFF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor:
                isDark ? const Color(0xff394055) : const Color(0xffD8D8E5),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required bool isDark,
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? const Color(0xff20283A) : Colors.transparent,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1A2130) : const Color(0xffF3EEFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: const Color(0xff7B6DFF),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.68),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.42),
            ),
          ],
        ),
      ),
    );
  }
}
