import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/app_theme.dart';
import '../models/models.dart';
import 'priest_result_sheet.dart';

class ScanScreen extends StatefulWidget {
  /// Khi dùng trong IndexedStack, truyền isActive để kiểm soát camera.
  /// Khi push riêng lẻ (Navigator.push), mặc định là true.
  final bool isActive;
  const ScanScreen({super.key, this.isActive = true});

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
    // Nếu không active (ẩn trong IndexedStack), stop camera ngay
    if (!widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.stop();
      });
    }
  }

  @override
  void didUpdateWidget(ScanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.start();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      setState(() => _torchOn = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.isActive) return;
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
              return _CameraError(
                error: error.errorCode.name,
                controller: _controller,
              );
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
  final MobileScannerController controller;
  const _CameraError({required this.error, required this.controller});

  bool get _isPermission => error == 'permissionDenied';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPermission ? Icons.no_photography_rounded : Icons.camera_alt_rounded,
                  size: 40,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isPermission ? 'Chưa cấp quyền camera' : 'Không thể mở camera',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isPermission
                    ? 'Vào Cài đặt → Thông Tin Linh Mục\n→ Camera → bật quyền truy cập'
                    : 'Thiết bị không hỗ trợ camera\nhoặc camera đang được dùng bởi app khác',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.start(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text(
                    'THỬ LẠI',
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              if (_isPermission) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text(
                      'QUAY LẠI',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
