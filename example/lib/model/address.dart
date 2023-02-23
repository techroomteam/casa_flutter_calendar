// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'map_location.dart';

class Address {
  final String id;
  final String addressString;
  final String cityName;
  final String countryName;
  // final MapLocation mapLocation;
  Address({
    required this.id,
    required this.addressString,
    required this.cityName,
    required this.countryName,
    // required this.mapLocation,
  });

  Address copyWith({
    String? id,
    String? addressString,
    String? cityName,
    String? countryName,
    // MapLocation? mapLocation,
  }) {
    return Address(
      id: id ?? this.id,
      addressString: addressString ?? this.addressString,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      // mapLocation: mapLocation ?? this.mapLocation,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, addressString: $addressString, cityName: $cityName, countryName: $countryName)';
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.addressString == addressString &&
        other.cityName == cityName &&
        other.countryName == countryName;
    // && other.mapLocation == mapLocation;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        addressString.hashCode ^
        cityName.hashCode ^
        countryName.hashCode;
    // mapLocation.hashCode;
  }
}
