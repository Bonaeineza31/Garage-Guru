import 'package:cloud_firestore/cloud_firestore.dart';

class DataInitializer {
  static Future<void> populateGarages() async {
    final garages = FirebaseFirestore.instance.collection('garages');

    final data = [
      {
        'name': 'Auto Finit',
        'address': 'KK 15 Ave, Kigali, Rwanda',
        'phone': '+250 788 123 456',
        'rating': 4.9,
        'reviewCount': 120,
        'distanceKm': 3.5,
        'isVerified': true,
        'description': 'Professional auto repair and maintenance services with certified mechanics and modern equipment.',
        'coverImageUrl': 'https://images.unsplash.com/photo-1486006396193-471a2a5d345a?w=800',
        'services': ['Engine Services', 'Battery Service', 'Tire Services', 'Maintenance'],
        'galleryImages': [
          'https://images.unsplash.com/photo-1486006396193-471a2a5d345a?w=400',
          'https://images.unsplash.com/photo-1517524008410-b44c6e448ad5?w=400',
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=400',
          'https://images.unsplash.com/photo-1530046339160-ce3e5b097a1f?w=400',
        ],
        'isFavorite': true,
      },
      {
        'name': 'Kigali Motors',
        'address': 'RN3, Kigali, Rwanda',
        'phone': '+250 788 000 000',
        'rating': 4.3,
        'reviewCount': 85,
        'distanceKm': 1.2,
        'isVerified': true,
        'description': 'Reliable motor services and parts in the heart of Kigali.',
        'coverImageUrl': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
        'services': ['Oil Change', 'Battery Service', 'Diagnostics'],
        'isFavorite': false,
      },
      {
        'name': 'Kimironko Garage',
        'address': 'Kimironko, Kigali, Rwanda',
        'phone': '+250 788 111 222',
        'rating': 4.8,
        'reviewCount': 201,
        'distanceKm': 3.5,
        'isVerified': false,
        'description': 'Trusted community garage specializing in diagnostics and grease repair.',
        'coverImageUrl': 'https://images.unsplash.com/photo-1517524008410-b44c6e448ad5?w=800',
        'services': ['Grease Repair', 'Diagnostics', 'Brake Pad Replacement'],
        'isFavorite': false,
      },
    ];

    for (var garage in data) {
      await garages.add(garage);
    }
  }
}
