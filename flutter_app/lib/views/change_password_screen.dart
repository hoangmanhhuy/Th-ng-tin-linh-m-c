import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    _currentCtrl.clear();
    _newCtrl.clear();
    _confirmCtrl.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.emerald50, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 36),
            ),
            const SizedBox(height: 16),
            const Text('Đổi mật khẩu thành công!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Mật khẩu mới của vị đã được cập nhật. Vui lòng sử dụng mật khẩu mới cho lần đăng nhập tiếp theo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // back to settings
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Xong', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
        ),
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.red100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: AppColors.red100, borderRadius: BorderRadius.circular(14)),
                      child: const Icon(LucideIcons.lock, size: 22, color: AppColors.red),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bảo mật tài khoản', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray800)),
                          SizedBox(height: 4),
                          Text(
                            'Mật khẩu nên có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.',
                            style: TextStyle(fontSize: 11, color: AppColors.gray500, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _PasswordField(
                controller: _currentCtrl,
                label: 'Mật khẩu hiện tại',
                hint: 'Nhập mật khẩu đang dùng',
                show: _showCurrent,
                onToggle: () => setState(() => _showCurrent = !_showCurrent),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại';
                  if (v.length < 4) return 'Mật khẩu quá ngắn';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _PasswordField(
                controller: _newCtrl,
                label: 'Mật khẩu mới',
                hint: 'Tối thiểu 8 ký tự',
                show: _showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                  if (v.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
                  if (v == _currentCtrl.text) return 'Mật khẩu mới phải khác mật khẩu cũ';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _PasswordField(
                controller: _confirmCtrl,
                label: 'Xác nhận mật khẩu mới',
                hint: 'Nhập lại mật khẩu mới',
                show: _showConfirm,
                onToggle: () => setState(() => _showConfirm = !_showConfirm),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu mới';
                  if (v != _newCtrl.text) return 'Mật khẩu xác nhận không khớp';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('CẬP NHẬT MẬT KHẨU', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool show;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.show,
    required this.onToggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.gray600)),
        ),
        TextFormField(
          controller: controller,
          obscureText: !show,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.gray300, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.red, width: 2),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                show ? LucideIcons.eyeOff : LucideIcons.eye,
                size: 18,
                color: AppColors.gray400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
