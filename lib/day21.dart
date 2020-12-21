import 'package:aoc2020/structures.dart';

Solutions run(String input) {
  var sols = Solutions();

  final pat = RegExp(r'^(.+) \(contains (.+)\)$');

  var ingredientLists = <IngredientList>[];
  for (var line in input.trim().split('\n')) {
    final m = pat.firstMatch(line);
    final ingredients = m.group(1).split(' ');
    final allergens = m.group(2).split(', ');
    ingredientLists.add(IngredientList(ingredients, allergens));
  }

  // for (var item in ingredientLists) {
  //   print(item);
  // }

  // For each allergen, the possible ingredients it might be in.
  var allergenIngredients = <String, Set<String>>{};
  // For each ingredient, the allergens it might contain.
  // var possibleIngredientAllergen = <String, String>{};

  for (var list in ingredientLists) {
    for (var allergen in list.aller) {
      if (allergenIngredients.containsKey(allergen)) {
        allergenIngredients[allergen] =
            allergenIngredients[allergen].intersection(list.ing);
      } else {
        allergenIngredients[allergen] = list.ing;
      }
    }
  }

  final posAnAllergen =
      allergenIngredients.values.fold(<String>{}, (prev, e) => e.union(prev));
  var counter = 0;
  for (var list in ingredientLists) {
    for (var ing in list.ing) {
      if (!posAnAllergen.contains(ing)) {
        counter++;
      }
    }
  }

  sols.part1 = counter.toString();

  var ingredientAllergens = <String, Set<String>>{};
  for (var allergen in allergenIngredients.entries) {
    for (var ing in allergen.value) {
      if (!ingredientAllergens.containsKey(ing)) {
        ingredientAllergens[ing] = {};
      }
      ingredientAllergens[ing].add(allergen.key);
    }
  }

  // allergenIngredients: map of allergens to possible ingredients
  // ingredientAllergens: map of ingredients to possible allergens
  final needed = allergenIngredients.length;
  // Allergens with only one ingredient
  var identifiedAllergens = <String, String>{};
  while (identifiedAllergens.length < needed) {
    final allergens = allergenIngredients.keys.toList();
    for (var allergen in allergens) {
      if (allergenIngredients[allergen].length == 1) {
        var ingredient = allergenIngredients[allergen].first;
        identifiedAllergens[allergen] = ingredient;
        allergenIngredients.remove(allergen);
        for (var aller in allergenIngredients.values) {
          aller.remove(ingredient);
        }
        ingredientAllergens.remove(ingredient);
        for (var ing in ingredientAllergens.values) {
          ing.remove(allergen);
        }
      }
    }
    final ingredients = ingredientAllergens.keys.toList();
    for (var ingredient in ingredients) {
      if (ingredientAllergens[ingredient].length == 1) {
        var allergen = ingredientAllergens[ingredient].first;
        identifiedAllergens[allergen] = ingredient;
        ingredientAllergens.remove(ingredient);
        for (var ing in ingredientAllergens.values) {
          ing.remove(allergen);
        }
        allergenIngredients.remove(allergen);
        for (var aller in allergenIngredients.values) {
          aller.remove(ingredient);
        }
      }
    }
  }

  // print(identifiedAllergens);
  var canonical =
      identifiedAllergens.entries.map((e) => [e.key, e.value]).toList();
  canonical.sort((a, b) => a[0].compareTo(b[0]));
  sols.part2 = canonical.map((e) => e[1]).join(',');

  return sols;
}

class IngredientList {
  Set<String> ing;
  Set<String> aller;
  IngredientList(List<String> i, List<String> a) {
    ing = i.toSet();
    aller = a.toSet();
  }
  @override
  String toString() {
    return ing.join(' ') + ' (contains ' + aller.join(', ') + ')';
  }
}
