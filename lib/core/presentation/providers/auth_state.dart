import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/core/domain/entities/user_entity.dart';

class AuthState {
  final UserEntity? user;
  final Role? activeRole;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.activeRole,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null;

  const AuthState.initial() : this();

  AuthState copyWith({
    UserEntity? user,
    Role? activeRole,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      activeRole: activeRole ?? this.activeRole,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
