import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _usernameController = TextEditingController(text: 'linhmuc@giaophan.org');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final auth = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.loginTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.loginSubtitle,
                style: const TextStyle(
                  color: AppColors.gray400,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 36),

              // Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(l10n.loginUsernameLabel),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _usernameController,
                      icon: LucideIcons.user,
                      hint: 'linhmuc@giaophan.org',
                    ),
                    const SizedBox(height: 20),
                    _buildLabel(l10n.loginPasswordLabel),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      icon: LucideIcons.lock,
                      hint: '••••••••',
                      isPassword: true,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.forgotPassword,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLoginButton(auth, context),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.gray200)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.orUseNfcCard,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gray300,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.gray200)),
                ],
              ),

              const SizedBox(height: 20),

              // NFC Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.nfc_rounded, size: 22),
                  label: Text(
                    l10n.tapPriestCard,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                l10n.notAPriest,
                style: const TextStyle(
                  color: AppColors.gray400,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.chevron_left_rounded, size: 18, color: AppColors.primary),
                label: Text(
                  l10n.backToLaityHome,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.gray400,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: AppColors.textMain,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.gray400, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: AppColors.slate50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 4)],
          ),
          child: Icon(icon, size: 16, color: AppColors.gray400),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 18,
                  color: AppColors.gray400,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthViewModel auth, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          auth.login();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.of(context).login,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
