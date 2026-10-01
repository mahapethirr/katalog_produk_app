import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const EditProfilePage({
    super.key,
    this.onProfileUpdated,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Box appBox = Hive.box('appBox');

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: appBox.get('profile_name', defaultValue: 'Mahathir'),
    );
    emailController = TextEditingController(
      text: appBox.get('profile_email', defaultValue: 'mahathir@email.com'),
    );
    phoneController = TextEditingController(
      text: appBox.get('profile_phone', defaultValue: '0812-3456-7890'),
    );
    bioController = TextEditingController(
      text: appBox.get(
        'profile_bio',
        defaultValue: 'Flutter Developer Pemula',
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveProfile() {
    appBox.put('profile_name', nameController.text.trim());
    appBox.put('profile_email', emailController.text.trim());
    appBox.put('profile_phone', phoneController.text.trim());
    appBox.put('profile_bio', bioController.text.trim());

    widget.onProfileUpdated?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Edit Profil',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xff20283A)
                        : Colors.transparent,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff1A2130)
                            : const Color(0xffF3EEFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 48,
                        color: Color(0xff7B6DFF),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _inputLabel(context, 'Nama Lengkap'),
                    const SizedBox(height: 8),
                    _textField(
                      context: context,
                      controller: nameController,
                    ),

                    const SizedBox(height: 18),
                    _inputLabel(context, 'Email'),
                    const SizedBox(height: 8),
                    _textField(
                      context: context,
                      controller: emailController,
                    ),

                    const SizedBox(height: 18),
                    _inputLabel(context, 'No. Telepon'),
                    const SizedBox(height: 8),
                    _textField(
                      context: context,
                      controller: phoneController,
                    ),

                    const SizedBox(height: 18),
                    _inputLabel(context, 'Bio'),
                    const SizedBox(height: 8),
                    _textField(
                      context: context,
                      controller: bioController,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6C63FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _textField({
    required BuildContext context,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark
            ? const Color(0xff1A2130)
            : const Color(0xffF7F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.45),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? const Color(0xff283247)
                : Colors.transparent,
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
