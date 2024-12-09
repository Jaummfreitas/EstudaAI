class SessionManager {
static final SessionManager _instance = SessionManager._internal();

factory SessionManager() {
  return _instance;
}

SessionManager._internal();

int? _userId;  

int? get userId => _userId;

set userId(int? value) {
  _userId = value;
}
}