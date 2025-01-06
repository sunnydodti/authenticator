class DatabaseConstants {
  final String databaseName = "authenticator.db";
  final int databaseVersion = 1;

  CommonDBConstants get common => CommonDBConstants();

  AuthItemConstants get authItem => AuthItemConstants();

  GroupConstants get group => GroupConstants();
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

  final String serviceName = "service_name";

  final String secret = "secret";
  final String code = "code";

  final String groupId = "group_id";
}

class GroupConstants {
  final String table = "groups";
  final String triggerModifiedAt = "update_modified_at_group";

  final String id = CommonDBConstants.id;
  final String name = "name";

  final String parentId = "parent_id";

  final int defaultGroupId = 1;
}
