// TLO — Vehicle model
// Represents a user-owned vehicle shown on the vehicle selection screen.

enum VehicleType { suv, truck, sedan }

class Vehicle {
  const Vehicle({
    required this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.trim,
    required this.type,
    this.isRecommended = false,
  });

  final String id;
  final int year;
  final String make;
  final String model;
  final String trim;
  final VehicleType type;
  final bool isRecommended;

  String get displayName => '$year $make $model';
}

// ── Sample data ────────────────────────────────────────────

class SampleVehicles {
  static const List<Vehicle> all = [
    Vehicle(
      id: 'rav4',
      year: 2023,
      make: 'Toyota',
      model: 'Rav 4 Hybrid',
      trim: 'XLE Nightshade',
      type: VehicleType.suv,
      isRecommended: true,
    ),
    Vehicle(
      id: 'ram',
      year: 2010,
      make: 'Dodge',
      model: 'Ram',
      trim: 'Laramine SLT',
      type: VehicleType.truck,
    ),
    Vehicle(
      id: 'civic',
      year: 1996,
      make: 'Honda',
      model: 'Civic',
      trim: 'SE Nightshade',
      type: VehicleType.sedan,
    ),
  ];
}
