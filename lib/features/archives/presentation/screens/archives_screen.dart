import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';
import 'package:my_archives/features/home/presentation/bloc/archive_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/folder_bloc.dart';

import '../../../../core/Common/widgets/Order_by_widget.dart';
import '../../../../core/Common/widgets/app_drawer_widget.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/formatTimestampToDate.dart';
import '../../../../cubits/edit_mode_cubit.dart';
import '../../../authentification/presentation/bloc/auth_bloc.dart';

class ArchivesScreen extends StatefulWidget {
  const ArchivesScreen({super.key});

  @override
  State<ArchivesScreen> createState() => _ArchivesScreenState();
}

class _ArchivesScreenState extends State<ArchivesScreen> {
  String _selectedFilter = folderFilters[0];

  @override
  initState(){
    super.initState();
    context.read<ArchiveBloc>().add(FetchArchivesEvent());
    context.read<EditModeCubit>().exitEditMode();
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
        title: Text("MyArchives", style: TextStyle(color: Colors.white, fontSize: 25),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to SearchScreen
              Navigator.pushNamed(context, '/SearchScreen');
            },
          )
        ],
      ),
      drawer: AppDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
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
                      child: Text(
                        "My Archives",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                BlocListener<ArchiveBloc, ArchiveState>(
                  listener: (BuildContext context, ArchiveState state) {
                    if (state is ArchiveError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error, style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.red)
                      );
                    }

                    if (state is ArchiveEdited) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Archive edited successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
                      );
                      context.read<ArchiveBloc>().add(FetchArchivesEvent());
                    }

                    if (state is ArchiveDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Archive deleted successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
                      );
                      context.read<ArchiveBloc>().add(FetchArchivesEvent());
                    }

                    if (state is ArchiveCreated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Archive created successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
                      );
                      context.read<ArchiveBloc>().add(FetchArchivesEvent());
                    }

                    // if (state is ArchiveInitial || state is ArchiveEdited || state is ArchiveDeleted || state is ArchiveCreated) {
                    //   context.read<ArchiveBloc>().add(FetchArchivesEvent());
                    // }
                  },
                  child: BlocBuilder<ArchiveBloc, ArchiveState>(
                    builder: (BuildContext context, ArchiveState state) {
                      if (state is ArchiveLoading) {
                        return Padding(padding: EdgeInsets.only(top: 25), child: Center(child: CircularProgressIndicator()));
                      }

                      if (state is ArchiveLoaded) {
                        return state.archives.isNotEmpty ?
                        RefreshIndicator(
                          onRefresh: () async {
                            context.read<ArchiveBloc>().add(FetchArchivesEvent());
                          },
                          child: SingleChildScrollView(
                            child: Container(
                              color: Colors.deepPurple,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                          "Sort Options",
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
                                  SizedBox(height: 25),
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
                                        ),
                                      ),
                                      Spacer(),
                                      BlocBuilder<EditModeCubit, EditModeState>(
                                        builder: (BuildContext context, EditModeState state) {
                                          if(state is EnterEditMode){
                                            return TextButton(
                                              onPressed: (){
                                                context.read<EditModeCubit>().exitEditMode();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                            );
                                          }
                                          if(state is ExitEditMode || state is EditModeInitial){
                                            return TextButton(
                                              onPressed: (){
                                                context.read<EditModeCubit>().enterEditMode();
                                              },
                                              child: Text(
                                                "Edit Archives",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.archives.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final archive = state.archives[index];

                                      return BlocBuilder<EditModeCubit, EditModeState>(
                                        builder: (BuildContext context, state) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: context.read<EditModeCubit>().state is EnterEditMode ?
                                            Card(
                                              elevation: 5,
                                              color: Colors.deepPurple.shade200,
                                              child: ListTile(
                                                leading: Image(image: AssetImage('$defaultImagePath/archive_cover.png'), height: 40, width: 40,),
                                                title: Text(archive.title, style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.bold),),
                                                subtitle: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 180,
                                                          child: Text(
                                                            (archive.description.length > 100 ? "${archive.description.substring(0, 15)}..." : archive.description),
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white
                                                            )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Created at: ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                        Text(
                                                            formatTimestampToDate(archive.createdAt, format: "dd/MM/yyyy")
                                                            , style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white
                                                        )
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                trailing:  BlocBuilder<FolderBloc, FolderState>(
                                                  builder: (BuildContext context, state) {
                                                    if (state is FolderLoaded) {
                                                      return Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(Icons.edit, color: Colors.teal, size: 25),
                                                            onPressed: () {
                                                              // Handle edit action
                                                              showFormModal(
                                                                initialTitle: archive.title,
                                                                initialDescription: archive.description,
                                                                availableFolders: state.folders,
                                                                context: context,
                                                                onSave: (formFieldsVal) {
                                                                  // Add archive to database or update state here
                                                                  context.read<ArchiveBloc>().add(
                                                                    EditArchiveEvent(
                                                                      archive.id,
                                                                      formFieldsVal['title'],
                                                                      formFieldsVal['description'],
                                                                      formFieldsVal['cover_image'],
                                                                      formFieldsVal['resource_paths'] as List<String>,
                                                                      formFieldsVal['folder_id'] ?? archive.folderId
                                                                    )
                                                                  );
                                                                  // context.read<ArchiveBloc>().add(FetchArchivesEvent());
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons.delete, color: Colors.red, size: 25),
                                                            onPressed: () {
                                                              // Handle delete action
                                                              context.read<ArchiveBloc>().add(
                                                                  DeleteArchiveEvent(archive.id)
                                                              );
                                                              // context.read<ArchiveBloc>().add(FetchArchivesEvent());
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            ):
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.pushNamed(context, '/ArchiveDetailScreen', arguments: archive);
                                              },
                                              child: Card(
                                                elevation: 5,
                                                color: Colors.deepPurple.shade200,
                                                child: ListTile(
                                                  leading: Image(image: AssetImage('$defaultImagePath/archive_cover.png'), height: 55, width: 55,),
                                                  title: Text(archive.title, style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.bold),),
                                                  subtitle: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: Text(
                                                                (archive.description.length > 100 ? "${archive.description.substring(0, 50)}..." : archive.description),
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.white
                                                                )
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Created at: ",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.white
                                                            ),
                                                          ),
                                                          Text(
                                                              formatTimestampToDate(archive.createdAt, format: "dd/MM/yyyy")
                                                              , style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white
                                                          )
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: null,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  )
                                ],
                              ),
                            ),
                          ),
                        ):
                        Center(child: Text("No archives found."));
                      }

                      if (state is ArchiveError) {
                        return Text("Error: ${state.error}");
                      }
                      return Text("Unexpected state. Please try again.",);
                    },
                  ),
                ),
              ]
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<FolderBloc, FolderState>(
        builder: (BuildContext context, state) {
          if (state is FolderLoaded) {
            return FloatingActionButton(
              backgroundColor: Colors.tealAccent.shade700,
              onPressed: () {
                context.read<FolderBloc>().add(FetchFoldersEvent());
                showFormModal(
                  context: context,
                  availableFolders: state.folders,
                  onSave: (formFieldsVal) {
                    // Print the form fields values
                    // print('Form fields values: $formFieldsVal');
                    // Add archive to database or update state here
                    context.read<ArchiveBloc>().add(
                      CreateArchiveEvent(
                        formFieldsVal['title'],
                        formFieldsVal['description'],
                        formFieldsVal['cover_image'],
                        formFieldsVal['resource_paths'].isEmpty ? [] : formFieldsVal['resource_paths'] ,
                        formFieldsVal['folder_id']
                      )
                    );
                  },
                );
              },
              child: Icon(Icons.add, color: Colors.deepPurple, size: 40,),
            );
          }
          return Container();
        },
      ),
    );
  }
}


void showFormModal({
  required BuildContext context,
  String? initialTitle,
  String? initialDescription,
  int? initialFolder,
  List<Folder>? availableFolders, // List of folder options
  Function(Map<String, dynamic> formFieldsVal)? onSave,
})
{
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController(text: initialTitle);
  final TextEditingController descriptionController = TextEditingController(text: initialDescription);
  int? selectedFolder = initialFolder;
  String? selectedFile;
  List<String>? selectedFiles = [];

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context)
      {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                initialTitle == null ? 'Add New Archive' : 'Edit Archive',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Archive Title',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an archive title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Archive Description',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an archive description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedFolder,
                items: availableFolders!.map((folder) => DropdownMenuItem(
                  value: folder.id,
                  child: Text(folder.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )).toList(),
                onChanged: (value) {
                  selectedFolder = value;
                },
                decoration: InputDecoration(
                  labelText: 'Select Folder',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                dropdownColor: Colors.deepPurple.shade200,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a folder';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // A form field to pick any file type (image, pdf, word, txt ...)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedFile != null ? 'Path ($selectedFile)' : 'Cover Image',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.tealAccent),
                    onPressed: () async {
                      try {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt', 'xlsx'],
                        );
                        if (result != null) {
                          selectedFile = result.files.single.path;
                        }
                      } catch (e) {
                        // print(e);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedFiles!.isEmpty ? 'Add Resources: ' : 'Selected Resources: ${selectedFiles!.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.tealAccent),
                    onPressed: () async {
                      try {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt', 'xlsx'],
                          allowMultiple: true,
                        );
                        if (result != null) {
                          selectedFiles = result.files.map((file) => file.path).cast<String>().toList();
                          // print("Resources files path: ${selectedFiles.toString()}");
                        }
                      } catch (_) {
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onSave?.call({
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "folder_id": selectedFolder,
                      "cover_image": selectedFile ?? '',
                      "resource_paths": selectedFiles ?? [],
                    });
                    Navigator.pop(context);
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade200,
                ),
                child: Text(
                  initialTitle == null ? 'Add Archive' : 'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          ),
        );
      }
  );


}
