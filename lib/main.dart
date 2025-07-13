import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/config/routes/routes.dart';
import 'package:my_archives/core/database/local.dart';
import 'package:my_archives/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:my_archives/features/authentification/presentation/bloc/table_change_tracker_bloc.dart';
import 'package:my_archives/features/authentification/presentation/screens/register_screen.dart';
import 'package:my_archives/features/code_pin_verification/presentation/screens/create_pin_code_screen.dart';
import 'package:my_archives/features/code_pin_verification/presentation/screens/verify_pin_code_screen.dart';
import 'package:my_archives/features/home/presentation/bloc/archive_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/category_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/user_bloc.dart';
import 'package:my_archives/features/home/presentation/cubits/search_field_cubit.dart';
import 'package:my_archives/features/home/presentation/screens/home_screen.dart';

import 'bdd_test_manip.dart';
import 'config/theme/app_theme.dart';
import 'cubits/app_cubit.dart';
import 'cubits/edit_mode_cubit.dart';
import 'features/authentification/presentation/cubits/auth_field_cubit.dart';
import 'features/home/presentation/bloc/folder_bloc.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDep(); // Initialize dependencies

  // Run test Local DB User
  final localDBUserTest = LocalDBUserTest(localDB: LocalDatabase());

  // localDBUserTest.run();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sL<AppCubit>()),
        BlocProvider(create: (_) => sL<AuthFieldCubit>()),
        BlocProvider(create: (_) => sL<SearchFieldCubit>()),
        BlocProvider(create: (_) => sL<EditModeCubit>()),
        BlocProvider<AuthBloc>(create: (_) => sL<AuthBloc>()),
        BlocProvider<UserBloc>(create: (_) => sL<UserBloc>()),
        BlocProvider<ArchiveBloc>(create: (_) => sL<ArchiveBloc>()),
        BlocProvider<FolderBloc>(create: (_) => sL<FolderBloc>()),
        BlocProvider<CategoryBloc>(create: (_) => sL<CategoryBloc>()),
        // BlocProvider<TableChangeTrackerBloc>(create: (_) => sL<TableChangeTrackerBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> userConnectedFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the app and check if the user is connected
    sL<AppCubit>().initialisationApp();
    userConnectedFuture = sL<AppCubit>().getUserIsConnect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyArchives',
      theme: theme(), // Apply the app theme
      routes: appRoutes, // Define app routes
      home: FutureBuilder<bool>(
        future: userConnectedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading screen while waiting for the result
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors gracefully
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Navigate based on the user's connection status
            final isUserConnected = snapshot.data ?? false;
            return isUserConnected == true ? const VerifyPinCodeScreen() : const RegisterScreen();
          }
        },
      ),
    );
  }
}
