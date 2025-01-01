import 'dart:convert';

import 'package:authenticator/constants/constants.dart';
import 'package:authenticator/constants/database_constants.dart';

GroupConstants c = Constants.db.group;

class Group {
  final int? id;
  final String name;
  final int? parentId;
  final bool isLeaf;

  Group({
    required this.id,
    required this.name,
    this.parentId,
    required this.isLeaf,
  });

  Group copyWith({
    int? id,
    String? name,
    int? parentId,
    bool? isLeaf,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      isLeaf: isLeaf ?? this.isLeaf,
    );
  }

  Map<String, dynamic> toMap() {

    return <String, dynamic>{
      if (id != null && id != -1) c.id: id,
      c.name: name,
      c.parentId: parentId,
      c.isLeaf: _parseBoolAsInt(isLeaf),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map[c.id] as int,
      name: map[c.name] as String,
      parentId: map[c.parentId] != null ? map[c.parentId] as int : null,
      isLeaf: _parseIntAsBool(map[c.isLeaf]),
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
    return 'Group(${c.id}: $id, ${c.name}: $name, ${c.parentId}: $parentId, ${c.isLeaf}: $isLeaf)';
  }

  @override
  bool operator ==(covariant Group other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.parentId == parentId &&
        other.isLeaf == isLeaf;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ parentId.hashCode ^ isLeaf.hashCode;
  }
}
