import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/models.dart';
import '../models/api_models.dart';
import '../services/api_client.dart';
import '../services/nfc_card_service.dart';

class NfcManagementScreen extends StatefulWidget {
  final UserProfile priest;
  const NfcManagementScreen({super.key, required this.priest});

  @override
  State<NfcManagementScreen> createState() => _NfcManagementScreenState();
}

class _NfcManagementScreenState extends State<NfcManagementScreen> {
  late final NfcCardService _service;
  List<NfcCard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = RemoteNfcCardService(context.read<ApiClient>());
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _isLoading = true);
    try {
      final cards = await _service.listCards(widget.priest.id);
      if (mounted) setState(() { _cards = cards; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addCardDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final dl10n = AppStrings.of(ctx);
        return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.orange50, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.nfc_rounded, size: 20, color: AppColors.orange500),
            ),
            const SizedBox(width: 10),
            Text(dl10n.addNfcCardTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dl10n.addNfcCardDesc,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: dl10n.nfcCardHint,
                hintStyle: const TextStyle(color: AppColors.gray400),
                prefixIcon: const Icon(Icons.nfc_rounded, color: AppColors.gray400, size: 20),
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Simulated NFC scan button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Simulate NFC scan — generate random ID
                  final ts = DateTime.now().millisecondsSinceEpoch % 100000;
                  controller.text = 'NFC-${ts.toString().padLeft(5, '0')}';
                },
                icon: const Icon(Icons.nfc_rounded, size: 18),
                label: Text(dl10n.scanNfcCardButton, style: const TextStyle(fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.orange500,
                  side: const BorderSide(color: AppColors.orange500),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(dl10n.cancel, style: const TextStyle(color: AppColors.gray400, fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(dl10n.add, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      );
      },
    );

    if (result != null && result.isNotEmpty) {
      try {
        final card = await _service.addCard(widget.priest.id, result.toUpperCase());
        if (mounted) {
          setState(() => _cards.add(card));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.of(context).cardAdded(result)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.emerald600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Không thể thêm thẻ. Vui lòng thử lại.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteCard(NfcCard card) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dl10n = AppStrings.of(ctx);
        return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(color: AppColors.red50, shape: BoxShape.circle),
              child: const Icon(LucideIcons.trash2, color: AppColors.red, size: 28),
            ),
            const SizedBox(height: 16),
            Text(dl10n.deleteNfcCard, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            Text(
              dl10n.deleteNfcCardDesc(card.id),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(dl10n.cancel, style: const TextStyle(color: AppColors.gray500, fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(dl10n.delete, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      );
      },
    );
    if (confirm == true) {
      await _service.deleteCard(widget.priest.id, card.id);
      if (mounted) {
        setState(() => _cards.removeWhere((c) => c.id == card.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.of(context).cardDeleted(card.id)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.gray800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  /// Toggle active/inactive locally (API may not support this yet)
  void _toggleCard(NfcCard card) {
    final idx = _cards.indexWhere((c) => c.id == card.id);
    if (idx < 0) return;
    setState(() {
      _cards[idx] = NfcCard(
        id: card.id,
        addedDate: card.addedDate,
        isActive: !card.isActive,
      );
    });
  }

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
        ),
        title: Column(
          children: [
            Text(l10n.nfcManagementTitle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.primary)),
            Text(
              'LM. ${AppStrings.of(context).translateHolyName(widget.priest.holyName)} ${widget.priest.fullName}',
              style: const TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: Column(
        children: [
          // Priest info banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16, offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(LucideIcons.user, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LM. ${AppStrings.of(context).translateHolyName(widget.priest.holyName)} ${widget.priest.fullName}',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.of(context).translateDiocese(widget.priest.diocese),
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.nfc_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        l10n.cardCount(_cards.length),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Text(
                  l10n.registeredCards,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _addCardDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(l10n.addCard, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cards.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        itemCount: _cards.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _NfcCardTile(
                          card: _cards[i],
                          onDelete: () => _deleteCard(_cards[i]),
                          onToggle: () => _toggleCard(_cards[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final l10n = AppStrings.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.nfc_rounded, size: 36, color: AppColors.gray300),
            ),
            const SizedBox(height: 20),
            Text(l10n.noNfcCards, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray700)),
            const SizedBox(height: 8),
            Text(
              l10n.noNfcCardsDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray400, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addCardDialog,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.addNfcCard, style: const TextStyle(fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NfcCardTile extends StatelessWidget {
  final NfcCard card;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _NfcCardTile({required this.card, required this.onDelete, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: card.isActive ? AppColors.gray100 : AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          // NFC icon
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: card.isActive ? AppColors.orange50 : AppColors.gray50,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.nfc_rounded,
              size: 22,
              color: card.isActive ? AppColors.orange500 : AppColors.gray300,
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.id,
                  style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w900,
                    color: card.isActive ? AppColors.gray800 : AppColors.gray400,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 11, color: AppColors.gray400),
                    const SizedBox(width: 4),
                    Text('${l10n.addedOn} ${card.addedDate}', style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
                  ],
                ),
              ],
            ),
          ),

          // Status + Toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: card.isActive ? AppColors.emerald50 : AppColors.gray100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: card.isActive ? AppColors.emerald : AppColors.gray400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        card.isActive ? l10n.cardActive : l10n.cardInactive,
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w900,
                          color: card.isActive ? AppColors.emerald600 : AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.red50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.trash2, size: 12, color: AppColors.red),
                      const SizedBox(width: 4),
                      Text(l10n.delete, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
