import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(NavigationState(0)) {
    on<NavigationItemTapped>((event, emit) {
      emit(NavigationState(event.index));
    });
  }


}
