class ShoppingItem {
  String id;
  String name;
  bool isBought;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isBought = false,
  });
}