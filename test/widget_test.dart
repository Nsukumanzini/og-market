import 'package:flutter_test/flutter_test.dart';
import 'package:og_market/main.dart';
import 'package:og_market/mock_marketplace.dart';

void main() {
  testWidgets('customer starts on branded marketplace home', (tester) async {
    await tester.pumpWidget(const GijimaApp());
    await tester.pumpAndSettle();
    expect(find.text('Gijima Mfana'), findsOneWidget);
    expect(find.text('Start shopping'), findsOneWidget);
    await tester.tap(find.text('Start shopping'));
    await tester.pumpAndSettle();
    expect(find.text('Shop local'), findsOneWidget);
  });

  test('cart uses integer cents and enforces merchant boundary', () {
    final store = MockMarketplace();
    addTearDown(store.dispose);
    final p = store.product('bread');
    expect(store.add(p), true);
    expect(store.add(p), true);
    expect(store.count, 2);
    expect(store.subtotal, 3798);
    expect(store.total, 6298);
    expect(store.add(store.product('burger')), false);
    expect(store.count, 2);
    store.remove(p);
    expect(store.count, 1);
    final order = store.checkout();
    expect(order?.total, 4399);
    expect(store.count, 0);
    expect(store.orders, hasLength(1));
    expect(store.checkout(), isNull);
  });

  test('product queries and service requests are local', () {
    final store = MockMarketplace();
    addTearDown(store.dispose);
    expect(store.search(query: 'milk').single.id, 'milk');
    expect(store.search(category: 'Food'), hasLength(2));
    store.submitRequest('Collect & deliver', 'Order 42', 'Demo store', 'Ermelo');
    expect(store.requests.single.pickup, 'Demo store');
    expect(store.requests.single.delivery, 'Ermelo');
  });
}
