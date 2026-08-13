// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../auth/auth_service.dart' as _i88;
import 'firebase_module.dart' as _i616;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final firebaseModule = _$FirebaseModule();
  gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
  gh.lazySingleton<_i88.AuthService>(
    () => _i88.AuthService(gh<_i59.FirebaseAuth>()),
  );
  return getIt;
}

class _$FirebaseModule extends _i616.FirebaseModule {}
