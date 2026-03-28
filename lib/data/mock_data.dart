import 'package:garage_guru/models/models.dart';
class MockData {
  MockData._();

  static final List<GarageModel> garages = [];

  static final List<ServiceModel> services = [
    const ServiceModel(
      id: 's1', garageId: 'g1', name: 'Oil Change',
      description: 'Full synthetic oil change with filter replacement',
      category: 'Maintenance', price: 49.99, estimatedMinutes: 30,
      iconName: 'oil_barrel',
    ),
    const ServiceModel(
      id: 's2', garageId: 'g1', name: 'Brake Pad Replacement',
      description: 'Front or rear brake pad replacement with inspection',
      category: 'Brakes', price: 149.99, estimatedMinutes: 90,
      iconName: 'car_repair',
    ),
    const ServiceModel(
      id: 's3', garageId: 'g1', name: 'Engine Diagnostics',
      description: 'Computer diagnostics check with full report',
      category: 'Diagnostics', price: 79.99, estimatedMinutes: 45,
      iconName: 'engineering',
    ),
    const ServiceModel(
      id: 's4', garageId: 'g1', name: 'Tire Rotation',
      description: 'Rotate all four tires for even wear',
      category: 'Tires', price: 29.99, estimatedMinutes: 25,
      iconName: 'tire_repair',
    ),
    const ServiceModel(
      id: 's5', garageId: 'g1', name: 'AC Repair',
      description: 'Air conditioning diagnostics and recharge',
      category: 'Climate', price: 129.99, estimatedMinutes: 60,
      iconName: 'ac_unit',
    ),
    const ServiceModel(
      id: 's6', garageId: 'g1', name: 'Battery Replacement',
      description: 'Battery test and replacement with premium battery',
      category: 'Electrical', price: 159.99, estimatedMinutes: 30,
      iconName: 'battery_charging_full',
    ),
    const ServiceModel(
      id: 's7', garageId: 'g1', name: 'Full Inspection',
      description: 'Comprehensive 50-point vehicle inspection',
      category: 'Diagnostics', price: 89.99, estimatedMinutes: 60,
      iconName: 'checklist',
    ),
    const ServiceModel(
      id: 's8', garageId: 'g1', name: 'Transmission Service',
      description: 'Transmission fluid flush and filter change',
      category: 'Drivetrain', price: 199.99, estimatedMinutes: 120,
      iconName: 'settings',
    ),
  ];

  static final List<ReviewModel> reviews = [
    ReviewModel(
      id: 'r1', garageId: 'g1', customerId: 'c1',
      customerName: 'John Smith',
      customerImageUrl: 'https://i.pravatar.cc/150?img=1',
      rating: 5.0,
      comment: 'Excellent service! They fixed my brakes quickly and at a fair price. Highly recommend.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReviewModel(
      id: 'r2', garageId: 'g1', customerId: 'c2',
      customerName: 'Sarah Johnson',
      customerImageUrl: 'https://i.pravatar.cc/150?img=5',
      rating: 4.5,
      comment: 'Great diagnostics work. Found the issue with my engine right away. Will come back.',
      images: ['https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=200'],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      reply: 'Thank you Sarah! We appreciate your business.',
      replyDate: DateTime.now().subtract(const Duration(days: 6)),
    ),
    ReviewModel(
      id: 'r3', garageId: 'g1', customerId: 'c3',
      customerName: 'Mike Davis',
      customerImageUrl: 'https://i.pravatar.cc/150?img=8',
      rating: 4.0,
      comment: 'Good service overall. Wait time was a bit long but the work was quality.',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    ReviewModel(
      id: 'r4', garageId: 'g1', customerId: 'c4',
      customerName: 'Emily Chen',
      customerImageUrl: 'https://i.pravatar.cc/150?img=9',
      rating: 5.0,
      comment: 'Best garage in the area! Fair prices and amazing staff. They explained everything clearly.',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'b1', customerId: 'c1', garageId: 'g1',
      garageName: 'Premier Auto Care',
      garageAddress: '123 Main Street, Downtown',
      garageImageUrl: 'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=400',
      services: [
        const BookedService(serviceId: 's1', name: 'Oil Change', price: 49.99),
        const BookedService(serviceId: 's4', name: 'Tire Rotation', price: 29.99),
      ],
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      scheduledTime: '10:00 AM',
      vehicleMake: 'Toyota', vehicleModel: 'Camry', vehicleYear: '2022', vehiclePlate: 'ABC 1234',
      status: BookingStatus.confirmed, totalAmount: 79.98,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    BookingModel(
      id: 'b2', customerId: 'c1', garageId: 'g3',
      garageName: 'EliteMech Workshop',
      garageAddress: '789 Elm Blvd, Uptown',
      garageImageUrl: 'https://images.unsplash.com/photo-1631295387526-d3a8bfa4d42c?w=400',
      services: [
        const BookedService(serviceId: 's3', name: 'Full Diagnostics', price: 89.99),
      ],
      scheduledDate: DateTime.now().subtract(const Duration(days: 5)),
      scheduledTime: '2:00 PM',
      vehicleMake: 'BMW', vehicleModel: '3 Series', vehicleYear: '2023', vehiclePlate: 'XYZ 5678',
      status: BookingStatus.completed, totalAmount: 89.99,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    BookingModel(
      id: 'b3', customerId: 'c1', garageId: 'g2',
      garageName: 'Speedy Garage & Tires',
      garageAddress: '456 Oak Avenue, Midtown',
      services: [
        const BookedService(serviceId: 's2', name: 'Brake Pad Replacement', price: 149.99),
      ],
      scheduledDate: DateTime.now().add(const Duration(days: 5)),
      scheduledTime: '9:00 AM',
      vehicleMake: 'Honda', vehicleModel: 'Civic', vehicleYear: '2021',
      status: BookingStatus.pending, totalAmount: 149.99,
      createdAt: DateTime.now(),
    ),
  ];

  static final currentUser = UserModel(
    id: 'c1',
    fullName: 'Alex Thompson',
    email: 'alex@example.com',
    phone: '+1 (555) 000-1234',
    profileImageUrl: 'https://i.pravatar.cc/150?img=12',
    role: UserRole.customer,
    address: '100 Customer Lane, City',
    createdAt: DateTime(2025, 1, 15),
  );
  static final List<VehicleModel> vehicles = [
  VehicleModel(
    id: 'v1',
    make: 'Toyota',
    model: 'Camry',
    year: 2020,
    color: 'Silver',
    plateNumber: 'RAH234H',
    imageUrl: 'https://images.unsplash.com/photo-1550355291-bbee04a92027?w=400',
    nextServiceDate: DateTime(2025, 5, 25),
  ),
  VehicleModel(
    id: 'v2',
    make: 'Honda',
    model: 'Civic',
    year: 2018,
    color: 'Blue',
    plateNumber: 'RAA567K',
    imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=400',
    nextServiceDate: DateTime(2025, 6, 10),
  ),
];
}

