import 'package:shopping_list/repositories/shopping_repository.dart';
import 'package:shopping_list/models/shopping_item.dart';


class ShoppingController {
  final ShoppingRepository _shoppingRepository = ShoppingRepository();

  Future<List<ShoppingListItem>> fetchAllItems() async {
    return await _shoppingRepository.getAllShoppingListItems();
  }

  Future<void> addItem(ShoppingListItem item) async {
    await _shoppingRepository.saveItem(item);
  }

  Future<void> updateItem(int id, String newName, bool isCompleted) async {
    await _shoppingRepository.updateItem(id, newName, isCompleted);
  }

  Future<void> removeItem(int id) async {
    await _shoppingRepository.removeItem(id);
  }

}