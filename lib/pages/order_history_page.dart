import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final Box appBox = Hive.box('appBox');
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    final savedOrders = appBox.get('order_history');

    if (savedOrders == null) {
      final defaultOrders = [
        {
          'productName': 'Nike Air Max',
          'size': '41',
          'quantity': 1,
          'price': 1200000,
          'status': 'Selesai',
          'orderId': 'ORD-2026-001',
          'date': '01 Okt 2026',
          'image': 'assets/images/nike.png',
          'color': 0xffDFF1FF,
        },
        {
          'productName': 'Adidas Samba',
          'size': '42',
          'quantity': 1,
          'price': 1500000,
          'status': 'Dikirim',
          'orderId': 'ORD-2026-002',
          'date': '28 Sep 2026',
          'image': 'assets/images/adidas.png',
          'color': 0xffFFF1DA,
        },
        {
          'productName': 'Converse High',
          'size': '40',
          'quantity': 1,
          'price': 900000,
          'status': 'Diproses',
          'orderId': 'ORD-2026-003',
          'date': '25 Sep 2026',
          'image': 'assets/images/converse.png',
          'color': 0xffF3E7FF,
        },
      ];

      appBox.put('order_history', defaultOrders);
      orders = List<Map<String, dynamic>>.from(defaultOrders);
    } else {
      orders = List<Map<String, dynamic>>.from(
        (savedOrders as List).asMap().entries.map((entry) {
          final index = entry.key;
          final item = Map<String, dynamic>.from(entry.value);

          String fallbackImage = 'assets/images/nike.png';
          int fallbackColor = 0xffDFF1FF;

          final productName = (item['productName'] ?? '').toString();

          if (productName == 'Adidas Samba') {
            fallbackImage = 'assets/images/adidas.png';
            fallbackColor = 0xffFFF1DA;
          } else if (productName == 'Converse High') {
            fallbackImage = 'assets/images/converse.png';
            fallbackColor = 0xffF3E7FF;
          } else if (productName == 'Vans Old Skool') {
            fallbackImage = 'assets/images/vans.png';
            fallbackColor = 0xffE3F7EA;
          }

          return {
            'productName': item['productName'] ?? 'Produk',
            'size': item['size'] ?? '-',
            'quantity': item['quantity'] ?? 1,
            'price': item['price'] ?? 0,
            'status': item['status'] ?? 'Diproses',
            'orderId': item['orderId'] ?? 'ORD-2026-00${index + 1}',
            'date': item['date'] ?? '01 Okt 2026',
            'image': item['image'] ?? fallbackImage,
            'color': item['color'] ?? fallbackColor,
          };
        }),
      );

      appBox.put('order_history', orders);
    }

    setState(() {});
  }

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  int get totalOrders => orders.length;

  int get completedOrders =>
      orders.where((order) => order['status'] == 'Selesai').length;

  int get processingOrders =>
      orders.where((order) => order['status'] != 'Selesai').length;

  int get totalSpent {
    int total = 0;
    for (final order in orders) {
      total += ((order['price'] ?? 0) as int) * ((order['quantity'] ?? 1) as int);
    }
    return total;
  }

  Color getStatusBg(String status, bool isDark) {
    switch (status) {
      case 'Selesai':
        return isDark ? const Color(0xff173224) : const Color(0xffE8F7EC);
      case 'Dikirim':
        return isDark ? const Color(0xff3A2A17) : const Color(0xffFFF1E2);
      case 'Diproses':
        return isDark ? const Color(0xff241F42) : const Color(0xffEEE9FF);
      default:
        return isDark ? const Color(0xff1A2130) : const Color(0xffF1F1F5);
    }
  }

  Color getStatusText(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xff53C174);
      case 'Dikirim':
        return const Color(0xffF0A23D);
      case 'Diproses':
        return const Color(0xff8B7BFF);
      default:
        return const Color(0xffA7B0C0);
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Selesai':
        return Icons.check_circle_outline_rounded;
      case 'Dikirim':
        return Icons.local_shipping_outlined;
      case 'Diproses':
        return Icons.hourglass_bottom_rounded;
      default:
        return Icons.info_outline_rounded;
    }
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
          'Riwayat Pesanan',
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
            child: orders.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada riwayat pesanan.',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
                    children: [
                      _buildHeroHeader(),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: _summaryCard(
                              isDark: isDark,
                              icon: Icons.receipt_long_rounded,
                              title: '$totalOrders',
                              subtitle: 'Total Pesanan',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _summaryCard(
                              isDark: isDark,
                              icon: Icons.check_circle_outline_rounded,
                              title: '$completedOrders',
                              subtitle: 'Selesai',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _summaryCard(
                              isDark: isDark,
                              icon: Icons.timelapse_rounded,
                              title: '$processingOrders',
                              subtitle: 'Diproses',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xff20283A)
                                : Colors.transparent,
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
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xff1A2130)
                                    : const Color(0xffF3EEFF),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.wallet_outlined,
                                color: Color(0xff7B6DFF),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Belanja',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatPrice(totalSpent),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Daftar Pesanan',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...List.generate(
                        orders.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: _orderCard(orders[index], theme, isDark),
                        ),
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
                  'Riwayat Pesanan',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pantau semua pesanan yang pernah dibuat, mulai dari yang sedang diproses hingga selesai dikirim.',
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
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(26),
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
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1A2130) : const Color(0xffF3EEFF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: const Color(0xff7B6DFF),
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.68),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order, ThemeData theme, bool isDark) {
    final status = (order['status'] ?? 'Diproses').toString();
    final productName = (order['productName'] ?? 'Produk').toString();
    final orderId = (order['orderId'] ?? 'ORD-2026-000').toString();
    final date = (order['date'] ?? '01 Okt 2026').toString();
    final size = (order['size'] ?? '-').toString();
    final quantity = ((order['quantity'] ?? 1) as num).toInt();
    final price = ((order['price'] ?? 0) as num).toInt();
    final image = (order['image'] ?? 'assets/images/nike.png').toString();
    final color = Color(((order['color'] ?? 0xffDFF1FF) as num).toInt());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? const Color(0xff20283A) : Colors.transparent,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 40,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusBg(status, isDark),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            getStatusIcon(status),
                            size: 16,
                            color: getStatusText(status),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              color: getStatusText(status),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Order ID: $orderId',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.68),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.60),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _detailChip('Ukuran $size', isDark),
                    const SizedBox(width: 10),
                    _detailChip('$quantity item', isDark),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  formatPrice(price),
                  style: const TextStyle(
                    color: Color(0xff7B6DFF),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailChip(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1A2130) : const Color(0xffF7F7FB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? const Color(0xffC1C8D6) : const Color(0xff6E7191),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
