import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/category_bloc.dart';

import '../../../../core/Common/widgets/Order_by_widget.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/formatTimestampToDate.dart';
import '../../../../cubits/edit_mode_cubit.dart';
import '../../../authentification/presentation/bloc/auth_bloc.dart';

class CategoriesScreen extends StatefulWidget
{
    const CategoriesScreen({super.key});

    @override
    State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
{
    String _selectedFilter = folderFilters[0];

    @override
    initState() 
    {
        super.initState();
        context.read<CategoryBloc>().add(FetchCategoriesEvent());
        context.read<EditModeCubit>().exitEditMode();
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            appBar: AppBar(
                leading: Builder(
                    builder: (context)
                    {
                        return IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: ()
                            {
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
                        onPressed: ()
                        {
                            // Navigate to SearchScreen
                            Navigator.pushNamed(context, '/SearchScreen');
                        },
                    )
                ],
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
                                            "My Categories",
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

                            BlocListener<CategoryBloc, CategoryState>(
                                listener: (BuildContext context, CategoryState state)
                                {
                                    if (state is CategoryError) 
                                    {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(state.error)),
                                        );
                                    }
                                    if (state is CategoryInitial || state is CategoryEdited || state is CategoryDeleted) 
                                    {
                                        context.read<CategoryBloc>().add(FetchCategoriesEvent());
                                    }
                                },
                                child: BlocBuilder<CategoryBloc, CategoryState>(
                                    builder: (BuildContext context, CategoryState state)
                                    {
                                        if (state is CategoryLoading) 
                                        {
                                            return Center(child: CircularProgressIndicator());
                                        }

                                        if (state is CategoryLoaded) 
                                        {
                                            return state.categories.isNotEmpty ?
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
                                                                                "Filters",
                                                                                style: TextStyle(
                                                                                    fontSize: 25,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.deepPurple,
                                                                                ),
                                                                            ),
                                                                            OrderByWidget(
                                                                                tooltipMessage: 'Filter options',
                                                                                tableName: 'Category',
                                                                                options: folderFilters,
                                                                                onOptionSelected: (selectedOption)
                                                                                {
                                                                                    setState(()
                                                                                        {
                                                                                            _selectedFilter = selectedOption;
                                                                                        }
                                                                                    );

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
                                                                            builder: (BuildContext context, EditModeState state)
                                                                            {
                                                                                if (state is EnterEditMode) 
                                                                                {
                                                                                    return TextButton(
                                                                                        onPressed: ()
                                                                                        {
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
                                                                                if (state is ExitEditMode || state is EditModeInitial) 
                                                                                {
                                                                                    return TextButton(
                                                                                        onPressed: ()
                                                                                        {
                                                                                            context.read<EditModeCubit>().enterEditMode();
                                                                                        },
                                                                                        child: Text(
                                                                                            "Edit Categories",
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
                                                                    itemCount: state.categories.length,
                                                                    itemBuilder: (BuildContext context, int index)
                                                                    {
                                                                        final category = state.categories[index];

                                                                        return BlocBuilder<EditModeCubit, EditModeState>(
                                                                            builder: (BuildContext context, state)
                                                                            {
                                                                                return Padding(
                                                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                                                    child: context.read<EditModeCubit>().state is EnterEditMode ?
                                                                                        Card(
                                                                                            elevation: 5,
                                                                                            color: Colors.deepPurple.shade200,
                                                                                            child: ListTile(
                                                                                                leading: Icon(Icons.category, color: Colors.tealAccent, size: 30),
                                                                                                title: Text(category.title, style: TextStyle(fontSize: 25, color: Colors.white),),
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
                                                                                                                    formatTimestampToDate(category.createdAt, format: "dd/MM/yyyy")
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
                                                                                                                    formatTimestampToDate(category.updatedAt, format: "dd/MM/yyyy")
                                                                                                                    , style: TextStyle(
                                                                                                                        fontSize: 15,
                                                                                                                        color: Colors.white
                                                                                                                    )
                                                                                                                ),
                                                                                                            ],
                                                                                                        ),
                                                                                                    ],
                                                                                                ),
                                                                                                trailing: Row(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                        IconButton(
                                                                                                            icon: Icon(Icons.edit, color: Colors.teal, size: 30),
                                                                                                            onPressed: ()
                                                                                                            {
                                                                                                                // Handle edit action
                                                                                                                showFormModal(
                                                                                                                    initialTitle: category.title,
                                                                                                                    formFieldsVal: 
                                                                                                                    {
                                                                                                                        'title': category.title,
                                                                                                                        'icon': category.icon,
                                                                                                                    },
                                                                                                                    context: context,
                                                                                                                    onSave: (formFieldsVal)
                                                                                                                    {
                                                                                                                        // Add category to database or update state here
                                                                                                                        context.read<CategoryBloc>().add(EditCategoryEvent(category.id, formFieldsVal['title'], formFieldsVal['icon']));
                                                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                            SnackBar(content: Text("Category edited successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
                                                                                                                        );
                                                                                                                    },
                                                                                                                );
                                                                                                            },
                                                                                                        ),
                                                                                                        IconButton(
                                                                                                            icon: Icon(Icons.delete, color: Colors.red, size: 30),
                                                                                                            onPressed: ()
                                                                                                            {
                                                                                                                // Handle delete action
                                                                                                                context.read<CategoryBloc>().add(DeleteCategoryEvent(category.id));

                                                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                    SnackBar(content: Text("Category deleted successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.red),
                                                                                                                );
                                                                                                            },
                                                                                                        ),
                                                                                                    ],
                                                                                                ),
                                                                                            ),
                                                                                        ) :
                                                                                        GestureDetector(
                                                                                            onTap: ()
                                                                                            {
                                                                                                Navigator.pushNamed(context, '/CategoryDetailScreen', arguments: category);
                                                                                            },
                                                                                            child: Card(
                                                                                                elevation: 5,
                                                                                                color: Colors.deepPurple.shade200,
                                                                                                child: ListTile(
                                                                                                    leading: Icon(Icons.category, color: Colors.tealAccent, size: 30),
                                                                                                    title: Text(category.title, style: TextStyle(fontSize: 25, color: Colors.white),),
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
                                                                                                                        formatTimestampToDate(category.createdAt, format: "dd/MM/yyyy")
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
                                                                                                                        formatTimestampToDate(category.updatedAt, format: "dd/MM/yyyy")
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
                                                ) :
                                                Center(child: Text("No categorys found."));
                                        }

                                        if (state is CategoryError) 
                                        {
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
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.tealAccent.shade700,
                onPressed: ()
                {
                    showFormModal(
                        context: context,
                        onSave: (formFieldsVal)
                        {
                            // Add category to database or update state here
                            context.read<CategoryBloc>().add(AddNewCategoryEvent(formFieldsVal['title'], formFieldsVal['icon']));
                            context.read<CategoryBloc>().add(ResetCategoryToInitialStateEvent());
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Folder created successfully!", style: TextStyle(color: Colors.white, fontSize: 20)), backgroundColor: Colors.teal),
                            );
                        },
                    );
                },
                child: Icon(Icons.add, color: Colors.deepPurple, size: 40,),
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
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _titleController.text.isEmpty ? 'Add New Category' : 'Edit Category',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Category Title',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal, width: 2.0),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            onSave?.call(
                              {
                                'title': _titleController.text,
                                'icon': '',
                              },
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade200,
                        ),
                        child: Text(
                          _titleController.text.isEmpty ? 'Add Category' : 'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
            );
        }
    );


}
