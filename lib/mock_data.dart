// All hardcoded data for the OG Market home screen.
// No backend. No network calls.

const List<Map<String, dynamic>> kBentoCategories = [
  {
    'label': 'Food & Groceries',
    'subtitle': '240+ vendors',
    'icon': '🛒',
    'isPrimary': true,
    'isWide': false,
  },
  {
    'label': 'Services',
    'subtitle': '80+ pros',
    'icon': '🔧',
    'isPrimary': false,
    'isWide': false,
  },
  {
    'label': 'Electronics',
    'subtitle': '120+ items',
    'icon': '💻',
    'isPrimary': false,
    'isWide': false,
  },
  {
    'label': 'Featured: Local Artists',
    'subtitle': 'Handcrafted for you this week',
    'icon': '🎨',
    'isPrimary': false,
    'isWide': true,
  },
];

const List<Map<String, dynamic>> kVerifiedVendors = [
  {
    'name': 'Mama Zola',
    'category': 'Home Cooking',
    'emoji': '👩🏾‍🍳',
    'rating': 4.9,
  },
  {
    'name': 'TechFix SA',
    'category': 'Electronics',
    'emoji': '🔌',
    'rating': 4.7,
  },
  {
    'name': 'Siya Builds',
    'category': 'Construction',
    'emoji': '👷🏽',
    'rating': 4.8,
  },
  {
    'name': 'Fresh Cuts',
    'category': 'Beauty',
    'emoji': '✂️',
    'rating': 4.6,
  },
  {
    'name': 'Art by Nandi',
    'category': 'Art & Craft',
    'emoji': '🎨',
    'rating': 5.0,
  },
  {
    'name': 'GreenThumb',
    'category': 'Gardening',
    'emoji': '🌿',
    'rating': 4.5,
  },
];

const List<Map<String, dynamic>> kFreshFinds = [
  {
    'name': 'Amasi Smoothie',
    'price': 'R75',
    'distance': '0.8km',
    'emoji': '🥤',
    'vendor': 'Mama Zola',
    'rating': 4.9,
    'tileColor': 0xFF0F1F0F,
    'tall': true,
  },
  {
    'name': 'Vintage Vinyl Pack',
    'price': 'R350',
    'distance': '2.1km',
    'emoji': '🎵',
    'vendor': 'Kasi Kollektives',
    'rating': 4.7,
    'tileColor': 0xFF0F0F1F,
    'tall': false,
  },
  {
    'name': 'Braai Box',
    'price': 'R220',
    'distance': '1.2km',
    'emoji': '🥩',
    'vendor': 'Uncle Tee',
    'rating': 4.8,
    'tileColor': 0xFF1F0F0F,
    'tall': false,
  },
  {
    'name': 'Handmade Beads',
    'price': 'R150',
    'distance': '3.4km',
    'emoji': '📿',
    'vendor': 'Art by Nandi',
    'rating': 5.0,
    'tileColor': 0xFF1A0F1F,
    'tall': true,
  },
  {
    'name': 'Screen Fix',
    'price': 'R299',
    'distance': '0.5km',
    'emoji': '📱',
    'vendor': 'TechFix SA',
    'rating': 4.7,
    'tileColor': 0xFF0F1A1A,
    'tall': false,
  },
  {
    'name': 'Koeksister Box',
    'price': 'R95',
    'distance': '1.8km',
    'emoji': '🧁',
    'vendor': 'Tannie Bets',
    'rating': 4.6,
    'tileColor': 0xFF1A1A0F,
    'tall': true,
  },
];
