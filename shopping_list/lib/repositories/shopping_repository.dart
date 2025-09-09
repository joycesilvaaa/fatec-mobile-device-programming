import 'package:shopping_list/models/shopping_item.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:shopping_list/utils/log.dart';

class ShoppingRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/shopping_list.json');
  }

  Future<List<ShoppingListItem>> getAllShoppingListItems() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      if (! await file.exists() || contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData
          .map((item) => ShoppingListItem.fromJson(item))
          .toList();
    } catch (e, s) {
      Log.e("Erro ao ler o arquivo", error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> saveItem(ShoppingListItem item) async {
    try {
      final items = await getAllShoppingListItems();
      items.add(item);
      final file = await _localFile;
      final jsonData = items.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e, s) {
      Log.e("Erro ao salvar o item", error: e, stackTrace: s);
    }
  }

  Future<void> updateItem(int id, String itemName, bool isCompleted) async {
    try {
      final items = await getAllShoppingListItems();
      final index = items.indexWhere((e) => e.id == id);
      if (index != -1) {
        items[index] = items[index].copyWith(
          itemName: itemName,
          isCompleted: isCompleted,
        );
        final file = await _localFile;
        final jsonData = items.map((e) => e.toJson()).toList();
        await file.writeAsString(json.encode(jsonData));
      }
    } catch (e, s) {
      Log.e("Erro ao atualizar o item", error: e, stackTrace: s);
    }
  }

  Future<void> removeItem(int id) async {
    try {
      final items = await getAllShoppingListItems();
      items.removeWhere((item) => item.id == id);
      final file = await _localFile;
      final jsonData = items.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e, s) {
      Log.e("Erro ao remover o item", error: e, stackTrace: s);
    }
  }


}
