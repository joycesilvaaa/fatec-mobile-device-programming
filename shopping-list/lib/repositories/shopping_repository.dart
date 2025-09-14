import '../models/shopping_item.dart';

class ShoppingRepository {
  List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => _items;

  void addItem(ShoppingItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    _items.removeAt(index);
  }

  void toggleItem(int index) {
    _items[index].isBought = !_items[index].isBought;
  }

  void updateItem(ShoppingItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }
}
