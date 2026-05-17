// lib/services/nfc_card_service.dart
// Service quản lý thẻ NFC của linh mục.
// Offline fallback: lưu trong memory (không mất trong session, nhưng sẽ mất khi restart).
// Khi backend sẵn sàng: tất cả sẽ persist lên server.

import '../core/app_config.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class NfcCardService {
  Future<List<NfcCard>> listCards(String priestId);
  Future<NfcCard> addCard(String priestId, String cardId);
  Future<void> deleteCard(String priestId, String cardId);
}

class RemoteNfcCardService implements NfcCardService {
  final ApiClient _client;

  // In-memory fallback khi server chưa có
  final Map<String, List<NfcCard>> _localCards = {};

  RemoteNfcCardService(this._client);

  String _cardsPath(String priestId) =>
      '${AppConfig.epPriests}/$priestId/nfc-cards';

  @override
  Future<List<NfcCard>> listCards(String priestId) async {
    try {
      final resp = await _client.get(_cardsPath(priestId));
      final data = resp.data['data'] as List<dynamic>;
      final cards = data
          .map((e) => NfcCard.fromJson(e as Map<String, dynamic>))
          .toList();
      // Sync local fallback
      _localCards[priestId] = cards;
      return cards;
    } on Exception {
      // Offline → trả local cache
      return _localCards[priestId] ?? [];
    }
  }

  @override
  Future<NfcCard> addCard(String priestId, String cardId) async {
    try {
      final resp = await _client.post(
        _cardsPath(priestId),
        data: {'cardId': cardId},
      );
      final card = NfcCard.fromJson(resp.data as Map<String, dynamic>);
      _localCards.putIfAbsent(priestId, () => []).add(card);
      return card;
    } on Exception {
      // Offline → lưu local
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
      final card = NfcCard(id: cardId, addedDate: dateStr);
      _localCards.putIfAbsent(priestId, () => []).add(card);
      return card;
    }
  }

  @override
  Future<void> deleteCard(String priestId, String cardId) async {
    try {
      await _client.delete('${_cardsPath(priestId)}/$cardId');
    } on Exception {
      // Offline → xoá local
    } finally {
      _localCards[priestId]?.removeWhere((c) => c.id == cardId);
    }
  }
}
