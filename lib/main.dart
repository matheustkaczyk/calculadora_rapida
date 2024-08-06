import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './state/total_sum_provider.dart';
import './components/item_modal.dart';
import './state/item_provider.dart';
import './components/row_item.dart';
import 'components/checkout_modal.dart';

void main() {
  runApp(
      const ProviderScope(
        child: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer(
          builder: (context, ref, child) {
            final totalSum = ref.watch(totalSumProvider);
            final items = ref.watch(itemProvider);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Calculadora'),
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Total: R\$ ${totalSum.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return RowItem(
                            item: item,
                            quantity: items[index].quantity,
                            onAdd: () {
                              setState(() {
                                items[index].quantity++;
                                ref.refresh(totalSumProvider);
                              });
                            },
                            onRemove: () {
                              setState(() {
                                if (items[index].quantity > 0) {
                                  items[index].quantity--;
                                  ref.refresh(totalSumProvider);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        for (var item in items) {
                          item.quantity = 0;
                        }
                        ref.refresh(totalSumProvider);
                      });
                    },
                    tooltip: 'Reset Quantities',
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      ItemModal.showModal(context, ref);
                    },
                    tooltip: 'Add Item',
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: FloatingActionButton(
                      onPressed: () {
                        CheckoutModal.showModal(context, ref);
                      },
                      tooltip: 'Checkout',
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.shopping_cart, size: 40),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}