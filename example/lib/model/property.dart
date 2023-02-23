// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'address.dart';

class Property {
  final String id;
  // final String name;
  // final double rentAmount;
  final Address address;
  // final String coverImageUrl;
  // final String? description;
  // final List<PropertyImage>? propertyImagesList;
  // final int? unitNumber;
  // final int? roomsCount;
  // final int? bathroomsCount;
  // final int? floorsCount;
  // final AppUser? currentResident;
  // enum
  // final PropertyStatus propertyStatus;

  Property({
    // this.propertyImagesList,
    // this.currentResident,
    // this.propertyStatus = PropertyStatus.notRented,
    required this.id,
    required this.address,
  });

  Property copyWith({
    String? id,
    Address? address,
  }) {
    return Property(
      id: id ?? this.id,
      address: address ?? this.address,
    );
  }

  @override
  String toString() => 'Property(id: $id, address: $address)';

  @override
  bool operator ==(covariant Property other) {
    if (identical(this, other)) return true;

    return other.id == id && other.address == address;
  }

  @override
  int get hashCode => id.hashCode ^ address.hashCode;
}
