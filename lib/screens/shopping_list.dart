import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/shopping_list_provider.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() {
    return _ShoppingListScreenState();
  }
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    var shoppingList = ref.watch(shoppingListProvider);
    var checkboxStates = ref.watch(checkboxStateProvider);

    if (shoppingList.isEmpty) {
      return const Center(
        child: Text(
          'Uh oh, someone forgot to add ingredients in here D:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: shoppingList.length,
      itemBuilder: (context, mealIndex) {
        final meal = shoppingList[mealIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
            ...List.generate(meal.ingredients.length, (ingredientIndex) {
              return Row(
                children: [
                  Checkbox(
                    value: checkboxStates[mealIndex][ingredientIndex],
                    onChanged: (bool? value) {
                      ref.read(checkboxStateProvider.notifier).toggleCheckbox(
                          mealIndex, ingredientIndex, value ?? false);
                    },
                  ),
                  Text(
                    meal.ingredients[ingredientIndex],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
