import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/app_theme.dart';
import '../models/models.dart';
import 'priest_result_sheet.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  late MobileScannerController _controller;
  bool _torchOn = false;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;
    if (state == AppLifecycleState.resumed) {
      _controller.start();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;

      final priest = PriestDatabase.lookup(raw);
      if (priest != null) {
        _processing = true;
        await _controller.stop();
        if (!mounted) return;
        await showPriestResultSheet(
          context,
          priest,
          onDismissed: () async {
            _processing = false;
            await _controller.start();
          },
        );
        return;
      } else {
        // QR không khớp — hiển thị snackbar ngắn
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text('Mã QR không hợp lệ hoặc chưa có dữ liệu'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.gray800,
              ),
            );
        }
      }
    }
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Real camera preview
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return _CameraError(error: error.errorCode.name);
            },
          ),

          // Scan overlay (dimmed corners)
          _ScanOverlay(),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quét mã QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleTorch,
                    icon: Icon(
                      _torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                      color: _torchOn ? Colors.yellow : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Hướng camera vào mã QR của linh mục',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'App sẽ tự động nhận dạng khi phát hiện mã hợp lệ',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
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

// Overlay tối 4 góc, chừa khung vuông giữa sáng
class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const frameSize = 260.0;
    const radius = 12.0;
    const cornerLen = 32.0;
    const cornerThickness = 3.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final left = cx - frameSize / 2;
    final top = cy - frameSize / 2;
    final right = cx + frameSize / 2;
    final bottom = cy + frameSize / 2;

    // Dim overlay
    final dimPaint = Paint()..color = Colors.black.withOpacity(0.55);
    final fullPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, right, bottom),
          const Radius.circular(radius),
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, holePath),
      dimPaint,
    );

    // Corner lines
    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = cornerThickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top-left
    canvas.drawLine(Offset(left, top + cornerLen), Offset(left, top + radius), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(left, top, radius * 2, radius * 2),
      3.14159, 0.5 * 3.14159, false, cornerPaint,
    );
    canvas.drawLine(Offset(left + radius, top), Offset(left + cornerLen, top), cornerPaint);

    // Top-right
    canvas.drawLine(Offset(right - cornerLen, top), Offset(right - radius, top), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(right - radius * 2, top, radius * 2, radius * 2),
      1.5 * 3.14159, 0.5 * 3.14159, false, cornerPaint,
    );
    canvas.drawLine(Offset(right, top + radius), Offset(right, top + cornerLen), cornerPaint);

    // Bottom-left
    canvas.drawLine(Offset(left, bottom - cornerLen), Offset(left, bottom - radius), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(left, bottom - radius * 2, radius * 2, radius * 2),
      0.5 * 3.14159, 0.5 * 3.14159, false, cornerPaint,
    );
    canvas.drawLine(Offset(left + radius, bottom), Offset(left + cornerLen, bottom), cornerPaint);

    // Bottom-right
    canvas.drawLine(
        Offset(right - cornerLen, bottom), Offset(right - radius, bottom), cornerPaint);
    canvas.drawArc(
      Rect.fromLTWH(right - radius * 2, bottom - radius * 2, radius * 2, radius * 2),
      0, 0.5 * 3.14159, false, cornerPaint,
    );
    canvas.drawLine(Offset(right, bottom - radius), Offset(right, bottom - cornerLen), cornerPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CameraError extends StatelessWidget {
  final String error;
  const _CameraError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt_rounded, size: 64, color: Colors.white30),
          const SizedBox(height: 16),
          Text(
            error == 'permissionDenied'
                ? 'Chưa cấp quyền camera\nVào Cài đặt > Quyền riêng tư > Camera'
                : 'Không thể mở camera',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
