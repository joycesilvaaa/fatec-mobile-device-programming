import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../repositories/shopping_repository.dart';

class ShoppingController extends ChangeNotifier {
  final ShoppingRepository _repository = ShoppingRepository();

  List<ShoppingItem> get items => _repository.items;

  void addItem(ShoppingItem item) {
    if (item.name.isNotEmpty) {
      _repository.addItem(item);
      notifyListeners();
    }
  }

  void toggleItem(int index) {
    _repository.toggleItem(index);
    notifyListeners();
  }

  void removeItem(int index) {
    _repository.removeItem(index);
    notifyListeners();
  }

}
