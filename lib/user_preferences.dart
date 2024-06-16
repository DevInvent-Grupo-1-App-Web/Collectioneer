class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  String? _userToken;
  int? _userId;
  int? _latestActiveCommunity = 1;
  List<int> _userRoles = [];
  List<int> _userCommunities = [];
  int _collectibleId = 0;

  void setUserToken (String token) {
    _userToken = token;
  }

  String? getUserToken() {
    return _userToken;
  }

  void setLatestActiveCommunity(int communityId) {
    _latestActiveCommunity = communityId;
  }

  int? getLatestActiveCommunity() {
    return _latestActiveCommunity;
  }

  void setUserRoles(List<int> roles) {
    _userRoles = roles;
  }

  List<int> getUserRoles() {
    return _userRoles;
  }

  void addUserRole(int roleId) {
    _userRoles.add(roleId);
  }

  void setUserCommunities(List<int> communities) {
    _userCommunities = communities;
  }

  void addUserCommunity(int communityId) {
    _userCommunities.add(communityId);
  }

  List<int> getUserCommunities() {
    return _userCommunities;
  }

  bool hasUserToken() {
    return _userToken != null && _userToken != 'no_token';
  }

  int getUserId() {
    return _userId!;
  }

  void setUserId(int userId) {
    _userId = userId;
  }

  void setCollectibleId(int collectibleId) {
    _collectibleId = collectibleId;
  }

  int getCollectibleId() {
    return _collectibleId;
  }


  void clearUserPreferences() {
    _userToken = null;
    _userId = null;
    _latestActiveCommunity = null;
    _userRoles = [];
    _userCommunities = [];
    _collectibleId = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'user_token': _userToken,
      'user_id': _userId,
      'latest_active_community': _latestActiveCommunity
    };
  }
}