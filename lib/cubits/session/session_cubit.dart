import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  final String userId;
  SessionAuthenticated(this.userId);
}

class SessionUnauthenticated extends SessionState {}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());

  static const _sessionKey = "user_session";
  static const _sessionDurationInMinutes = 60;

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);

    if (sessionJson == null) {
      emit(SessionUnauthenticated());
      return;
    }

    final sessionData = jsonDecode(sessionJson);
    final loginTime = DateTime.tryParse(sessionData['loginTime'] ?? '');
    final userId = sessionData['userId'];

    if (userId == null || loginTime == null) {
      emit(SessionUnauthenticated());
      return;
    }

    final now = DateTime.now();
    final expired = now.difference(loginTime).inMinutes > _sessionDurationInMinutes;

    if (expired) {
      await clearSession();
    } else {
      emit(SessionAuthenticated(userId));
    }
  }

  Future<void> setSession(String userId, {bool rememberMe = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // Save traditional keys (optional if using user_session only)
    await prefs.setString("current_user_id", userId);
    await prefs.setBool("remember_me", rememberMe);

    // Save session with login time
    final sessionData = {
      "userId": userId,
      "loginTime": DateTime.now().toIso8601String(),
    };
    await prefs.setString(_sessionKey, jsonEncode(sessionData));

    emit(SessionAuthenticated(userId));
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user_id");
    await prefs.remove("remember_me");
    await prefs.remove(_sessionKey);
    emit(SessionUnauthenticated());
  }
}
