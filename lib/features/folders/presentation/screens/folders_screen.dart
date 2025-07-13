import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:my_archives/core/Common/widgets/Order_by_widget.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/home/presentation/bloc/category_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/folder_bloc.dart';
import 'package:my_archives/injection_container.dart';

import '../../../../bdd_test_manip.dart';
import '../../../../core/Common/widgets/app_drawer_widget.dart';
import '../../../../core/database/local.dart';
import '../../../../core/database/seeds/local_database_seeder.dart';
import '../../../../core/util/formatTimestampToDate.dart';
import '../../../../cubits/app_cubit.dart';
import '../../../../cubits/edit_mode_cubit.dart';
import '../../../authentification/presentation/bloc/auth_bloc.dart';
import '../../../home/domain/entities/category_entity.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {

  String _selectedFilter = folderFilters[0];

  @override
  void initState() {
    super.initState();
    context.read<FolderBloc>().add(FetchFoldersEvent());
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<EditModeCubit>().exitEditMode();

    final seeder = DatabaseSeeder(sL<LocalDatabase>());
    // seeder.seedFolderCategory();
    // final localDBUserTest = LocalDBUserTest(localDB: LocalDatabase());
    //
    // localDBUserTest.run();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> _selectedCategories = [];

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
                        "My Folders",
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

                BlocListener<FolderBloc, FolderState>(
                  listener: (BuildContext context, FolderState state) {
                    if (state is FolderError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                    if (state is FolderCreated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Folder created successfully!")),
                      );
                    }
                  },
                  child: BlocBuilder<FolderBloc, FolderState>(
                    builder: (BuildContext context, FolderState state) {
                      if (state is FolderLoading || state is FolderInitial) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (state is FolderLoaded) {


                        return state.folders.isNotEmpty ?
                          SingleChildScrollView(
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
                                          "Sort by",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        OrderByWidget(
                                          tooltipMessage: 'Filter options',
                                          tableName: 'Folder',
                                          options: folderFilters,
                                          onOptionSelected: (selectedOption) {
                                            setState(() {
                                              _selectedFilter = selectedOption;
                                            });
                                            switch (selectedOption) {
                                              case 'All':
                                                context.read<FolderBloc>().add(FetchFoldersEvent());
                                                break;
                                              case 'Last Added':
                                                context.read<FolderBloc>().add(FetchFoldersEvent(sortOption: SortingOption.lastAddedFirst));
                                                break;
                                              case 'Last Updated':
                                                context.read<FolderBloc>().add(FetchFoldersEvent(sortOption: SortingOption.lastUpdatedFirst));
                                                break;
                                              case 'Title Asc':
                                                context.read<FolderBloc>().add(FetchFoldersEvent(sortOption: SortingOption.titleAZ));
                                                break;
                                              case 'Title Desc':
                                                context.read<FolderBloc>().add(FetchFoldersEvent(sortOption: SortingOption.titleZA));
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
                                                "Edit Folders",
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
                                  itemCount: state.folders.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final folder = state.folders[index];

                                    return BlocBuilder<EditModeCubit, EditModeState>(
                                      builder: (BuildContext context, state) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: context.read<EditModeCubit>().state is EnterEditMode ?
                                          Card(
                                            elevation: 5,
                                            color: Colors.deepPurple.shade200,
                                            child: ListTile(
                                              leading: Image(image: AssetImage('$defaultImagePath/folder_cover.png'), height: 40, width: 40,),
                                              title: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin: EdgeInsets.only(right: 8), // Add spacing between color dot and text
                                                  decoration: BoxDecoration(
                                                    color: folder.getColorFromHexaString(folder.color),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white, width: 1),
                                                  ),
                                                ),
                                                Expanded( // Prevents overflow
                                                  child: Text(
                                                    folder.title,
                                                    style: TextStyle(fontSize: 25, color: Colors.white),
                                                    overflow: TextOverflow.ellipsis, // Handles long folder names
                                                  ),
                                                ),
                                              ],
                                            ),
                                              subtitle: Column(
                                                children: [
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
                                                          formatTimestampToDate(folder.createdAt, format: "dd/MM/yyyy")
                                                          , style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white
                                                      )
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Updated at: ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                      Text(
                                                          formatTimestampToDate(folder.updatedAt, format: "dd/MM/yyyy")
                                                          , style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white
                                                      )
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing:  Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  BlocBuilder<CategoryBloc, CategoryState>(
                                                    builder: (BuildContext context, CategoryState state) {
                                                      if (state is CategoryLoading) {
                                                        return CircularProgressIndicator();
                                                      }
                                                      if (state is CategoryLoaded) {
                                                        return IconButton(
                                                          icon: Icon(Icons.edit, color: Colors.teal, size: 25),
                                                          onPressed: () {
                                                            // Handle edit action
                                                            // print("Folder Categories: ${folder.relatedCategories}");

                                                            showFormModal(
                                                              initialTitle: folder.title,
                                                              formFieldsVal: {
                                                                'initialColor': folder.color,
                                                                'categories': state.categories,
                                                                'relatedCategories': folder.relatedCategories,
                                                              },
                                                              context: context,
                                                              onSave: (formFieldsVal) {
                                                                // Add folder to database or update state here
                                                                context.read<FolderBloc>().add(EditFolderEvent(folder.id, formFieldsVal['title'], formFieldsVal['color'], formFieldsVal['categories']));
                                                                context.read<FolderBloc>().add(FetchFoldersEvent());
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text("Folder edited successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                      return Container();
                                                    }
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete, color: Colors.red, size: 25),
                                                    onPressed: () {
                                                      // Handle delete action
                                                      context.read<FolderBloc>().add(DeleteFolderEvent(folder.id));
                                                      context.read<FolderBloc>().add(FetchFoldersEvent());
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("Folder deleted successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.red),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ):
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.pushNamed(context, '/FolderDetailScreen', arguments: folder);
                                            },
                                            child: Card(
                                              elevation: 5,
                                              color: Colors.deepPurple.shade200,
                                              child: ListTile(
                                                leading: Image(image: AssetImage('$defaultImagePath/folder_cover.png'), height: 40, width: 40,),
                                                title: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  spacing: 5,
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: folder.getColorFromHexaString(folder.color),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.white, width: 1),
                                                      ),
                                                      child: Text(
                                                        "", style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white
                                                      ),
                                                      ),
                                                    ),
                                                    Text(folder.title, style: TextStyle(fontSize: 25, color: Colors.white),),
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  children: [
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
                                                            formatTimestampToDate(folder.createdAt, format: "dd/MM/yyyy")
                                                            , style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white
                                                        )
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Updated at: ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                        Text(
                                                            formatTimestampToDate(folder.updatedAt, format: "dd/MM/yyyy")
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
                                                                  )],
                              ),
                            ),
                          ):
                          Center(child: Text("No folders found.",style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                          )));
                      }

                      if (state is FolderError) {
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
      floatingActionButton: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (BuildContext context, CategoryState state) {
         if (state is CategoryLoading) {
            return CircularProgressIndicator();
          }

          if (state is CategoryLoaded) {
            return FloatingActionButton(
              backgroundColor: Colors.tealAccent.shade700,
              onPressed: () {
                showFormModal(
                  context: context,
                  formFieldsVal: {'categories': state.categories, 'color': Colors.teal.toHexString()},
                  onSave: (formFieldsVal) {
                    // Add folder to database or update state here
                    context.read<FolderBloc>().add(AddNewFolderEvent(formFieldsVal['title'], formFieldsVal['color'], formFieldsVal['categories']));
                    context.read<FolderBloc>().add(FetchFoldersEvent(sortOption: SortingOption.lastAddedFirst));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Folder created successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
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
  Map<String, dynamic>? formFieldsVal, // Form fields to prefill data
  Function(Map<String, dynamic> formFieldsVal)? onSave,
})
{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController(text: initialTitle ?? formFieldsVal?['title'] ?? "");

  Color _selectedColor = formFieldsVal?['color'] != null
      ? Color(int.parse(formFieldsVal!['color'], radix: 16))
      : Colors.teal; // Default color fallback

  List<Category> _selectedCategories = formFieldsVal?['relatedCategories'] ?? [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.deepPurple,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final List<Category> categories = formFieldsVal?['categories'] ?? [];

      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _titleController.text.isEmpty ? 'Add New Folder' : 'Edit Folder',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Folder Title',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a folder title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              MultiSelectDialogField<Category>(
                items: categories.map((c) => MultiSelectItem<Category>(c, c.title)).toList(),
                title: Text("Categories"),
                initialValue: categories.where((c) => _selectedCategories.contains(c)).toList(),
                selectedColor: Colors.deepPurple.shade300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
                buttonIcon: Icon(Icons.category, color: Colors.white),
                buttonText: Text("Select Categories", style: TextStyle(color: Colors.white)),
                onConfirm: (results) {
                  _selectedCategories = results;
                },
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: Colors.deepPurple.shade100,
                  textStyle: TextStyle(color: Colors.deepPurple.shade900),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Select Color:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final pickedColor = await showDialog<Color>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Pick a Color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) => Navigator.pop(context, color),
                            ),
                          ),
                        ),
                      );

                      if (pickedColor != null) {
                        _selectedColor = pickedColor;
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onSave?.call(
                      {
                        'title': _titleController.text,
                        'color': _selectedColor.toHexString(), // Convert color to hex string
                        'categories': _selectedCategories,
                      },
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade200,
                ),
                child: Text(
                  _titleController.text.isEmpty ? 'Add Folder' : 'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      );
    },
  );
}