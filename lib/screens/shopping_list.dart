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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meal.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final wasAdded = ref
                              .read(shoppingListProvider.notifier)
                              .toggleDeleteShoppingListStatus(meal, ref);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ingredients deleted!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),  // Space between title and ingredients
                  ...List.generate(meal.ingredients.length, (ingredientIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
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
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
