import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'vi';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _selected = prefs.getString('app_lang') ?? 'vi');
  }

  Future<void> _select(String code, bool available) async {
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Ngôn ngữ này chưa được hỗ trợ. Sẽ ra mắt sớm!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', code);
    setState(() => _selected = code);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đã chuyển sang ${_languages.firstWhere((l) => l.code == code).name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  static const _languages = [
    _LangOption(code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', subtitle: 'Vietnamese', available: true),
    _LangOption(code: 'en', name: 'English', flag: '🇺🇸', subtitle: 'English (US)', available: false),
    _LangOption(code: 'la', name: 'Latina', flag: '🇻🇦', subtitle: 'Latin (Vatican)', available: false),
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
          'Ngôn ngữ',
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
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.emerald50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.emerald100),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.emerald100, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(LucideIcons.languages, size: 22, color: AppColors.emerald600),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chọn ngôn ngữ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray800)),
                        SizedBox(height: 4),
                        Text(
                          'Ngôn ngữ hiển thị trên toàn bộ ứng dụng. Hiện tại hỗ trợ Tiếng Việt.',
                          style: TextStyle(fontSize: 11, color: AppColors.gray500, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'NGÔN NGỮ CÓ SẴN',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
              ),
              child: Column(
                children: _languages.asMap().entries.map((e) {
                  final i = e.key;
                  final lang = e.value;
                  final isSelected = lang.code == _selected;
                  final isLast = i == _languages.length - 1;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _select(lang.code, lang.available),
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Text(lang.flag, style: const TextStyle(fontSize: 28)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(lang.name, style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: lang.available ? AppColors.gray700 : AppColors.gray300,
                                        )),
                                        if (!lang.available) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.gray100,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text('Sắp ra mắt', style: TextStyle(fontSize: 9, color: AppColors.gray400, fontWeight: FontWeight.w900)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(lang.subtitle, style: TextStyle(fontSize: 11, color: lang.available ? AppColors.gray400 : AppColors.gray200)),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                                )
                              else
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.gray200, width: 2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast) const Divider(height: 1, indent: 70, color: AppColors.gray100),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _LangOption {
  final String code;
  final String name;
  final String flag;
  final String subtitle;
  final bool available;
  const _LangOption({
    required this.code,
    required this.name,
    required this.flag,
    required this.subtitle,
    required this.available,
  });
}
