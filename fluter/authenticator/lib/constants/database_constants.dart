class DatabaseConstants {
  final String databaseName = "authenticator.db";
  final int databaseVersion = 1;

  CommonDBConstants get common => CommonDBConstants();

  AuthItemConstants get authItem => AuthItemConstants();
}

class CommonDBConstants {
  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
  static String id = "id";
}

class AuthItemConstants {
  final String table = "auth_item";
  final String triggerModifiedAt = "update_modified_at_auth_item";

  final String id = CommonDBConstants.id;
  final String name = "name";

  // final String token = "token";
  final String secret = "secret";
}
