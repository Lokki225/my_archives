import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/Common/widgets/folders_horizontal_selector.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/folder_bloc.dart';
import 'package:my_archives/injection_container.dart';
import '../../../../bdd_test_manip.dart';
import '../../../../core/Common/widgets/Order_by_widget.dart';
import '../../../../core/Common/widgets/archives_grid.dart';
import '../../../../core/database/local.dart';
import '../../../../core/database/seeds/local_database_seeder.dart';
import '../../../../cubits/app_cubit.dart';
import '../bloc/archive_bloc.dart';
import '../bloc/user_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> userConnectFuture;
  late Future<String?> userNameFuture;
  String _selectedFilter = folderFilters[0];

  @override
  void initState() {
    super.initState();
    userConnectFuture = sL<AppCubit>().getUserIsConnect();
    userNameFuture = Future.value(sL<AppCubit>().getUserFirstName());
    final seeder = DatabaseSeeder(LocalDatabase());

    // seeder.seedPinCode(3);

    // final localDBUserTest = LocalDBUserTest(localDB: LocalDatabase());
    //
    // localDBUserTest.run();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to SearchScreen
              Navigator.pushNamed(context, '/SearchScreen');
            },
          )
        ],
        title: const Text(
          'MyArchives',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      drawer: Drawer(
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
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(fontSize: 18, color: Colors.white)),
              onTap: ()
              {
                // Navigate to Settings or perform some action
              },
            ),
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
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is AuthLogout) {
            Navigator.pushReplacementNamed(context, '/LoginScreen');
          }
        },
        child: FutureBuilder<bool>(
          future: userConnectFuture,
          builder: (context, userConnectSnapshot) {
            if (userConnectSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (userConnectSnapshot.hasError || !userConnectSnapshot.hasData || !userConnectSnapshot.data!) {
              return Center(child: Text("Error or not connected"));
            }

            return FutureBuilder<String?>(
              future: userNameFuture,
              builder: (context, userNameSnapshot) {
                if (userNameSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userNameSnapshot.hasError || !userNameSnapshot.hasData) {
                  return Center(child: Text("Error fetching user name"));
                }
                String userName = userNameSnapshot.data!;
                context.read<UserBloc>().add(FetchUser(userName));
                context.read<FolderBloc>().add(FetchFoldersEvent());

                return BlocListener<UserBloc, UserState>(
                  listener: (BuildContext context, state) {
                    if (state is UserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState state) {
                      if (state is UserInitial || state is UserLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is UserLoaded) {
                        return SingleChildScrollView(
                          child: Container(
                            color: Colors.deepPurple,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset('$defaultImagePath/my_folders.jpg', fit: BoxFit.cover, height: 250, width: 400),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      left: 10,
                                      right: 0,
                                      child: Text("Hi, ${state.user.firstName} 👋", style: TextStyle(fontSize: 45, color: Colors.white)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25),
                                Row(
                                  children: [
                                    Icon(Icons.folder_open_outlined, size: 30, color: Theme.of(context).secondaryHeaderColor),
                                    SizedBox(width: 15),
                                    Text("Folders", style: TextStyle(fontSize: 30, color: Colors.white)),
                                  ],
                                ),
                                SizedBox(height: 15),
                                BlocBuilder<FolderBloc, FolderState>(
                                  builder: (context, state) {
                                    if (state is FolderLoading || state is FolderInitial) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (state is FolderLoaded && state.folders.isNotEmpty) {
                                      return FoldersHorizontalSelector(folders: state.folders);
                                    }
                                    if (state is FolderLoaded  && state.folders.isEmpty) {
                                      return Center(child: Text("No folders found."));
                                    }
                                    print("Unexpected state: $state");
                                    return Text("Unexpected state. Please try again.",);
                                  }
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Icon(Icons.archive_rounded, size: 30, color: Theme.of(context).secondaryHeaderColor),
                                    SizedBox(width: 15),
                                    Text("Archives", style: TextStyle(fontSize: 30, color: Colors.white)),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Sort by",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      OrderByWidget(
                                        tooltipMessage: 'Filter options',
                                        tableName: 'Archive',
                                        options: folderFilters,
                                        onOptionSelected: (selectedOption) {
                                          setState(() {
                                            _selectedFilter = selectedOption;
                                          });
                                          switch (selectedOption) {
                                            case 'All':
                                              context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.all));
                                              break;
                                            case 'Last Added':
                                              context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.lastAddedFirst));
                                              break;
                                            case 'Last Updated':
                                              context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.lastUpdatedFirst));
                                              break;
                                            case 'Title Asc':
                                              context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.titleAZ));
                                              break;
                                            case 'Title Desc':
                                              context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.titleZA));
                                              break;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Icon(Icons.sort, size: 25, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      _selectedFilter,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )
                                    )
                                  ]
                                ),
                                SizedBox(height: 15),
                                // Grid of Archives
                                ArchivesGrid(homeContext: context,),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(child: Text("Unexpected state. Please try again.", style: TextStyle(color: Colors.white, fontSize: 35)));
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
