class UserCache {
  static final UserCache _instance = UserCache._internal();
  factory UserCache() => _instance;
  UserCache._internal();

  final Map<String, String> _userNames = {};

  void setUsers(Map<String, String> users) {
    _userNames.clear();
    _userNames.addAll(users);
  }

  String getUserName(String userId) {
    return _userNames[userId] ?? 'Unknown';
  }

  bool get isEmpty => _userNames.isEmpty;
}
