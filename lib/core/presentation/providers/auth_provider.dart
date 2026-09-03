import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_state.dart';
import 'package:gestion_integral_jyc/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSource(Supabase.instance.client);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(userRemoteDataSourceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRemoteDataSource userDataSource;
  final _supabase = Supabase.instance.client;

  AuthNotifier(this.userDataSource) : super(const AuthState.initial()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await _loadUserProfile(session.user.id);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('No se pudo iniciar sesión');
      }

      await _loadUserProfile(response.user!.id);
    } on AuthException catch (e) {
      if (e.message.contains('Email not confirmed')) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Tenés que verificar tu correo antes de entrar.',
          needsEmailConfirmation: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Error de inicio de sesión: ${e.message}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al iniciar sesión: $e',
      );
    }
  }

  Future<void> _loadUserProfile(String idAuth) async {
    try {
      final user = await userDataSource.fetchUserByAuthId(idAuth);

      // El rol de logueo por defecto siempre es Operario, aunque el
      // usuario también tenga Administrador disponible.
      final defaultRole = user.hasRole(Role.operario)
          ? Role.operario
          : (user.roles.isNotEmpty ? user.roles.first : null);

      state = state.copyWith(
        user: user,
        activeRole: defaultRole,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se encontró un perfil para este usuario: $e',
      );
      await _supabase.auth.signOut();
    }
  }

  void switchRole(Role role) {
    if (state.user != null && state.user!.hasRole(role)) {
      state = state.copyWith(activeRole: role);
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    String lastname,
  ) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      needsEmailConfirmation: false,
    );

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nombre': name, 'apellido': lastname},
      );

      final newUser = response.user;
      if (newUser == null) throw Exception('No se pudo crear la cuenta');

      if (response.session == null) {
        state = state.copyWith(
          isLoading: false,
          needsEmailConfirmation: true,
          errorMessage: null,
        );
        return;
      }

      await _loadUserProfile(newUser.id);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al registrarse: $e',
      );
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = const AuthState.initial();
  }
}

final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.activeRole == Role.administrador;
});

final isRootProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.isRoot ?? false;
});
