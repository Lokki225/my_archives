import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/home/presentation/bloc/user_bloc.dart';

import '../../../../bdd_test_manip.dart';
import '../../../../core/Common/widgets/app_drawer_widget.dart';
import '../../../../core/database/local.dart';
import '../bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedFile;

  @override
  initState() {
    super.initState();
    // final localDBUserTest = LocalDBUserTest(localDB: LocalDatabase());

    // localDBUserTest.addUserProfilePicture('/data/user/0/com.example.my_archives/cache/file_picker/1751632132805/unnamed.jpg');
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
      drawer: AppDrawerWidget(),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: [
                    Center( // This centers the Stack horizontally
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.teal,
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.file(
                                File(state.user.profilePicture),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                Image.asset("$defaultImagePath/default_profile_photo.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 10,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () async{
                                  try {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'jpeg', 'png',],
                                    );
                                    if (result != null) {
                                      selectedFile = result.files.single.path;
                                      context.read<UserBloc>().add(
                                          ChangeUserProfilePictureEvent(path: selectedFile!, userId: state.user.id)
                                      );
                                    }
                                  } catch (_) {}
                                  context.read<UserBloc>().add(FetchUser(state.user.firstName));
                                },
                                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.person, color: Colors.white),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First Name',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.user.firstName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.person, color: Colors.white),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last Name',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.user.lastName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.email, color: Colors.white),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.user.email,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.password, color: Colors.white),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.user.password.replaceAll(RegExp(r'.(?=.)'), '*'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Unknow Error',));
        },
      ),
    );
  }
}
