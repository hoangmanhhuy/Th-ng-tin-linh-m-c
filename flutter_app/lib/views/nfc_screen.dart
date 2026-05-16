import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/models.dart';
import 'priest_result_sheet.dart';
import 'login_screen.dart';

enum _NfcStatus { checking, notAvailable, ready, scanning, error }

class NfcScreen extends StatefulWidget {
  const NfcScreen({super.key});

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  _NfcStatus _status = _NfcStatus.checking;
  bool _sessionActive = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _init();
  }

  Future<void> _init() async {
    final available = await NfcManager.instance.isAvailable();
    if (!mounted) return;
    if (!available) {
      setState(() {
        _status = _NfcStatus.notAvailable;
      });
      return;
    }
    _startSession();
  }

  Future<void> _startSession() async {
    if (_sessionActive) return;
    setState(() {
      _status = _NfcStatus.scanning;
      _sessionActive = true;
    });

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final text = _extractText(tag);
            if (text != null) {
              final priest = PriestDatabase.lookup(text);
              await NfcManager.instance.stopSession();
              _sessionActive = false;
              if (!mounted) return;
              if (priest != null) {
                setState(() { _status = _NfcStatus.ready; });
                await showPriestResultSheet(context, priest);
                if (mounted) _startSession();
              } else {
                setState(() { _status = _NfcStatus.error; });
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) _startSession();
              }
            } else {
              await NfcManager.instance.stopSession(
                errorMessage: 'Thẻ không chứa dữ liệu hợp lệ',
              );
              _sessionActive = false;
              if (mounted) {
                setState(() { _status = _NfcStatus.error; });
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) _startSession();
              }
            }
          } catch (e) {
            await NfcManager.instance.stopSession(errorMessage: 'Lỗi đọc thẻ');
            _sessionActive = false;
            if (mounted) {
              setState(() { _status = _NfcStatus.error; });
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) _startSession();
            }
          }
        },
      );
    } catch (e) {
      _sessionActive = false;
      if (!mounted) return;
      final msg = e.toString();
      // Personal Team / missing entitlement
      if (msg.contains('entitlement') || msg.contains('Missing required entitlement')) {
        setState(() { _status = _NfcStatus.notAvailable; });
      } else {
        setState(() { _status = _NfcStatus.error; });
      }
    }
  }

  // Parse NDEF text record từ NFC tag
  String? _extractText(NfcTag tag) {
    final ndef = Ndef.from(tag);
    if (ndef == null) return null;
    final msg = ndef.cachedMessage;
    if (msg == null || msg.records.isEmpty) return null;

    for (final record in msg.records) {
      // URI record
      if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
          record.type.length == 1 &&
          record.type[0] == 0x55) {
        // URI — unlikely for priest data but handle
        continue;
      }
      // Text record (type = "T")
      if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
          record.type.length == 1 &&
          record.type[0] == 0x54) {
        final payload = record.payload;
        if (payload.isEmpty) continue;
        final langLen = payload[0] & 0x3f;
        final text = utf8.decode(payload.sublist(1 + langLen));
        return text;
      }
      // Fallback: try to decode entire payload as UTF-8
      try {
        final text = utf8.decode(record.payload);
        if (text.isNotEmpty) return text;
      } catch (_) {}
    }
    return null;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (_sessionActive) {
      NfcManager.instance.stopSession();
    }
    super.dispose();
  }

  String _statusMessage(AppStrings l10n) {
    switch (_status) {
      case _NfcStatus.checking: return l10n.nfcChecking;
      case _NfcStatus.notAvailable: return l10n.nfcNotAvailable;
      case _NfcStatus.scanning: return l10n.nfcWaiting;
      case _NfcStatus.ready: return l10n.nfcReadSuccess;
      case _NfcStatus.error: return l10n.nfcStartFailed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.scanNfcCard,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (_, child) => Transform.scale(
                      scale: _status == _NfcStatus.scanning ? _pulseAnimation.value : 1.0,
                      child: child,
                    ),
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _statusColor.withOpacity(0.15),
                            _statusColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _statusColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(_statusIcon, size: 72, color: _statusColor),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    l10n.touchPriestCard,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      l10n.nfcInstruction,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray500,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  _StatusChip(status: _status, message: _statusMessage(l10n)),

                  if (_status == _NfcStatus.notAvailable) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _init,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(l10n.retryLower),
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    l10n.noNfcCard,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.gray200),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.loginWithPassword,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (_status) {
      case _NfcStatus.scanning:
        return AppColors.orange500;
      case _NfcStatus.error:
        return AppColors.red;
      case _NfcStatus.notAvailable:
        return AppColors.gray400;
      case _NfcStatus.ready:
        return AppColors.emerald;
      default:
        return AppColors.primary;
    }
  }

  IconData get _statusIcon {
    switch (_status) {
      case _NfcStatus.notAvailable:
        return Icons.nfc_rounded;
      case _NfcStatus.error:
        return Icons.error_outline_rounded;
      case _NfcStatus.ready:
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.nfc_rounded;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final _NfcStatus status;
  final String message;

  const _StatusChip({required this.status, required this.message});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;
    final Color dot;
    final Color text;

    switch (status) {
      case _NfcStatus.scanning:
        bg = AppColors.orange50;
        border = AppColors.orange100;
        dot = AppColors.orange500;
        text = AppColors.amber600;
        break;
      case _NfcStatus.error:
        bg = const Color(0xFFFEF2F2);
        border = const Color(0xFFFECACA);
        dot = AppColors.red;
        text = AppColors.red;
        break;
      case _NfcStatus.notAvailable:
        bg = AppColors.gray50;
        border = AppColors.gray200;
        dot = AppColors.gray400;
        text = AppColors.gray500;
        break;
      case _NfcStatus.ready:
        bg = AppColors.emerald50;
        border = AppColors.emerald100;
        dot = AppColors.emerald;
        text = AppColors.emerald600;
        break;
      default:
        bg = AppColors.blue50;
        border = AppColors.gray100;
        dot = AppColors.primary;
        text = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
