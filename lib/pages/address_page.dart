import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final Box appBox = Hive.box('appBox');

  List<Map<String, dynamic>> addresses = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  void loadAddresses() {
    final savedAddresses = appBox.get('addresses');
    final savedSelectedIndex = appBox.get('selected_address_index');

    if (savedAddresses == null) {
      addresses = [
        {
          'label': 'Rumah',
          'name': 'Mahathir',
          'phone': '0812-3456-7890',
          'address': 'Jl. Melati No. 12, Jakarta Selatan, DKI Jakarta 12345',
        },
        {
          'label': 'Kantor',
          'name': 'Mahathir',
          'phone': '0812-3456-7890',
          'address': 'Jl. Sudirman Kav. 10, Jakarta Pusat, DKI Jakarta 10220',
        },
      ];

      selectedIndex = 0;

      appBox.put('addresses', addresses);
      appBox.put('selected_address_index', selectedIndex);
    } else {
      addresses = List<Map<String, dynamic>>.from(
        (savedAddresses as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );
      selectedIndex = savedSelectedIndex ?? 0;
    }

    setState(() {});
  }

  void saveAddresses() {
    appBox.put('addresses', addresses);
    appBox.put('selected_address_index', selectedIndex);
  }

  void selectAddress(int index) {
    setState(() {
      selectedIndex = index;
    });
    saveAddresses();
  }

  void deleteAddress(int index) {
    if (addresses.length == 1) return;

    setState(() {
      addresses.removeAt(index);
      if (selectedIndex >= addresses.length) {
        selectedIndex = addresses.length - 1;
      }
    });

    saveAddresses();
  }

  void showAddAddressDialog() {
    final labelController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? const Color(0xff20283A) : Colors.transparent,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Alamat Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _inputLabel(theme, 'Label Alamat'),
                  const SizedBox(height: 8),
                  _textField(
                    theme: theme,
                    isDark: isDark,
                    controller: labelController,
                    hint: 'Contoh: Rumah, Kantor, Kos',
                  ),
                  const SizedBox(height: 16),
                  _inputLabel(theme, 'Nama Penerima'),
                  const SizedBox(height: 8),
                  _textField(
                    theme: theme,
                    isDark: isDark,
                    controller: nameController,
                    hint: 'Masukkan nama penerima',
                  ),
                  const SizedBox(height: 16),
                  _inputLabel(theme, 'No. Telepon'),
                  const SizedBox(height: 8),
                  _textField(
                    theme: theme,
                    isDark: isDark,
                    controller: phoneController,
                    hint: 'Masukkan nomor telepon',
                  ),
                  const SizedBox(height: 16),
                  _inputLabel(theme, 'Alamat Lengkap'),
                  const SizedBox(height: 8),
                  _textField(
                    theme: theme,
                    isDark: isDark,
                    controller: addressController,
                    hint: 'Masukkan alamat lengkap',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? const Color(0xff2A3142)
                                  : const Color(0xffD8D8E5),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (labelController.text.trim().isEmpty ||
                                nameController.text.trim().isEmpty ||
                                phoneController.text.trim().isEmpty ||
                                addressController.text.trim().isEmpty) {
                              return;
                            }

                            setState(() {
                              addresses.add({
                                'label': labelController.text.trim(),
                                'name': nameController.text.trim(),
                                'phone': phoneController.text.trim(),
                                'address': addressController.text.trim(),
                              });
                              selectedIndex = addresses.length - 1;
                            });

                            saveAddresses();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6C63FF),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(54),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
          'Alamat Pengiriman',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
              children: [
                _buildHeroHeader(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Daftar Alamat',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff1A2130)
                            : const Color(0xffF3EEFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${addresses.length} alamat',
                        style: const TextStyle(
                          color: Color(0xff7B6DFF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ...List.generate(
                  addresses.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _addressCard(
                      theme: theme,
                      isDark: isDark,
                      address: addresses[index],
                      isSelected: selectedIndex == index,
                      onTap: () => selectAddress(index),
                      onDelete: () => deleteAddress(index),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: showAddAddressDialog,
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text(
                      'Tambah Alamat Baru',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6C63FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
                  'Alamat Pengiriman',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Kelola alamat rumah, kantor, dan lokasi lainnya untuk mempercepat proses checkout.',
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
              Icons.location_on_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard({
    required ThemeData theme,
    required bool isDark,
    required Map<String, dynamic> address,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color(0xff7B6DFF)
                : isDark
                    ? const Color(0xff20283A)
                    : Colors.transparent,
            width: 1.5,
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
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1A2130) : const Color(0xffF3EEFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Color(0xff7B6DFF),
                size: 30,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address['label'] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xff1A2130)
                                : const Color(0xffF3EEFF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'Utama',
                            style: TextStyle(
                              color: Color(0xff7B6DFF),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    address['name'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address['phone'] ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    address['address'] ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.62),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff7B6DFF)
                        : isDark
                            ? const Color(0xff1A2130)
                            : const Color(0xffF3EEFF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.check_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xff7B6DFF),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xff2C1820)
                          : const Color(0xffFFECEF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _textField({
    required ThemeData theme,
    required bool isDark,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.45),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xff1A2130) : const Color(0xffF7F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? const Color(0xff283247) : Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xff7B6DFF),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
