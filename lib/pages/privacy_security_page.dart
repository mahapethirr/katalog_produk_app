import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  final Box appBox = Hive.box('appBox');

  late bool biometricLock;
  late bool saveLoginSession;
  late bool activityNotification;
  late bool personalizedAds;

  @override
  void initState() {
    super.initState();
    biometricLock = appBox.get('privacy_biometric_lock', defaultValue: true);
    saveLoginSession = appBox.get('privacy_save_login', defaultValue: true);
    activityNotification =
        appBox.get('privacy_activity_notification', defaultValue: true);
    personalizedAds =
        appBox.get('privacy_personalized_ads', defaultValue: false);
  }

  void savePrivacySettings() {
    appBox.put('privacy_biometric_lock', biometricLock);
    appBox.put('privacy_save_login', saveLoginSession);
    appBox.put('privacy_activity_notification', activityNotification);
    appBox.put('privacy_personalized_ads', personalizedAds);
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
          'Privasi & Keamanan',
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
                  'Keamanan Akun',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _switchCard(
                  isDark: isDark,
                  icon: Icons.fingerprint_rounded,
                  title: 'Kunci Biometrik',
                  subtitle:
                      'Gunakan sidik jari atau face unlock untuk membuka aplikasi.',
                  value: biometricLock,
                  onChanged: (value) {
                    setState(() {
                      biometricLock = value;
                    });
                    savePrivacySettings();
                  },
                ),
                const SizedBox(height: 16),
                _switchCard(
                  isDark: isDark,
                  icon: Icons.lock_clock_outlined,
                  title: 'Simpan Sesi Login',
                  subtitle:
                      'Tetap masuk ke akun agar tidak perlu login berulang.',
                  value: saveLoginSession,
                  onChanged: (value) {
                    setState(() {
                      saveLoginSession = value;
                    });
                    savePrivacySettings();
                  },
                ),
                const SizedBox(height: 28),
                Text(
                  'Privasi Aktivitas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _switchCard(
                  isDark: isDark,
                  icon: Icons.shield_outlined,
                  title: 'Notifikasi Aktivitas',
                  subtitle:
                      'Dapatkan notifikasi saat ada aktivitas penting pada akun.',
                  value: activityNotification,
                  onChanged: (value) {
                    setState(() {
                      activityNotification = value;
                    });
                    savePrivacySettings();
                  },
                ),
                const SizedBox(height: 16),
                _switchCard(
                  isDark: isDark,
                  icon: Icons.ads_click_outlined,
                  title: 'Personalisasi Iklan',
                  subtitle:
                      'Izinkan aplikasi menampilkan rekomendasi yang lebih relevan.',
                  value: personalizedAds,
                  onChanged: (value) {
                    setState(() {
                      personalizedAds = value;
                    });
                    savePrivacySettings();
                  },
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
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privasi & Keamanan',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Lindungi akun, atur preferensi privasi, dan kelola keamanan aplikasi dengan lebih nyaman.',
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
              Icons.security_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchCard({
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
}
