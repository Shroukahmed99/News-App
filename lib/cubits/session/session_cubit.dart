// cubits/session/session_cubit.dart
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

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("current_user_id");
    final rememberMe = prefs.getBool("remember_me") ?? false;

    if (rememberMe && userId != null) {
      emit(SessionAuthenticated(userId));
    } else {
      emit(SessionUnauthenticated());
    }
  }

  Future<void> setSession(String userId, {bool rememberMe = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("current_user_id", userId);
    await prefs.setBool("remember_me", rememberMe);
    emit(SessionAuthenticated(userId));
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user_id");
    await prefs.remove("remember_me");
    emit(SessionUnauthenticated());
  }
}
