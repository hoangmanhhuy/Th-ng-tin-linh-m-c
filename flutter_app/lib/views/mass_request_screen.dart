import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';
import '../models/models.dart';

// ─── Mass Request Form (Linh mục gửi yêu cầu) ───────────────────────────────

class MassRequestScreen extends StatefulWidget {
  /// Nếu mở từ trang quản lý linh mục, truyền priest để hiển thị thông tin
  final UserProfile? priest;
  const MassRequestScreen({super.key, this.priest});

  @override
  State<MassRequestScreen> createState() => _MassRequestScreenState();
}

class _MassRequestScreenState extends State<MassRequestScreen> {
  String _selectedType = 'Tạ ơn';
  final _massTypes = ['Tạ ơn', 'Cầu bình an', 'An táng', 'Hôn phối', 'Khác'];
  final _noteController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);

  static const _weekdays = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chúa Nhật'];

  String get _formattedDateTime {
    final wd = _weekdays[_selectedDate.weekday - 1];
    final d = _selectedDate.day.toString().padLeft(2, '0');
    final m = _selectedDate.month.toString().padLeft(2, '0');
    final y = _selectedDate.year;
    final h = _selectedTime.hour.toString().padLeft(2, '0');
    final min = _selectedTime.minute.toString().padLeft(2, '0');
    return '$h:$min - $wd, $d/$m/$y';
  }

  Future<void> _pickDateTime() async {
    // Bước 1: chọn ngày
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('vi', 'VN'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (pickedDate == null) return;

    // Bước 2: chọn giờ
    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: child!,
      ),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDate = pickedDate;
      _selectedTime = pickedTime;
    });
  }

  Future<void> _submit() async {
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
              decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
              child: const Icon(LucideIcons.send, color: AppColors.primary, size: 30),
            ),
            const SizedBox(height: 16),
            const Text('Đã gửi yêu cầu!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Yêu cầu dâng lễ của vị đã được gửi đến văn phòng giáo phận. Chúng tôi sẽ xác nhận sớm nhất.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // back
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
  void dispose() {
    _noteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
        ),
        title: const Column(
          children: [
            Text(
              'Xin dâng lễ',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textMain),
            ),
            Text(
              'Gửi yêu cầu xin dâng thánh lễ',
              style: TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Priest banner (nếu mở từ quản lý linh mục)
            if (widget.priest != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.indigo50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.indigo600.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(LucideIcons.user, size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('XIN LỄ CHO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.indigo600, letterSpacing: 1.5)),
                          const SizedBox(height: 2),
                          Text(
                            'LM. ${widget.priest!.holyName} ${widget.priest!.fullName}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.primary),
                          ),
                          Text(
                            widget.priest!.diocese,
                            style: const TextStyle(fontSize: 11, color: AppColors.indigo600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Mass Type
            _SectionCard(
              icon: LucideIcons.listFilter,
              iconBgColor: AppColors.blue50,
              iconColor: AppColors.primary,
              label: 'Loại lễ',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _massTypes.map((type) {
                  final isActive = type == _selectedType;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.gray50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isActive ? AppColors.primary : AppColors.gray100),
                        boxShadow: isActive
                            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isActive ? Colors.white : AppColors.gray400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // Date & Time
            _SectionCard(
              icon: LucideIcons.calendar,
              iconBgColor: AppColors.blue50,
              iconColor: AppColors.primary,
              label: 'Thời gian dự kiến',
              child: InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 16, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        _formattedDateTime,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gray700),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Chọn', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Location
            _SectionCard(
              icon: LucideIcons.mapPin,
              iconBgColor: AppColors.emerald50,
              iconColor: AppColors.emerald600,
              label: 'Địa điểm',
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên giáo xứ hoặc địa điểm...',
                  hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.gray100)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Note
            _SectionCard(
              icon: LucideIcons.fileText,
              iconBgColor: AppColors.amber50,
              iconColor: AppColors.amber600,
              label: 'Ý chỉ / Ghi chú',
              child: TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Nhập ý chỉ dâng lễ...',
                  hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.gray100)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Text(
                  'GỬI YÊU CẦU',
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ─── Mass Request Detail (Phê duyệt yêu cầu) ────────────────────────────────

class MassRequestDetailScreen extends StatelessWidget {
  const MassRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
        ),
        title: const Text(
          'Chi tiết yêu cầu',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF1E3A5F)),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Status badge
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.blue100.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.blue100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(LucideIcons.sparkles, size: 16, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text('YÊU CẦU MỚI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Yêu cầu dâng lễ từ linh mục khác cần được duyệt.',
                    style: TextStyle(fontSize: 11, color: AppColors.gray400, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Sender info
                  _DetailSection(
                    icon: LucideIcons.user,
                    title: 'THÔNG TIN LINH MỤC GỬI YÊU CẦU',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)],
                              ),
                              child: const Icon(LucideIcons.user, size: 24, color: AppColors.gray400),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('TÊN THÁNH & HỌ TÊN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1)),
                                SizedBox(height: 2),
                                Text('Phaolô Nguyễn Văn A', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(icon: LucideIcons.church, label: 'Giáo xứ hiện tại', value: 'Giáo xứ Thánh Đa Minh, TGP Sài Gòn'),
                        const SizedBox(height: 10),
                        _InfoRow(icon: LucideIcons.mapPin, label: 'Số điện thoại liên hệ', value: '090 123 4567'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Mass details
                  _DetailSection(
                    icon: LucideIcons.listFilter,
                    title: 'CHI TIẾT DÂNG LỄ',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          decoration: BoxDecoration(
                            color: AppColors.orange50,
                            border: const Border(left: BorderSide(color: AppColors.orange500, width: 4)),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('LOẠI LỄ', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.orange500, letterSpacing: 1)),
                              SizedBox(height: 2),
                              Text('Lễ Cầu Hồn', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF431407))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: AppColors.blue50, borderRadius: BorderRadius.circular(14)),
                              child: const Icon(LucideIcons.calendar, size: 20, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('THỜI GIAN DỰ KIẾN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1)),
                                SizedBox(height: 2),
                                Text('18:00 - Thứ Sáu, 24/11/2023', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.gray800)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text('Ý CHỈ / GHI CHÚ', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.gray50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '"Cầu cho linh hồn Maria mới qua đời. Xin cha dâng lễ sốt sắng."',
                            style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.gray600, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Bottom actions
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Từ chối', style: TextStyle(fontWeight: FontWeight.w900)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.gray600,
                        side: const BorderSide(color: AppColors.gray200, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Duyệt yêu cầu', style: TextStyle(fontWeight: FontWeight.w900)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _DetailSection({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 16, color: AppColors.gray400),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.gray300),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gray700)),
            ],
          ),
        ),
      ],
    );
  }
}
