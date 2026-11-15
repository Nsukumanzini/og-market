import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

class Merchant {
  const Merchant(this.id, this.name, this.category, this.area, this.icon, this.color);
  final String id, name, category, area;
  final IconData icon;
  final Color color;
}

class Product {
  const Product(this.id, this.merchantId, this.name, this.category, this.price, this.icon, this.color);
  final String id, merchantId, name, category;
  final int price;
  final IconData icon;
  final Color color;
}

class DemoOrder {
  const DemoOrder({required this.id, required this.title, required this.total, required this.status, required this.detail});
  final String id, title, status, detail;
  final int total;
}

class ServiceRequest {
  const ServiceRequest(this.id, this.type, this.description, this.pickup, this.delivery);
  final String id, type, description, pickup, delivery;
}

class MockMarketplace extends ChangeNotifier {
  static const deliveryFee = 2500;
  static const merchants = [
    Merchant('fresh', 'Fresh Corner', 'Groceries', 'Ermelo Central', Icons.storefront_rounded, Color(0xFFE4F4E9)),
    Merchant('kitchen', 'The Local Kitchen', 'Food', 'Ermelo Central', Icons.restaurant_rounded, Color(0xFFFFE8D1)),
    Merchant('essentials', 'Everyday Essentials', 'Essentials', 'Ermelo', Icons.shopping_basket_rounded, Color(0xFFE3ECFA)),
  ];
  static const products = [
    Product('bread', 'fresh', 'Fresh white bread', 'Groceries', 1899, Icons.bakery_dining_rounded, Color(0xFFFFEFD1)),
    Product('milk', 'fresh', 'Fresh milk 1L', 'Groceries', 2299, Icons.local_drink_rounded, Color(0xFFE4EEF8)),
    Product('eggs', 'fresh', 'Free-range eggs', 'Groceries', 3999, Icons.egg_alt_rounded, Color(0xFFF7E6D0)),
    Product('burger', 'kitchen', 'Classic burger', 'Food', 6499, Icons.lunch_dining_rounded, Color(0xFFFFE5D4)),
    Product('pizza', 'kitchen', 'Margherita pizza', 'Food', 8999, Icons.local_pizza_rounded, Color(0xFFFFE9B7)),
    Product('soap', 'essentials', 'Hand soap', 'Essentials', 2999, Icons.soap_rounded, Color(0xFFE1F1EE)),
    Product('water', 'essentials', 'Bottled water 1.5L', 'Essentials', 1299, Icons.water_drop_rounded, Color(0xFFDCEEF9)),
  ];

  final Map<String, int> _cart = {};
  final List<DemoOrder> _orders = [];
  final List<ServiceRequest> _requests = [];
  String deliveryAddress = 'Ermelo Central, Ermelo';
  Map<String, int> get cart => Map.unmodifiable(_cart);
  List<DemoOrder> get orders => List.unmodifiable(_orders);
  List<ServiceRequest> get requests => List.unmodifiable(_requests);
  int get count => _cart.values.fold(0, (a, b) => a + b);
  int get subtotal => _cart.entries.fold(0, (sum, item) => sum + product(item.key).price * item.value);
  int get total => subtotal + (_cart.isEmpty ? 0 : deliveryFee);
  String? get cartMerchant => _cart.isEmpty ? null : product(_cart.keys.first).merchantId;
  Product product(String id) => products.firstWhere((p) => p.id == id);
  Merchant merchant(String id) => merchants.firstWhere((m) => m.id == id);

  List<Product> search({String query = '', String category = 'All', String? merchantId}) {
    final q = query.trim().toLowerCase();
    return products.where((p) =>
        (category == 'All' || category == p.category) &&
        (merchantId == null || merchantId == p.merchantId) &&
        (q.isEmpty || '${p.name} ${merchant(p.merchantId).name} ${p.category}'.toLowerCase().contains(q))).toList();
  }

  bool add(Product p) {
    if (cartMerchant != null && cartMerchant != p.merchantId) return false;
    _cart[p.id] = (_cart[p.id] ?? 0) + 1;
    notifyListeners();
    return true;
  }

  void remove(Product p) {
    final quantity = _cart[p.id] ?? 0;
    if (quantity <= 1) {
      _cart.remove(p.id);
    } else {
      _cart[p.id] = quantity - 1;
    }
    notifyListeners();
  }

  DemoOrder? checkout() {
    if (_cart.isEmpty || deliveryAddress.trim().isEmpty) return null;
    final order = DemoOrder(
      id: 'GM-${1001 + _orders.length}',
      title: merchant(cartMerchant!).name,
      total: total,
      status: 'Demo payment successful',
      detail: '${count} item(s) • ${deliveryAddress}',
    );
    _orders.insert(0, order);
    _cart.clear();
    notifyListeners();
    return order;
  }

  void updateAddress(String value) {
    if (value.trim().isEmpty) return;
    deliveryAddress = value.trim();
    notifyListeners();
  }

  void submitRequest(String type, String description, String pickup, String delivery) {
    _requests.insert(0, ServiceRequest('REQ-${501 + _requests.length}', type, description.trim(), pickup.trim(), delivery.trim()));
    notifyListeners();
  }
}
