import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/categories/domain/usecases/GetCategories.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';
import 'package:my_archives/features/home/domain/usecases/GetCategoriesByQuery.dart';

import '../../../../cubits/app_cubit.dart';
import '../../../../injection_container.dart';
import '../../../categories/domain/usecases/AddNewCategory.dart';
import '../../../categories/domain/usecases/DeleteCategory.dart';
import '../../../categories/domain/usecases/EditCategory.dart';
import '../../domain/usecases/GetUserByFirstName.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetUserByFirstName getUserByFirstName;
  final GetCategories getCategories;
  final AddNewCategory addNewCategory;
  final EditCategory editCategory;
  final DeleteCategory deleteCategory;
  final GetCategoriesByQuery getCategoriesByQuery;

  CategoryBloc({
    required this.getUserByFirstName,
    required this.getCategoriesByQuery,
    required this.getCategories,
    required this.addNewCategory,
    required this.editCategory,
    required this.deleteCategory,
}) : super(CategoryInitial()) {
    on<FetchCategoriesByQueryEvent>(_fetchCategoriesByQuery);
    on<ResetCategoryToInitialStateEvent>(_resetCategoryToInitialState);
    on<FetchCategoriesEvent>(_fetchCategories);
    on<AddNewCategoryEvent>(_addNewCategory);
    on<EditCategoryEvent>(_editCategory);
    on<DeleteCategoryEvent>(_deleteCategory);
  }

  void _fetchCategories(FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());

    try {
      // Get user id by logged user first name
      final currentLoggedUserFirstName = await sL<AppCubit>().getUserFirstName();
      if (currentLoggedUserFirstName == null) return;

      final resultUser = await getUserByFirstName.call(currentLoggedUserFirstName);

      await resultUser.fold(
            (failure) async {
          if (!emit.isDone) emit(CategoryError("Error retrieving logged user info"));
        },
            (user) async {
          final result = await getCategories.call(event.sortOption, user.id);

          if (emit.isDone) return;

          result.fold(
                (failure) {
              if (!emit.isDone) emit(CategoryError("Error Loading Categories"));
            },
                (categories) {
              if (!emit.isDone) emit(CategoryLoaded(categories));
            },
          );
        },
      );
    } catch (e) {
      if (!emit.isDone) emit(CategoryError("Error Fetching Categories"));
    }
  }

  void _fetchCategoriesByQuery(FetchCategoriesByQueryEvent event, Emitter<CategoryState> emit) async{
    emit(CategoryLoading());
    final result = await getCategoriesByQuery.call(event.query);
    try {
      result.fold(
            (failure) => emit(CategoryError("Error Loading Categories")),
            (categories) => emit(CategoryLoaded(categories)),
      );
    } catch (e) {
      emit(CategoryError("Error Fetching Categories by Query: ${event.query}"));
    }
  }

  void _resetCategoryToInitialState(ResetCategoryToInitialStateEvent event, Emitter<CategoryState> emit) {
    emit(CategoryInitial());
  }

  void _addNewCategory(AddNewCategoryEvent event, Emitter<CategoryState> emit) async{
    emit(CategoryLoading());

    final currentLoggedUserFirstName = await sL<AppCubit>().getUserFirstName();
    if(currentLoggedUserFirstName == null) return;
    final resultUser = await getUserByFirstName.call(currentLoggedUserFirstName);

    resultUser.fold(
        (failure) => emit(CategoryError("An error occurred while fetching User: ${event.title}")),
        (user) async{
          try{
            final newCategory = Category(
              id: 0,
              title: event.title,
              icon: event.icon,
              userId: user.id,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            );
            final result = await addNewCategory.call(newCategory);
            result.fold(
              (failure) => emit(CategoryError("Error Creating New Category")),
              (_) async{
                // Add into TableChangeTracker
                await sL<AppCubit>().insertTableChange("Category", newCategory.id, TableChangeStatus.created, user.id);

                // Emit CategoryCreated
                emit(CategoryCreated());
              },
            );
          }catch(e){
            emit(CategoryError("Error Adding New Category"));
          }
        }
    );

  }

  void _editCategory(EditCategoryEvent event, Emitter<CategoryState> emit) async{
    emit(CategoryLoading());
    final result = await editCategory.call(event.id, event.title, event.icon);
    try {
      result.fold(
          (failure) => emit(CategoryError("Error Editing Category")),
          (_) async{
            // Add into TableChangeTracker
            final currentLoggedUserFirstName = await sL<AppCubit>().getUserFirstName();
            if(currentLoggedUserFirstName == null) return;
            final resultUser = await getUserByFirstName.call(currentLoggedUserFirstName);

            resultUser.fold(
              (failure) => emit(CategoryError("An error occurred while fetching User: ${event.id}")),
              (user) async{
                await sL<AppCubit>().insertTableChange("Category", event.id, TableChangeStatus.modified, user.id);
                emit(CategoryEdited());
              }
            );
          },
      );
      } catch (e) {
      emit(CategoryError("Error Updating Category with ID: ${event.id}"));
    }
  }

  void _deleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async{
    emit(CategoryLoading());
    final result = await deleteCategory.call(event.categoryId);

    try {
      result.fold(
            (failure) => emit(CategoryError("Error Deleting Category")),
            (_) async{
              // Add into TableChangeTracker
              final currentLoggedUserFirstName = await sL<AppCubit>().getUserFirstName();
              if(currentLoggedUserFirstName == null) return;
              final resultUser = await getUserByFirstName.call(currentLoggedUserFirstName);

              resultUser.fold(
                (failure) => emit(CategoryError("An error occurred while fetching User: ${event.categoryId}")),
                  (user) async{
                  await sL<AppCubit>().insertTableChange("Category", event.categoryId, TableChangeStatus.deleted, user.id);
                  emit(CategoryDeleted());
                }
              );
            },
      );
      } catch (e) {
      emit(CategoryError("Error Deleting Category with ID: ${event.categoryId}"));
    }
  }
}
