import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/authentification/presentation/bloc/auth_bloc.dart';

class AppDrawerWidget extends StatefulWidget {
  const AppDrawerWidget({super.key});

  @override
  State<AppDrawerWidget> createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends State<AppDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthLogout) {
          Navigator.pushReplacementNamed(context, '/LoginScreen');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
          return  Drawer(
            backgroundColor: Colors.deepPurple,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(Icons.menu_open, size: 50, color: Colors.white),
                      const Text(
                        'MyArchives',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text('Home', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: ()
                  {
                    // Navigate to Home or close the drawer
                    Navigator.pushReplacementNamed(context, '/HomeScreen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Profile', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: ()
                  {
                    // Navigate to Folders or perform some action
                    Navigator.pushReplacementNamed(context, '/ProfileScreen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive_rounded, color: Colors.white),
                  title: const Text('Archives', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: ()
                  {
                    // Navigate to Folders or perform some action
                    Navigator.pushReplacementNamed(context, '/ArchivesScreen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.folder, color: Colors.white),
                  title: const Text('Folders', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: ()
                  {
                    // Navigate to Folders or perform some action
                    Navigator.pushReplacementNamed(context, '/FoldersScreen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category, color: Colors.white),
                  title: const Text('Categories', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: ()
                  {
                    // Navigate to Folders or perform some action
                    Navigator.pushReplacementNamed(context, '/CategoriesScreen');
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.settings, color: Colors.white),
                //   title: const Text('Settings', style: TextStyle(fontSize: 18, color: Colors.white)),
                //   onTap: ()
                //   {
                //     // Navigate to Settings or perform some action
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text('Logout', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: ()
                  {
                    // Perform logout operation
                    context.read<AuthBloc>().add(LogoutClient());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
