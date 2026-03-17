import 'package:flutter/material.dart';

class VehicleModel {
  final String id;
  final String userId;
  final String make;
  final String model;
  final String year;
  final String plateNumber;
  final String color;
  final String? imageUrl;
  final DateTime? lastServiceDate;
  final DateTime? nextServiceDate;

  const VehicleModel({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.color,
    this.imageUrl,
    this.lastServiceDate,
    this.nextServiceDate,
  });

  String get fullName => '$make $model';
}
