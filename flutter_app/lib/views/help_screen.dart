import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _helpItems = [
    _HelpItemData(
      icon: Icons.nfc_rounded,
      title: 'Xác thực NFC',
      description: 'Công nghệ bảo mật cao nhất bằng cách chạm thẻ linh mục vào mặt sau điện thoại để xác thực danh tính chính thức.',
      bgColor: AppColors.orange50,
      iconColor: AppColors.orange500,
    ),
    _HelpItemData(
      icon: Icons.qr_code_rounded,
      title: 'Mã QR Định danh',
      description: 'Mỗi linh mục có một mã QR riêng. Quét mã để chia sẻ thông tin liên lạc nhanh chóng hoặc điểm danh tại các sự kiện giáo hội.',
      bgColor: AppColors.fuchsia50,
      iconColor: AppColors.fuchsia500,
    ),
    _HelpItemData(
      icon: LucideIcons.clock,
      title: 'Quản lý Xin lễ',
      description: 'Gửi yêu cầu dâng lễ trực tuyến đến văn phòng giáo phận hoặc nhận và duyệt các yêu cầu dâng lễ từ giáo dân gửi đến.',
      bgColor: AppColors.indigo50,
      iconColor: AppColors.indigo600,
    ),
    _HelpItemData(
      icon: LucideIcons.bell,
      title: 'Hệ thống Thông báo',
      description: 'Luôn cập nhật các thông báo khẩn, nhắc lịch công tác và tin tức quan trọng từ Giáo phận thông qua trung tâm thông báo.',
      bgColor: AppColors.blue50,
      iconColor: AppColors.primary,
    ),
    _HelpItemData(
      icon: LucideIcons.search,
      title: 'Tìm kiếm Linh mục',
      description: 'Dễ dàng tra cứu thông tin liên lạc và chức vụ của các linh mục trong hệ thống Digital Ecclesia toàn quốc.',
      bgColor: AppColors.slate100,
      iconColor: AppColors.slate600,
    ),
    _HelpItemData(
      icon: LucideIcons.fingerprint,
      title: 'Bảo mật Sinh trắc học',
      description: 'Sử dụng FaceID hoặc Fingerprint để bảo vệ ứng dụng, đảm bảo chỉ chính chủ mới có thể truy cập thông tin nhạy cảm.',
      bgColor: AppColors.emerald50,
      iconColor: AppColors.emerald600,
    ),
  ];

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
          'Hướng dẫn sử dụng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Welcome card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Chào mừng Linh mục,',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hệ thống Căn cước Linh mục kỹ thuật số giúp việc quản lý mục vụ và kết nối trong giáo hội trở nên thuận tiện và bảo mật hơn bao giờ hết.',
                    style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            ..._helpItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HelpItemCard(data: item),
            )),

            // Support card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CẦN HỖ TRỢ THÊM?',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nếu vị cần được hướng dẫn trực tiếp hoặc gặp sự cố kỹ thuật, vui lòng liên hệ Ban Truyền thông Giáo phận.',
                    style: TextStyle(fontSize: 12, color: AppColors.gray600, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        'GỬI YÊU CẦU HỖ TRỢ',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _HelpItemData {
  final IconData icon;
  final String title;
  final String description;
  final Color bgColor;
  final Color iconColor;

  const _HelpItemData({
    required this.icon,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.iconColor,
  });
}

class _HelpItemCard extends StatelessWidget {
  final _HelpItemData data;
  const _HelpItemCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: data.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, size: 22, color: data.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.gray800)),
                const SizedBox(height: 4),
                Text(data.description, style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
