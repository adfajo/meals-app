import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class ShoppingListNotifier extends StateNotifier<List<Meal>> {
  ShoppingListNotifier() : super([]);

  bool toggleAddShoppingListStatus(Meal meal, WidgetRef ref) {
    final ingredientsAreAdded = state.contains(meal);

    if (ingredientsAreAdded) {
      return false;
    } else {
      // Add the meal
      state = [...state, meal];
      // Update checkbox states
      ref.read(checkboxStateProvider.notifier).updateCheckboxStates(
          List<List<bool>>.generate(state.length,
              (index) => List.filled(state[index].ingredients.length, false)));
      return true;
    }
  }

  bool toggleDeleteShoppingListStatus(Meal meal, WidgetRef ref) {
    state = state.where((m) => m != meal).toList();
    ref.read(checkboxStateProvider.notifier).updateCheckboxStates(
        List<List<bool>>.generate(state.length,
            (index) => List.filled(state[index].ingredients.length, false)));
    return true;
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Meal>>((ref) {
  return ShoppingListNotifier();
});

class CheckboxStateNotifier extends StateNotifier<List<List<bool>>> {
  CheckboxStateNotifier(List<List<bool>> initialState) : super(initialState);

  void toggleCheckbox(int mealIndex, int ingredientIndex, bool isChecked) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == mealIndex)
          [
            for (int j = 0; j < state[i].length; j++)
              if (j == ingredientIndex) isChecked else state[i][j]
          ]
        else
          state[i]
    ];
  }

  void updateCheckboxStates(List<List<bool>> newStates) {
    state = newStates;
  }
}

final checkboxStateProvider =
    StateNotifierProvider<CheckboxStateNotifier, List<List<bool>>>((ref) {
  return CheckboxStateNotifier([]);
});
