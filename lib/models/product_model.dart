import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final int price;
  final String category;
  final String description;
  final String image;
  final Color color;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
    required this.color,
    required this.rating,
  });

  String get formattedPrice {
    return 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }
}
