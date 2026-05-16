import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20),
        ),
        title: Text(
          l10n.qrScreenTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.share2, color: AppColors.primary),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // QR Card
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(44),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  border: Border.all(color: AppColors.gray100),
                ),
                child: Stack(
                  children: [
                    // Corner brackets
                    ..._buildCornerBrackets(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: QrImageView(
                        data: 'https://sacredlink.church/priest/hoangmanhhuy',
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.transparent,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.primary,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Verified status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.emerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.identityVerified,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.emerald600, letterSpacing: 1.5),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'LM. PHAOLÔ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: 1),
              ),
              const Text(
                'HOÀNG MẠNH HUY',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1.1, letterSpacing: 0.5),
              ),

              const SizedBox(height: 8),

              Text(
                '${l10n.qrIdNumber} SL-PC-12051980',
                style: const TextStyle(fontSize: 12, color: AppColors.gray500),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.download, size: 16),
                      label: Text(l10n.save, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.gray700,
                        side: const BorderSide(color: AppColors.gray200),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.share2, size: 16),
                      label: Text(l10n.share, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
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

              const SizedBox(height: 24),

              Text(
                l10n.qrUsageNote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray400,
                  letterSpacing: 1,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const color = AppColors.primary;
    const size = 28.0;
    const thickness = 3.5;
    const radius = 8.0;

    Widget corner({required bool top, required bool left}) {
      return Positioned(
        top: top ? 0 : null,
        bottom: top ? null : 0,
        left: left ? 0 : null,
        right: left ? null : 0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: top ? const BorderSide(color: color, width: thickness) : BorderSide.none,
              bottom: top ? BorderSide.none : const BorderSide(color: color, width: thickness),
              left: left ? const BorderSide(color: color, width: thickness) : BorderSide.none,
              right: left ? BorderSide.none : const BorderSide(color: color, width: thickness),
            ),
            borderRadius: BorderRadius.only(
              topLeft: top && left ? const Radius.circular(radius) : Radius.zero,
              topRight: top && !left ? const Radius.circular(radius) : Radius.zero,
              bottomLeft: !top && left ? const Radius.circular(radius) : Radius.zero,
              bottomRight: !top && !left ? const Radius.circular(radius) : Radius.zero,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}
