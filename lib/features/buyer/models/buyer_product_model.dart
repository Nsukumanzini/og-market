// Hardcoded data structures for the Buyer feature.
// Replace with API/Firestore calls when the backend is ready.

class BuyerProductModel {
  const BuyerProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.vendorName,
    required this.vendorIsVerified,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.badge,
    this.description = '',
    this.tags = const [],
  });

  final String id;
  final String title;
  final double price;
  final String category;
  final String vendorName;
  final bool vendorIsVerified;
  final double rating;
  final int reviewCount;
  final ProductBadge? badge;
  final String description;
  final List<String> tags;

  String get formattedPrice => 'R ${price.toStringAsFixed(2)}';
}

enum ProductBadge { flashDeal, newArrival, bestSeller, localFave }

// ── Category Model ────────────────────────────────────────────────────────────

class BuyerCategoryModel {
  const BuyerCategoryModel({
    required this.id,
    required this.label,
    required this.sublabel,
    required this.accentColor,
    required this.products,
  });

  final String id;
  final String label;
  final String? sublabel;
  final int accentColor; // stored as ARGB int for const compatibility
  final List<BuyerProductModel> products;
}

// ── Vendor Model ──────────────────────────────────────────────────────────────

class VendorModel {
  const VendorModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.isVerified,
    this.rating = 0.0,
    this.totalSales = 0,
  });

  final String id;
  final String name;
  final String tagline;
  final bool isVerified;
  final double rating;
  final int totalSales;
}

// ── Mock Data ─────────────────────────────────────────────────────────────────

class BuyerMockData {
  BuyerMockData._();

  static const List<VendorModel> vendors = [
    VendorModel(
      id: 'v1',
      name: 'Mama G Kitchen',
      tagline: 'Best kotas in Soweto',
      isVerified: true,
      rating: 4.9,
      totalSales: 1240,
    ),
    VendorModel(
      id: 'v2',
      name: 'TechZone SA',
      tagline: 'Certified pre-owned gadgets',
      isVerified: true,
      rating: 4.7,
      totalSales: 880,
    ),
    VendorModel(
      id: 'v3',
      name: 'Ubuntu Crafts',
      tagline: 'Handmade with love',
      isVerified: false,
      rating: 4.5,
      totalSales: 312,
    ),
    VendorModel(
      id: 'v4',
      name: 'Fresh Roots Farm',
      tagline: 'Farm-to-door produce',
      isVerified: true,
      rating: 4.8,
      totalSales: 2100,
    ),
    VendorModel(
      id: 'v5',
      name: 'Kick It Sneakers',
      tagline: 'Authentic kicks, local prices',
      isVerified: true,
      rating: 4.6,
      totalSales: 650,
    ),
  ];

  static const List<BuyerProductModel> flashDeals = [
    BuyerProductModel(
      id: 'p1',
      title: 'Wireless Earbuds Pro',
      price: 299.00,
      category: 'Electronics',
      vendorName: 'TechZone SA',
      vendorIsVerified: true,
      rating: 4.7,
      reviewCount: 134,
      badge: ProductBadge.flashDeal,
      description:
          'Premium sound quality with 30hr battery. Noise-cancelling. '
          'Comes with carrying case.',
      tags: ['wireless', 'audio', 'tech'],
    ),
    BuyerProductModel(
      id: 'p2',
      title: 'Special Kota Combo',
      price: 49.99,
      category: 'Food',
      vendorName: 'Mama G Kitchen',
      vendorIsVerified: true,
      rating: 4.9,
      reviewCount: 321,
      badge: ProductBadge.bestSeller,
      description:
          'Double patty kota with chips, polony, cheese and house sauce. '
          'Available for pickup and delivery within 5km.',
      tags: ['food', 'kota', 'local'],
    ),
    BuyerProductModel(
      id: 'p3',
      title: 'Organic Veggie Box',
      price: 89.99,
      category: 'Fruits & Veg',
      vendorName: 'Fresh Roots Farm',
      vendorIsVerified: true,
      rating: 4.8,
      reviewCount: 210,
      badge: ProductBadge.flashDeal,
      description:
          'Weekly seasonal vegetable box. Sourced directly from Magaliesberg farms.',
      tags: ['fresh', 'organic', 'farm'],
    ),
  ];

  static const List<BuyerProductModel> newArrivals = [
    BuyerProductModel(
      id: 'p4',
      title: 'Beaded Clutch Bag',
      price: 249.00,
      category: 'Fashion',
      vendorName: 'Ubuntu Crafts',
      vendorIsVerified: false,
      rating: 4.5,
      reviewCount: 44,
      badge: ProductBadge.newArrival,
      description: 'Hand-beaded clutch. Each piece unique. Zulu-inspired patterns.',
      tags: ['fashion', 'handmade', 'local'],
    ),
    BuyerProductModel(
      id: 'p5',
      title: 'Nike Air Force 1 \'07',
      price: 1499.00,
      category: 'Sneakers',
      vendorName: 'Kick It Sneakers',
      vendorIsVerified: true,
      rating: 4.6,
      reviewCount: 98,
      badge: ProductBadge.newArrival,
      description: 'Authentic Nike AF1. Size 8–12 available. Comes in original box.',
      tags: ['sneakers', 'nike', 'fashion'],
    ),
  ];

  static const List<BuyerCategoryModel> bentoCategories = [
    BuyerCategoryModel(
      id: 'flash',
      label: 'Flash Deals',
      sublabel: 'Ends in 2h',
      accentColor: 0xFF00C853,
      products: flashDeals,
    ),
    BuyerCategoryModel(
      id: 'new',
      label: 'New Arrivals',
      sublabel: null,
      accentColor: 0xFF6366F1,
      products: newArrivals,
    ),
    BuyerCategoryModel(
      id: 'electronics',
      label: 'Electronics',
      sublabel: null,
      accentColor: 0xFFF59E0B,
      products: flashDeals, // reuse for now
    ),
    BuyerCategoryModel(
      id: 'fashion',
      label: 'Fashion',
      sublabel: null,
      accentColor: 0xFFEC4899,
      products: newArrivals,
    ),
    BuyerCategoryModel(
      id: 'food',
      label: 'Food',
      sublabel: null,
      accentColor: 0xFF10B981,
      products: flashDeals,
    ),
  ];
}
