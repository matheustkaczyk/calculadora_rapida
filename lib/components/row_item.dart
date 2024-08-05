import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../class/item.dart';
import '../state/item_provider.dart';
import 'item_modal.dart';

class RowItem extends StatelessWidget {
  final Item item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const RowItem({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
          onLongPress: () {
            ItemModal.showModal(context, ref, item: item);
          },
          child: Dismissible(
            key: Key(item.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await ref.read(itemProvider.notifier).deleteItem(item.id!);
              // Optionally, you can show a snackbar or update the state here
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'R\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: onAdd,
                        ),
                        Text('$quantity', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: onRemove,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}