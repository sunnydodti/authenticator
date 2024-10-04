import 'dart:convert';

class AuthItem {
  final int? id;
  final String name;
  final String? serviceName;
  final String secret;
  final String? code;

  AuthItem({
    this.id,
    required this.name,
    required this.serviceName,
    required this.secret,
    required this.code,
  });

  AuthItem copyWith({
    int? id,
    String? name,
    String? serviceName,
    String? secret,
    String? code,
  }) {
    return AuthItem(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceName: serviceName ?? this.serviceName,
      secret: secret ?? this.secret,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      // 'serviceName': serviceName,
      'secret': secret,
      // 'code': code,
    };
  }

  factory AuthItem.fromMap(Map<String, dynamic> map) {
    return AuthItem(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      serviceName: map['serviceName'] as String?,
      secret: map['secret'] as String,
      code: map['code'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthItem.fromJson(String source) =>
      AuthItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthItem(id: $id, name: $name, serviceName: $serviceName, secret: $secret, code: $code)';
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
        code.hashCode;
  }
}
