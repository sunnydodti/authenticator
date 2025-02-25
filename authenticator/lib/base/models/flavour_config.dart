import 'package:flutter/material.dart';

import '../enums.dart';
import 'flavour_values.dart';

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    Color color = Colors.blue,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(flavor, flavor.name, color, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isPRODUCTION() => _instance!.flavor == Flavor.PRD;

  // static bool isBETA() => _instance!.flavor == Flavor.BETA;
  //
  // static bool isALPHA() => _instance!.flavor == Flavor.ALPHA;
  //
  // static bool isSTG() => _instance!.flavor == Flavor.STG;

  static bool isDEV() => _instance!.flavor == Flavor.DEV;

  static bool displayBanner() {
    if (isPRODUCTION()) return false;
    // if (isPreRelease()) return false;
    return true;
  }

  // static bool isPreRelease() {
  //   return (isBETA() || isALPHA());
  // }
}
