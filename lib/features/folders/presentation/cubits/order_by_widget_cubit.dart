import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'order_by_widget_state.dart';

class OrderByWidgetCubit extends Cubit<OrderByWidgetState> {
  OrderByWidgetCubit() : super(OrderByWidgetInitial());

  void setSelected(String selected) {
    emit(OrderByWidgetInitial());
  }

  void changeToLasAdded() {
    emit(OrderByWidgetLastAdded());
  }

  void changeToLastUpdated() {
    emit(OrderByWidgetLastUpdated());
  }

  void changeToTitleAsc() {
    emit(OrderByWidgetTitleAsc());
  }

  void changeToTitleDesc() {
    emit(OrderByWidgetTitleDesc());
  }
}
