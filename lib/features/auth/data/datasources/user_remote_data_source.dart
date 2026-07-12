import 'package:gestion_integral_jyc/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserRemoteDataSource(this.supabaseClient);

  Future<UserModel> fetchUserByAuthId(String idAuth) async {
    final response = await supabaseClient
        .from('usuario')
        .select(
          'idusuario, id_auth, nombre, apellido, rol_usuario(rol(nombre))',
        )
        .eq('id_auth', idAuth)
        .single();

    return UserModel.fromJson(response);
  }
}
