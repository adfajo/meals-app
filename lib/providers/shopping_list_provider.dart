import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class ShoppingListNotifier extends StateNotifier<List<Meal>> {
  ShoppingListNotifier() : super([]);

  bool toggleAddShoppingListStatus(Meal meal) {
    final ingredientsAreAdded = state.contains(meal);

    if (ingredientsAreAdded) {
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Meal>>((ref) {
  return ShoppingListNotifier();
});
