import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchQuery = '';
  final Box appBox = Hive.box('appBox');

  late List<Product> products;
  Set<int> favoriteProductIds = {};

  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int currentBannerIndex = 0;

  final List<Map<String, dynamic>> banners = [
    {
      'title': 'Temukan Sepatu\nTerbaik Buat Gaya Lo',
      'subtitle':
          'Tampilan modern, pilihan produk elegan, dan pengalaman belanja yang lebih proper.',
      'image': 'assets/images/nike.png',
      'tag': 'Koleksi Premium 2026',
      'gradient': [const Color(0xff8E63FF), const Color(0xff5B35D5)],
    },
    {
      'title': 'Classic Style\nNever Dies',
      'subtitle':
          'Pilih koleksi klasik terbaik buat tampilan santai, clean, dan tetap stylish.',
      'image': 'assets/images/converse.png',
      'tag': 'Classic Collection',
      'gradient': [const Color(0xffA56CFF), const Color(0xff7B4DFF)],
    },
    {
      'title': 'Streetwear Look\nLebih Fresh',
      'subtitle':
          'Cari produk yang cocok buat style harian lo dengan desain kekinian.',
      'image': 'assets/images/vans.png',
      'tag': 'Streetwear Drop',
      'gradient': [const Color(0xff64C7B5), const Color(0xff4E9F8F)],
    },
    {
      'title': 'Casual Modern\nLebih Elegan',
      'subtitle':
          'Desain simpel, warna clean, dan tampilan premium buat outfit harian.',
      'image': 'assets/images/adidas.png',
      'tag': 'Casual Choice',
      'gradient': [const Color(0xffF0B86E), const Color(0xffD9903D)],
    },
  ];

  @override
  void initState() {
    super.initState();

    products = [
      Product(
        id: 1,
        name: 'Nike Air Max',
        price: 1200000,
        category: 'Sneakers',
        description: 'Sepatu nyaman untuk aktivitas harian dan olahraga ringan.',
        image: 'assets/images/nike.png',
        color: const Color(0xffDFF1FF),
        rating: 4.8,
      ),
      Product(
        id: 2,
        name: 'Adidas Samba',
        price: 1500000,
        category: 'Casual',
        description: 'Model klasik dengan desain simpel dan elegan.',
        image: 'assets/images/adidas.png',
        color: const Color(0xffFFF1DA),
        rating: 4.8,
      ),
      Product(
        id: 3,
        name: 'Converse High',
        price: 900000,
        category: 'Classic',
        description: 'Cocok untuk gaya santai dan fashion sehari-hari.',
        image: 'assets/images/converse.png',
        color: const Color(0xffF3E7FF),
        rating: 4.8,
      ),
      Product(
        id: 4,
        name: 'Vans Old Skool',
        price: 1100000,
        category: 'Streetwear',
        description: 'Desain street style yang populer dan nyaman dipakai.',
        image: 'assets/images/vans.png',
        color: const Color(0xffE3F7EA),
        rating: 4.8,
      ),
    ];

    loadFavorites();
    _startBannerAutoSlide();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoSlide() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_bannerController.hasClients) return;
      int next = currentBannerIndex + 1;
      if (next >= banners.length) next = 0;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void loadFavorites() {
    final savedIds = appBox.get('favorite_ids', defaultValue: <dynamic>[]);
    favoriteProductIds = (savedIds as List).map((e) => e as int).toSet();
    setState(() {});
  }

  void saveFavorites() {
    appBox.put('favorite_ids', favoriteProductIds.toList());
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteProductIds.contains(product.id)) {
        favoriteProductIds.remove(product.id);
      } else {
        favoriteProductIds.add(product.id);
      }
      saveFavorites();
    });
  }

  bool isFavorite(Product product) => favoriteProductIds.contains(product.id);

  int getOrderCount() {
    final savedOrders = appBox.get('order_history', defaultValue: <dynamic>[]);
    return (savedOrders as List).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final favoriteProducts = products.where((product) {
      return favoriteProductIds.contains(product.id);
    }).toList();

    final pages = [
      _buildHomeContent(filteredProducts, favoriteProducts.length),
      FavoritePage(
        favoriteProducts: favoriteProducts,
        onFavoriteTap: toggleFavorite,
      ),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        favoriteCount: favoriteProducts.length,
        orderCount: getOrderCount(),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: const Color(0xff6C63FF),
          unselectedItemColor: const Color(0xff9E9E9E),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(List<Product> filteredProducts, int favoriteCount) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount;
    double childAspectRatio;
    double horizontalPadding;
    double contentWidth;

    if (width >= 1400) {
      crossAxisCount = 4;
      childAspectRatio = 0.74;
      horizontalPadding = 32;
      contentWidth = 1280;
    } else if (width >= 1100) {
      crossAxisCount = 4;
      childAspectRatio = 0.70;
      horizontalPadding = 28;
      contentWidth = 1080;
    } else if (width >= 800) {
      crossAxisCount = 3;
      childAspectRatio = 0.68;
      horizontalPadding = 24;
      contentWidth = 920;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.63;
      horizontalPadding = 20;
      contentWidth = width;
    }

    return Center(
      child: SizedBox(
        width: contentWidth,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 28),
                    _buildHeroBanner(),
                    const SizedBox(height: 18),
                    _buildIndicators(),
                    const SizedBox(height: 22),
                    _buildSearchBar(),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _infoStatCard(
                            value: '${products.length}',
                            label: 'Produk',
                            icon: Icons.inventory_2_outlined,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _infoStatCard(
                            value: '$favoriteCount',
                            label: 'Favorit',
                            icon: Icons.favorite_border_rounded,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _infoStatCard(
                            value: '${getOrderCount()}',
                            label: 'Pesanan',
                            icon: Icons.shopping_bag_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    Row(
                      children: [
                        Text(
                          'Produk Populer',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${filteredProducts.length} item',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    if (isDark)
                      Divider(
                        color: Colors.white.withOpacity(0.06),
                        height: 1,
                      ),
                  ],
                ),
              ),
            ),
            if (filteredProducts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Produk tidak ditemukan.',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        isFavorite: isFavorite(product),
                        onFavoriteTap: () => toggleFavorite(product),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                product: product,
                                isFavorite: isFavorite(product),
                                onFavoriteTap: () => toggleFavorite(product),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: childAspectRatio,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 130),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff8E63FF), Color(0xff5B35D5)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        _circleActionButton(Icons.notifications_none_rounded, theme),
        const SizedBox(width: 12),
        _circleActionButton(Icons.shopping_bag_outlined, theme),
      ],
    );
  }

  Widget _circleActionButton(IconData icon, ThemeData theme) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        color: const Color(0xff6C63FF),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return SizedBox(
      height: 340,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: banners.length,
        onPageChanged: (index) {
          setState(() {
            currentBannerIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final banner = banners[index];
          final List<Color> gradient =
              (banner['gradient'] as List).cast<Color>();

          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: _bannerText(
                    tag: banner['tag'],
                    title: banner['title'],
                    subtitle: banner['subtitle'],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Image.asset(
                      banner['image'],
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        banners.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentBannerIndex == index ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentBannerIndex == index
                ? const Color(0xff6C63FF)
                : const Color(0xffD9D7E5),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _bannerText({
    required String tag,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.82),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xff232734) : Colors.transparent,
        ),
      ),
      child: TextField(
        style: TextStyle(color: theme.colorScheme.onSurface),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search_rounded,
            color: Color(0xff6C63FF),
          ),
          hintText: 'Cari produk favorit...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.45),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _infoStatCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xff232734) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff232734) : const Color(0xffF3EEFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: const Color(0xff6C63FF),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
