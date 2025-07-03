import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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

  void _fetchCategories(FetchCategoriesEvent event, Emitter<CategoryState> emit) async{
    emit(CategoryLoading());

    try{
      final result = await getCategories.call();
      result.fold(
        (failure) => emit(CategoryError("Error Loading Categories")),
        (categories) => emit(CategoryLoaded(categories)),
      );
    }catch(e){
      emit(CategoryError("Error Fetching Categories"));
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
              (_) => emit(CategoryCreated()),
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
          (_) => emit(CategoryEdited()),
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
            (_) => emit(CategoryDeleted()),
      );
      } catch (e) {
      emit(CategoryError("Error Deleting Category with ID: ${event.categoryId}"));
    }
  }
}
