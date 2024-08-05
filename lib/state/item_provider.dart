import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../class/item.dart';
import 'package:new_calc/lib/db/database_helper.dart';

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier() : super([]) {
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await DatabaseHelper.instance.readAllItems();
    state = items.map((item) {
      final parsedItem = Item.fromJson(item);
      parsedItem.quantity = 0;
      return parsedItem;
    }).toList();
  }

  Future<void> addItem(Item item) async {
    await DatabaseHelper.instance.create(item.toJson());
    await _fetchItems(); // Refresh the items list
  }

  Future<void> updateItem(Item item) async {
    await DatabaseHelper.instance.update(item.toJson(), item.id!);
    await _fetchItems(); // Refresh the items list
  }

  Future<void> deleteItem(int id) async {
    await DatabaseHelper.instance.delete(id);
    state = state.where((item) => item.id != id).toList(); // Remove item from state
  }
}

final itemProvider = StateNotifierProvider<ItemNotifier, List<Item>>((ref) {
  return ItemNotifier();
});