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
  int _activeElement = 0;

  void setUserToken(String token) {
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
    return _userToken != null;
  }

  int getUserId() {
    return _userId ?? 0;
  }

  void setUserId(int userId) {
    _userId = userId;
  }

  void setActiveElement(int elementId) {
    _activeElement = elementId;
  }

  int getActiveElement() {
    return _activeElement;
  }

  void clearUserPreferences() {
    _userToken = null;
    _userId = null;
    _latestActiveCommunity = null;
    _userRoles = [];
    _userCommunities = [];
    _activeElement = 0;
  }
}
