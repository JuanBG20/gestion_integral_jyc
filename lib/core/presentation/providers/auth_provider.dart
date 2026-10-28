import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/domain/services/analytics_service.dart';
import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/analytics_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_state.dart';
import 'package:gestion_integral_jyc/core/utils/error_handler.dart';
import 'package:gestion_integral_jyc/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSource(Supabase.instance.client);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userDataSource = ref.read(userRemoteDataSourceProvider);
  final analyticsService = ref.read(analyticsProvider);
  final subscriptionRepo = ref.read(subscriptionRepositoryProvider);

  return AuthNotifier(userDataSource, analyticsService, subscriptionRepo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRemoteDataSource userDataSource;
  final AnalyticsService analyticsService;
  final SubscriptionRepository subscriptionRepo;
  final _supabase = Supabase.instance.client;

  AuthNotifier(
    this.userDataSource,
    this.analyticsService,
    this.subscriptionRepo,
  ) : super(const AuthState.initial()) {
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
      await analyticsService.logLoginSuccess(loginMethod: 'email');
    } catch (e) {
      await analyticsService.logLoginFailed(error: e.toString());

      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorHandler.getMessage(e),
      );
    }
  }

  Future<void> _loadUserProfile(String idAuth) async {
    try {
      final bool isCrashlyticsSupported =
          !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
      if (isCrashlyticsSupported) {
        FirebaseCrashlytics.instance.setUserIdentifier(idAuth);
      }

      final isRoot = idAuth == '06ab61f7-6679-410c-a087-3f617635189d';
      await analyticsService.setUserProperty(
        name: 'user_type',
        value: isRoot ? 'developer' : 'client',
      );

      await subscriptionRepo.logIn(idAuth);

      final user = await userDataSource.fetchUserByAuthId(idAuth);

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

      await analyticsService.logSignUpCompleted(signUpMethod: 'email');

      if (response.session == null) {
        state = state.copyWith(
          isLoading: false,
          needsEmailConfirmation: true,
          errorMessage: null,
        );
        return;
      }

      await _loadUserProfile(newUser.id);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorHandler.getMessage(e),
      );
    }
  }

  Future<void> signOut() async {
    final bool isCrashlyticsSupported =
        !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
    if (isCrashlyticsSupported) {
      FirebaseCrashlytics.instance.setUserIdentifier('');
    }

    await subscriptionRepo.logOut();
    await _supabase.auth.signOut();
    state = const AuthState.initial();
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await userDataSource.deleteAccount();
      await signOut();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al eliminar la cuenta: $e',
      );
    }
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
