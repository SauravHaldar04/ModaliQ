import 'package:datahack/core/cubits/auth_user/auth_user_cubit.dart';
import 'package:datahack/core/theme/theme.dart';
import 'package:datahack/core/utils/loader.dart';
import 'package:datahack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:datahack/features/auth/presentation/pages/landing_page.dart';
import 'package:datahack/features/auth/presentation/pages/verification_page.dart';
import 'package:datahack/home/home.dart';
import 'package:datahack/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthUserCubit>(
          create: (context) => serviceLocator<AuthUserCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a separate widget to initialize the AuthBloc
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: AppTheme.appTheme,
      home: const AppInitializer(),
    );
  }
}

/// A StatefulWidget responsible for initializing authentication status.
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Dispatch AuthIsUserLoggedIn event once when the app initializes
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          // Display error message using a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          } else if (state is AuthUserLoggedIn) {
            print(state);
            return const VerificationPage();
          } else if (state is AuthEmailVerified) {
            return const HomePage();
          } else {
            return const LandingPage();
          }
        },
      ),
    );
  }
}
