import 'dart:convert';

import 'package:authenticator/constants/constants.dart';
import 'package:authenticator/constants/database_constants.dart';

GroupConstants c = Constants.db.group;

class Group {
  final int? id;
  final String name;
  int? parentId;

  Group({
    required this.id,
    required this.name,
    this.parentId,
  });

  Group copyWith({
    int? id,
    String? name,
    int? parentId,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null && id != -1) c.id: id,
      c.name: name,
      c.parentId: parentId,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map[c.id] as int,
      name: map[c.name] as String,
      parentId: map[c.parentId] != null ? map[c.parentId] as int : null,
    );
  }

  static _parseIntAsBool(int value) {
    return value != 0;
  }

  int _parseBoolAsInt(bool value) {
    return value ? 1 : 0;
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) =>
      Group.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Group(${c.id}: $id, ${c.name}: $name, ${c.parentId}: $parentId)';
  }

  @override
  bool operator ==(covariant Group other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.parentId == parentId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ parentId.hashCode;
  }
}
