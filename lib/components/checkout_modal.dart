import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/total_sum_provider.dart';

class CheckoutModal {
  static void showModal(BuildContext context, WidgetRef ref) {
    final TextEditingController paidValueController = TextEditingController();
    final totalSum = ref.read(totalSumProvider);
    double change = 0.0;

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
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Checkout",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total: R\$ ${totalSum.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: paidValueController,
                        decoration: const InputDecoration(
                          labelText: 'Valor pago',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final paidAmount = double.tryParse(value) ?? 0.0;
                          change = paidAmount - totalSum;
                        },
                      ),
                      const SizedBox(height: 20),
                      Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'Troco: R\$ ${change.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
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
            ),
          );
      },
    );
  }
}