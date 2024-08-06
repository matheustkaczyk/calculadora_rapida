import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../class/item.dart';
import '../state/item_provider.dart';

class ItemModal {
  static void showModal(BuildContext context, WidgetRef ref, {Item? item}) {
    final TextEditingController nameController = TextEditingController(text: item?.name ?? '');
    final TextEditingController priceController = TextEditingController(text: item?.price.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final String name = nameController.text;
                      final int price = int.parse(priceController.text);
                      if (item == null) {
                        final newItem = Item(name: name, price: price);
                        final notifier = ref.read(itemProvider.notifier);
                        await notifier.addItem(newItem);
                      } else {
                        final updatedItem = item.copyWith(name: name, price: price);
                        final notifier = ref.read(itemProvider.notifier);
                        await notifier.updateItem(updatedItem);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Salvar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}