import 'package:flutter/material.dart';
import 'brand.dart';
import 'mock_marketplace.dart';

void main() => runApp(const GijimaApp());

class GijimaApp extends StatefulWidget {
  const GijimaApp({super.key});
  @override
  State<GijimaApp> createState() => _GijimaAppState();
}

class _GijimaAppState extends State<GijimaApp> {
  final store = MockMarketplace();
  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Gijima Mfana',
    debugShowCheckedModeBanner: false,
    theme: gijimaTheme(),
    home: CustomerHome(store: store),
  );
}

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key, required this.store});
  final MockMarketplace store;
  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int tab = 0;
  String filter = 'All';
  String? merchantId;
  String requestType = 'Personal shopping';
  MockMarketplace get store => widget.store;

  void shop({String category = 'All', String? merchant}) => setState(() {
    filter = category;
    merchantId = merchant;
    tab = 1;
  });
  void request(String type) => setState(() {
    requestType = type;
    tab = 2;
  });
  void add(Product p) {
    final added = store.add(p);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(added ? '${p.name} added to your cart' : 'Your cart is from another store. Check out or remove those items first.'),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) {
      final pages = [
        HomePage(store: store, onShop: () => shop(), onCategory: (c) => shop(category: c),
          onMerchant: (m) => shop(merchant: m), onRequest: request, onAdd: add,
          onAddress: () => setState(() => tab = 4)),
        ShopPage(key: ValueKey('$filter-$merchantId'), store: store, initialCategory: filter, merchantId: merchantId, onAdd: add),
        RequestsPage(key: ValueKey(requestType), store: store, initialType: requestType),
        OrdersPage(store: store),
        ProfilePage(store: store),
      ];
      return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.asset('assets/brand/logo.png', width: 40, height: 40, fit: BoxFit.cover)),
            const SizedBox(width: 10),
            const Text('Gijima Mfana', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
          ]),
          actions: [
            IconButton(
              tooltip: 'Open cart',
              icon: Badge(label: Text('${store.count}'), isLabelVisible: store.count > 0, child: const Icon(Icons.shopping_bag_outlined)),
              onPressed: () async {
                final order = await Navigator.of(context).push<DemoOrder>(MaterialPageRoute(builder: (_) => CartPage(store: store)));
                if (order != null && mounted) setState(() => tab = 3);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(top: false, child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000), child: pages[tab]))),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (index) => setState(() {
            tab = index;
            if (index == 1) { filter = 'All'; merchantId = null; }
          }),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront_rounded), label: 'Shop'),
            NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment_rounded), label: 'Requests'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      );
    },
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.store, required this.onShop, required this.onCategory, required this.onMerchant, required this.onRequest, required this.onAdd, required this.onAddress});
  final MockMarketplace store;
  final VoidCallback onShop, onAddress;
  final ValueChanged<String> onCategory, onMerchant, onRequest;
  final ValueChanged<Product> onAdd;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    children: [
      InkWell(
        onTap: onAddress,
        borderRadius: BorderRadius.circular(16),
        child: Row(children: [
          const CircleAvatar(backgroundColor: paleGreen, foregroundColor: emerald, child: Icon(Icons.location_on_rounded)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('DELIVER TO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.1)),
            Text(store.deliveryAddress, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
          ])),
          const Icon(Icons.keyboard_arrow_down_rounded),
        ]),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(colors: [Color(0xFF087F5B), Color(0xFF054E3C)]),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.bolt_rounded, color: Color(0xFFBCECD2), size: 19), SizedBox(width: 5),
            Text('YOUR LOCAL MARKETPLACE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFBCECD2), letterSpacing: 1))]),
          const SizedBox(height: 16),
          const Text('Need it?\nWe’ll get it.', style: TextStyle(fontSize: 33, height: 1.05, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 10),
          const Text('Shop nearby stores or send us a custom request.', style: TextStyle(color: Color(0xFFD5EEE4), fontSize: 14)),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: emerald),
            onPressed: onShop, icon: const Icon(Icons.shopping_cart_outlined), label: const Text('Start shopping'),
          ),
        ]),
      ),
      const SizedBox(height: 24),
      const SectionHeading('What do you need?'),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: ServiceTile(title: 'Personal shopping', subtitle: 'Tell us what to buy', icon: Icons.edit_note_rounded, onTap: () => onRequest('Personal shopping'))),
        const SizedBox(width: 12),
        Expanded(child: ServiceTile(title: 'Collect & deliver', subtitle: 'Send us to pick it up', icon: Icons.local_shipping_outlined, onTap: () => onRequest('Collect & deliver'))),
      ]),
      const SizedBox(height: 26),
      SectionHeading('Shop by category', action: 'All', onTap: onShop),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: CategoryTile('Groceries', Icons.local_grocery_store_rounded, const Color(0xFFE4F4E9), () => onCategory('Groceries'))),
        const SizedBox(width: 10),
        Expanded(child: CategoryTile('Food', Icons.restaurant_rounded, const Color(0xFFFFE8D1), () => onCategory('Food'))),
        const SizedBox(width: 10),
        Expanded(child: CategoryTile('Essentials', Icons.shopping_basket_rounded, const Color(0xFFE3ECFA), () => onCategory('Essentials'))),
      ]),
      const SizedBox(height: 24),
      SectionHeading('Stores near you', action: 'Browse', onTap: onShop),
      const SizedBox(height: 8),
      for (final m in MockMarketplace.merchants) ...[
        MerchantTile(merchant: m, onTap: () => onMerchant(m.id)),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 12),
      SectionHeading('Popular picks', action: 'See all', onTap: onShop),
      const SizedBox(height: 12),
      ProductGrid(products: MockMarketplace.products.take(4).toList(), store: store, onAdd: onAdd),
      const SizedBox(height: 18),
      const Text('DEMO • Example stores, products and prices. No real purchases.', style: TextStyle(color: Colors.grey, fontSize: 12)),
    ],
  );
}

class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20), onTap: onTap,
    child: Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(backgroundColor: paleGreen, foregroundColor: emerald, child: Icon(icon)),
      const SizedBox(height: 12),
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 5),
      Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 8),
      const Icon(Icons.arrow_forward_rounded, color: emerald, size: 18),
    ])),
  );
}

class CategoryTile extends StatelessWidget {
  const CategoryTile(this.name, this.icon, this.color, this.onTap, {super.key});
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(18), onTap: onTap,
    child: Surface(color: color, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Column(children: [Icon(icon, size: 31, color: charcoal), const SizedBox(height: 10), Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))])),
  );
}

class MerchantTile extends StatelessWidget {
  const MerchantTile({super.key, required this.merchant, required this.onTap});
  final Merchant merchant;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(20),
    child: Surface(child: Row(children: [
      Container(width: 54, height: 54, decoration: BoxDecoration(color: merchant.color, borderRadius: BorderRadius.circular(15)), child: Icon(merchant.icon, color: charcoal, size: 26)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(merchant.name, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 3), Text('${merchant.category} • ${merchant.area}', style: const TextStyle(fontSize: 12, color: Colors.grey))])),
      const Icon(Icons.chevron_right_rounded, color: emerald),
    ])),
  );
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, required this.store, required this.onAdd});
  final List<Product> products;
  final MockMarketplace store;
  final ValueChanged<Product> onAdd;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final columns = constraints.maxWidth >= 820 ? 4 : constraints.maxWidth >= 570 ? 3 : 2;
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: constraints.maxWidth < 360 ? .72 : .83),
      itemBuilder: (context, index) {
        final p = products[index];
        return Surface(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Container(width: double.infinity, decoration: BoxDecoration(color: p.color, borderRadius: BorderRadius.circular(13)), child: Icon(p.icon, size: 45, color: charcoal))),
          const SizedBox(height: 8),
          Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(store.merchant(p.merchantId).name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Row(children: [
            Expanded(child: Text(money(p.price), style: const TextStyle(fontWeight: FontWeight.w900, color: emerald))),
            IconButton.filled(tooltip: 'Add ${p.name}', onPressed: () => onAdd(p), icon: const Icon(Icons.add, size: 20), style: IconButton.styleFrom(backgroundColor: emerald, foregroundColor: Colors.white, minimumSize: const Size(34, 34), padding: EdgeInsets.zero)),
          ]),
        ]));
      },
    );
  });
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.store, required this.initialCategory, required this.merchantId, required this.onAdd});
  final MockMarketplace store;
  final String initialCategory;
  final String? merchantId;
  final ValueChanged<Product> onAdd;
  @override
  State<ShopPage> createState() => _ShopPageState();
}
class _ShopPageState extends State<ShopPage> {
  late String category = widget.initialCategory;
  late String? merchant = widget.merchantId;
  String query = '';
  @override
  Widget build(BuildContext context) {
    final results = widget.store.search(query: query, category: category, merchantId: merchant);
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Shop local', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 6), const Text('Discover products from example stores in Ermelo.'),
      const SizedBox(height: 18),
      TextField(onChanged: (value) => setState(() => query = value), decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search products or stores')),
      const SizedBox(height: 14),
      Wrap(spacing: 8, runSpacing: 4, children: [
        for (final c in ['All', 'Groceries', 'Food', 'Essentials'])
          ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)),
      ]),
      if (merchant != null) ...[
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerLeft, child: InputChip(label: Text(widget.store.merchant(merchant!).name), onDeleted: () => setState(() => merchant = null))),
      ],
      const SizedBox(height: 16),
      Text('${results.length} products', style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      if (results.isEmpty) const EmptyPanel(icon: Icons.search_off_rounded, title: 'No products found', subtitle: 'Try another search or category.')
      else ProductGrid(products: results, store: widget.store, onAdd: widget.onAdd),
    ]);
  }
}

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key, required this.store, required this.initialType});
  final MockMarketplace store;
  final String initialType;
  @override
  State<RequestsPage> createState() => _RequestsPageState();
}
class _RequestsPageState extends State<RequestsPage> {
  final form = GlobalKey<FormState>();
  final description = TextEditingController();
  final pickup = TextEditingController();
  late final delivery = TextEditingController(text: widget.store.deliveryAddress);
  late String type = widget.initialType;
  @override
  void dispose() {
    description.dispose(); pickup.dispose(); delivery.dispose(); super.dispose();
  }
  String? requiredField(String? value) => value == null || value.trim().isEmpty ? 'Required' : null;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text('Send a request', style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 6),
    const Text('Can’t find an item? Or need something collected? Tell us what you need.'),
    const SizedBox(height: 18),
    Wrap(spacing: 8, children: [
      for (final option in ['Personal shopping', 'Collect & deliver'])
        ChoiceChip(label: Text(option), selected: type == option, onSelected: (_) => setState(() => type = option)),
    ]),
    const SizedBox(height: 16),
    Surface(child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(type, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      TextFormField(controller: description, validator: requiredField, maxLines: 3, decoration: InputDecoration(labelText: type == 'Personal shopping' ? 'What should we buy?' : 'What should we collect?', hintText: 'Include quantity or order reference')),
      const SizedBox(height: 12),
      TextFormField(controller: pickup, validator: type == 'Collect & deliver' ? requiredField : null, decoration: InputDecoration(labelText: type == 'Collect & deliver' ? 'Pickup address' : 'Preferred store (optional)')),
      const SizedBox(height: 12),
      TextFormField(controller: delivery, validator: requiredField, decoration: const InputDecoration(labelText: 'Delivery address')),
      const SizedBox(height: 20),
      const Text('Demo requests are stored on this device in memory only. No courier or payment will be dispatched.', style: TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: () {
        if (!form.currentState!.validate()) return;
        widget.store.submitRequest(type, description.text, pickup.text, delivery.text);
        description.clear(); pickup.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo request submitted.')));
      }, icon: const Icon(Icons.send_rounded), label: const Text('Request quotation')),
    ]))),
    const SizedBox(height: 24),
    const SectionHeading('Your requests'),
    const SizedBox(height: 12),
    if (widget.store.requests.isEmpty) const EmptyPanel(icon: Icons.assignment_outlined, title: 'No requests yet', subtitle: 'Your requests will appear here.')
    else for (final r in widget.store.requests) ...[
      Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${r.type} • ${r.id}', style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 5), Text(r.description),
        const SizedBox(height: 5), Text('To: ${r.delivery}', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8), const StatusTag('Awaiting demo quotation'),
      ])),
      const SizedBox(height: 10),
    ],
  ]);
}

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.store});
  final MockMarketplace store;
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: store, builder: (context, _) => Scaffold(
    appBar: AppBar(title: const Text('Your cart')),
    body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: ListView(padding: const EdgeInsets.all(20), children: [
      if (store.cart.isEmpty) const EmptyPanel(icon: Icons.shopping_bag_outlined, title: 'Your cart is empty', subtitle: 'Add something from a local store.')
      else ...[
        Text(store.merchant(store.cartMerchant!).name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        for (final line in store.cart.entries) ...[
          Surface(child: Row(children: [
            CircleAvatar(backgroundColor: store.product(line.key).color, child: Icon(store.product(line.key).icon, color: charcoal)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(store.product(line.key).name, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(money(store.product(line.key).price * line.value)),
            ])),
            IconButton(tooltip: 'Remove one', onPressed: () => store.remove(store.product(line.key)), icon: const Icon(Icons.remove_circle_outline)),
            Text('${line.value}'),
            IconButton(tooltip: 'Add one', onPressed: () => store.add(store.product(line.key)), icon: const Icon(Icons.add_circle_outline)),
          ])),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Delivery address', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 6),
          Text(store.deliveryAddress),
          const Divider(height: 28),
          AmountRow('Subtotal', store.subtotal), const SizedBox(height: 8),
          const AmountRow('Demo delivery fee', MockMarketplace.deliveryFee),
          const Divider(height: 28),
          AmountRow('Total', store.total, strong: true),
          const SizedBox(height: 18),
          const StatusTag('SIMULATED ONLINE PAYMENT'),
          const SizedBox(height: 10),
          const Text('No real money is collected. No card details are requested.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () async {
            final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
              title: const Text('Simulate payment?'),
              content: Text('This completes a mock order of ${money(store.total)}. No money will be charged.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simulate')),
              ],
            ));
            if (confirm != true || !context.mounted) return;
            final order = store.checkout();
            if (order != null) Navigator.pop(context, order);
          }, icon: const Icon(Icons.credit_card_rounded), label: Text('Pay ${money(store.total)} (demo)')),
        ])),
      ],
    ])))),
  ));
}

class AmountRow extends StatelessWidget {
  const AmountRow(this.label, this.amount, {super.key, this.strong = false});
  final String label;
  final int amount;
  final bool strong;
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(label, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w500))),
    Text(money(amount), style: TextStyle(fontSize: strong ? 19 : 14, fontWeight: FontWeight.w800, color: strong ? emerald : charcoal)),
  ]);
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.store});
  final MockMarketplace store;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text('Your orders', style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 6), const Text('Track and review your simulated purchases.'),
    const SizedBox(height: 20),
    if (store.orders.isEmpty) const EmptyPanel(icon: Icons.receipt_long_outlined, title: 'No orders yet', subtitle: 'Shop something local to get started.')
    else for (final order in store.orders) ...[
      Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(order.title, style: Theme.of(context).textTheme.titleMedium)), Text(money(order.total), style: const TextStyle(color: emerald, fontWeight: FontWeight.w900))]),
        const SizedBox(height: 5), Text(order.id, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8), Text(order.detail),
        const SizedBox(height: 12), StatusTag(order.status),
      ])),
      const SizedBox(height: 12),
    ],
  ]);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.store});
  final MockMarketplace store;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  late final address = TextEditingController(text: widget.store.deliveryAddress);
  @override
  void dispose() { address.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text('Your profile', style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 20),
    const Surface(child: Row(children: [
      CircleAvatar(radius: 27, backgroundColor: paleGreen, foregroundColor: emerald, child: Icon(Icons.person_rounded, size: 28)),
      SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Demo customer', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        Text('Ermelo • Customer preview'),
      ])),
    ])),
    const SizedBox(height: 16),
    Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Delivery address', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      TextField(controller: address, decoration: const InputDecoration(labelText: 'Address')),
      const SizedBox(height: 12),
      FilledButton(onPressed: () {
        if (address.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an address.')));
          return;
        }
        widget.store.updateAddress(address.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo address saved.')));
      }, child: const Text('Save address')),
    ])),
    const SizedBox(height: 16),
    const Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatusTag('MOCK DATA MODE'), SizedBox(height: 8),
      Text('No account, backend, real businesses, live couriers or payment gateway are connected. Changes reset when the app restarts.'),
    ])),
  ]);
}

class StatusTag extends StatelessWidget {
  const StatusTag(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.centerLeft, child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: paleGreen, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: const TextStyle(color: emerald, fontWeight: FontWeight.w800, fontSize: 11)),
  ));
}

class EmptyPanel extends StatelessWidget {
  const EmptyPanel({super.key, required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Surface(child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(children: [
      CircleAvatar(radius: 26, backgroundColor: paleGreen, foregroundColor: emerald, child: Icon(icon, size: 27)),
      const SizedBox(height: 14), Text(title, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 6), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
    ]),
  ));
}
