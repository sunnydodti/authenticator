import 'dart:convert';

import '../constants/constants.dart';
import '../constants/database_constants.dart';

AuthItemConstants c = Constants.db.authItem;

class AuthItem {
  final int? id;
  String name;
  final String? serviceName;
  final String secret;
  final String? code;
  int? groupId;

  AuthItem({
    this.id,
    required this.name,
    required this.serviceName,
    required this.secret,
    required this.code,
    this.groupId,
  });

  AuthItem copyWith({
    int? id,
    String? name,
    String? serviceName,
    String? secret,
    String? code,
    int? groupId,
  }) {
    return AuthItem(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceName: serviceName ?? this.serviceName,
      secret: secret ?? this.secret,
      code: code ?? this.code,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      c.id: id,
      c.name: name,
      // c.serviceName: serviceName,
      c.secret: secret,
      // c.code: code,
      c.groupId: groupId,
    };
  }

  factory AuthItem.fromMap(Map<String, dynamic> map) {
    return AuthItem(
      id: map[c.id] != null ? map[c.id] as int : null,
      name: map[c.name] as String,
      serviceName: map[c.serviceName] as String?,
      secret: map[c.secret] as String,
      code: map[c.code] as String?,
      groupId: map[c.groupId] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthItem.fromJson(String source) =>
      AuthItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthItem(${c.id}: $id, ${c.name}: $name, ${c.serviceName}: $serviceName, ${c.secret}: $secret, ${c.code}: $code, ${c.groupId}: $groupId)';
  }

  @override
  bool operator ==(covariant AuthItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.serviceName == serviceName &&
        other.secret == secret &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        serviceName.hashCode ^
        secret.hashCode ^
        code.hashCode ^
        groupId.hashCode;
  }
}
