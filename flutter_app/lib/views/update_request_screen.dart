import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';

class UpdateRequestScreen extends StatefulWidget {
  const UpdateRequestScreen({super.key});

  @override
  State<UpdateRequestScreen> createState() => _UpdateRequestScreenState();
}

class _UpdateRequestScreenState extends State<UpdateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentCtrl = TextEditingController();
  String _category = 'Thông tin cá nhân';
  bool _loading = false;

  static const _categories = [
    'Thông tin cá nhân',
    'Giáo xứ / Giáo phận',
    'Học vị / Chức vụ',
    'Ngày sinh / Thụ phong',
    'Email / Điện thoại',
    'Khác',
  ];

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    _contentCtrl.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.indigo50, shape: BoxShape.circle),
              child: const Icon(LucideIcons.send, color: AppColors.indigo600, size: 30),
            ),
            const SizedBox(height: 16),
            const Text('Đã gửi đề nghị!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Đề nghị cập nhật của vị đã được gửi đến Ban Quản trị. Chúng tôi sẽ xem xét và phản hồi trong vòng 3–5 ngày làm việc.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
          'Đề nghị cập nhật',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.indigo50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.indigo50),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(14)),
                      child: const Icon(LucideIcons.undo2, size: 22, color: AppColors.indigo600),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Yêu cầu cập nhật hồ sơ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray800)),
                          SizedBox(height: 4),
                          Text(
                            'Mô tả thông tin cần thay đổi. Ban Quản trị sẽ xác minh và cập nhật trong hệ thống.',
                            style: TextStyle(fontSize: 11, color: AppColors.gray500, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text('LOẠI THÔNG TIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5)),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.gray400),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray700),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Content
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text('NỘI DUNG ĐỀ NGHỊ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5)),
              ),
              TextFormField(
                controller: _contentCtrl,
                maxLines: 6,
                maxLength: 500,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Vui lòng mô tả nội dung cần cập nhật';
                  if (v.trim().length < 10) return 'Vui lòng mô tả chi tiết hơn (tối thiểu 10 ký tự)';
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Cập nhật giáo xứ từ "Giáo xứ A" sang "Giáo xứ B" kể từ ngày 01/01/2025...',
                  hintStyle: const TextStyle(color: AppColors.gray300, fontSize: 13, height: 1.5),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.gray200)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.red)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.red, width: 2)),
                ),
              ),

              const SizedBox(height: 12),

              // Steps
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.gray100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('QUY TRÌNH XỬ LÝ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5)),
                    const SizedBox(height: 12),
                    _Step(number: '1', text: 'Gửi đề nghị → Ban Quản trị nhận được'),
                    _Step(number: '2', text: 'Xác minh thông tin (1–2 ngày làm việc)'),
                    _Step(number: '3', text: 'Cập nhật hệ thống và thông báo cho vị'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(LucideIcons.send, size: 18),
                  label: const Text('GỬI ĐỀ NGHỊ', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Center(child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.gray600, height: 1.4))),
        ],
      ),
    );
  }
}
