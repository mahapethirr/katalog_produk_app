import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

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
          'Bantuan',
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
                _faqCard(
                  context,
                  isDark,
                  'Bagaimana cara menambah favorit?',
                  'Tekan ikon love pada produk di halaman Home untuk menambahkannya ke daftar favorit.',
                ),
                const SizedBox(height: 16),
                _faqCard(
                  context,
                  isDark,
                  'Bagaimana cara mengubah profil?',
                  'Buka halaman Profil, lalu tekan menu Edit Profil untuk memperbarui nama, email, nomor telepon, dan bio.',
                ),
                const SizedBox(height: 16),
                _faqCard(
                  context,
                  isDark,
                  'Apakah data tersimpan otomatis?',
                  'Ya, beberapa data seperti favorit, pengaturan, profil, dan alamat disimpan secara lokal menggunakan Hive.',
                ),
                const SizedBox(height: 16),
                _faqCard(
                  context,
                  isDark,
                  'Kenapa mode gelap tidak berubah di beberapa halaman?',
                  'Pastikan semua file halaman sudah memakai versi terbaru yang theme-aware dan lakukan full restart aplikasi.',
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
                  'Pusat Bantuan',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Temukan jawaban cepat untuk pertanyaan umum seputar penggunaan aplikasi.',
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
              Icons.help_outline_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqCard(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: theme.colorScheme.onSurface.withOpacity(0.68),
            ),
          ),
        ],
      ),
    );
  }
}
