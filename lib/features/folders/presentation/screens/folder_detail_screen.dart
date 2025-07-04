import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/Common/widgets/category_tag_list_widget.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';

import '../../../home/domain/entities/archive_entity.dart';
import '../../../home/domain/entities/category_entity.dart';
import '../../../home/presentation/bloc/folder_bloc.dart';

class FolderDetailScreen extends StatefulWidget {
  const FolderDetailScreen({super.key});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final folder = ModalRoute.of(context)?.settings.arguments as Folder;
      context.read<FolderBloc>().add(FetchFolderRelatedArchivesAndCategoriesEvent(folder.id));
      _isInit = false;
    }
  }



  @override
  Widget build(BuildContext context) {
    // Retrieve the argument passed from the previous screen
    final folder = ModalRoute.of(context)?.settings.arguments as Folder;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            context.read<FolderBloc>().add(FetchFoldersEvent());
          },
        ),
        title: Text("MyArchives", style: TextStyle(color: Colors.white, fontSize: 25),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<FolderBloc, FolderState>(
          listener: (context, state) {
            if (state is FolderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<FolderBloc, FolderState>(
            builder: (context, state) {
              if (state is FolderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FolderDetailsLoaded) {
                final List<Archive> archives = state.archives;
                final List<Category> categories = state.categories;


                return archives.isNotEmpty
                    ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔼 Add folder info or whatever above the list
                          Text(
                            'Folder [ ${folder.title} ]',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Categories',
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          categories.isNotEmpty
                              ? CategoryTagListWidget(categories: categories)
                              : const Text("No related categories", style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                '(${archives.length})',
                                style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Archive${archives.length == 1 ? '' : 's'} in this folder',
                                style: const TextStyle(fontSize: 16, color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                        archives.isNotEmpty
                            ? Column(
                          children: archives.map<Widget>((archive) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              color: Colors.deepPurple.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: ListTile(
                                leading: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Image.asset('lib/assets/images/archive_cover.png'),
                                ),
                                subtitle: Text(
                                  archive.description,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                title: Text(
                                  archive.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/ArchiveDetailScreen',
                                    arguments: archive,
                                  );
                                },
                              ),
                            ),
                          )).toList(),
                        )
                            : const Text("No archives in this folder", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 20),
                        ],
                      ),
                    )
                  :Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔼 Add folder info or whatever above the list
                      Text(
                        'Folder [ ${folder.title} ]',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Categories',
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      categories.isNotEmpty
                          ? CategoryTagListWidget(categories: categories)
                          : const Text("No related categories", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            '(${archives.length})',
                            style: const TextStyle(fontSize: 22, color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Archive${archives.length == 1 ? '' : 's'} in this folder',
                            style: const TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 180),
                    child: Column(
                      children: [
                        Image.asset('$defaultImagePath/no_archives.png'),
                        const SizedBox(height: 10),
                        Text(
                          'You have no Archives in this folder yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              }

              return const SizedBox(); // Empty fallback
            },
          ),
        ),
      ),
    );
  }
}
