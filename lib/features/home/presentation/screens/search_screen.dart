import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/archive_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/category_bloc.dart';

import '../../../../core/Common/widgets/search_result_widget.dart';
import '../bloc/folder_bloc.dart';
import '../cubits/search_field_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SearchFieldInitial.clearFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              SearchFieldInitial.clearFields();
              context.read<ArchiveBloc>().add(FetchArchivesEvent());
              context.read<FolderBloc>().add(FetchFoldersEvent());
              context.read<CategoryBloc>().add(FetchCategoriesEvent());
            },
          ),
          title: TextField(
            controller: SearchFieldInitial.queryController,
            autofocus: true,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white70),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                final query = SearchFieldInitial.queryController.text;
                context.read<ArchiveBloc>().add(FetchArchivesByQueryEvent(query));
                context.read<FolderBloc>().add(FetchFoldersByQueryEvent(query));
                context.read<CategoryBloc>().add(FetchCategoriesByQueryEvent(query));
              },
              icon: Icon(Icons.search, color: Colors.tealAccent.shade400),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.tealAccent,
            dividerColor: Colors.white70,
            labelStyle: TextStyle(color: Colors.tealAccent, fontSize: 15),
            unselectedLabelStyle: TextStyle(color: Colors.white70, fontSize: 15),
            tabs: [
              Tab(icon: Icon(Icons.archive_outlined, color: Colors.white), text: 'Archives'),
              Tab(icon: Icon(Icons.folder_open_outlined, color: Colors.white), text: 'Folders'),
              Tab(icon: Icon(Icons.category_outlined, color: Colors.white), text: 'Categories'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocListener<ArchiveBloc, ArchiveState>(
              listener: (context, state) {
                if (state is ArchiveError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: BlocBuilder<ArchiveBloc, ArchiveState>(
                builder: (context, state) {
                  if (state is ArchiveLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.tealAccent.shade400),
                    );
                  }

                  if (state is ArchiveLoaded) {
                    return SearchResultWidget(
                      query: SearchFieldInitial.queryController.text,
                      queryFor: 'archives',
                      archives: state.archives,
                      folders: null,
                      categories: null,
                    );
                  }

                  return Center(
                    child: Text(
                      state is ArchiveInitial
                          ? 'Your results will appear here'
                          : 'Unexpected state: ${state.runtimeType}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            BlocListener<FolderBloc, FolderState>(
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
                    return Center(
                      child: CircularProgressIndicator(color: Colors.tealAccent.shade400),
                    );
                  }

                  if (state is FolderLoaded) {
                    return SearchResultWidget(
                      query: SearchFieldInitial.queryController.text,
                      queryFor: 'folders',
                      archives: null,
                      folders: state.folders,
                      categories: null,
                    );
                  }

                  return Center(
                    child: Text(
                      state is FolderInitial
                          ? 'Your results will appear here'
                          : 'Unexpected state: ${state.runtimeType}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.tealAccent.shade400),
                    );
                  }

                  if (state is CategoryLoaded) {
                    return SearchResultWidget(
                      query: SearchFieldInitial.queryController.text,
                      queryFor: 'categories',
                      archives: null,
                      folders: null,
                      categories: state.categories,
                    );
                  }

                  return Center(
                    child: Text(
                      state is CategoryInitial
                          ? 'Your results will appear here'
                          : 'Unexpected state: ${state.runtimeType}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
