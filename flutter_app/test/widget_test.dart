import 'package:flutter_test/flutter_test.dart';
import 'package:thong_tin_linh_muc/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DigitalEcclesiaApp());
    await tester.pumpAndSettle();
    expect(find.byType(DigitalEcclesiaApp), findsOneWidget);
  });
}
