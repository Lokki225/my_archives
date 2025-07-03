import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/Common/widgets/category_tag_list_widget.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';

import '../../../home/presentation/bloc/folder_bloc.dart';

class FolderDetailScreen extends StatefulWidget {
  const FolderDetailScreen({super.key});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the argument passed from the previous screen
    final folder = ModalRoute.of(context)?.settings.arguments as Folder;

    // Get folder related archives
    context.read<FolderBloc>().add(FetchFolderRelatedArchivesEvent(folder.id));

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

              if (state is FolderRelatedArchivesLoaded) {
                final folderArchives = state.archives;

                return SingleChildScrollView(
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
                      CategoryTagListWidget(tags: ["ID", "PDFs", "Photos"]),
                      const SizedBox(height: 20),
                      Row(
                        spacing: 10,
                        children: [
                          Text(
                            '(${folderArchives.length})',
                            style: const TextStyle(fontSize: 22, color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Archive${folderArchives.length == 1 ? '' : 's'} in this folder',
                            style: const TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 🔁 Archives list manually
                      ...folderArchives.map((archive) => Padding(
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
                      )),

                      const SizedBox(height: 20),
                    ],
                  ),
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
