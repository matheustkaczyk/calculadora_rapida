import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item_provider.dart';

final totalSumProvider = StateProvider<double>((ref) {
  final items = ref.watch(itemProvider);
  double totalSum = 0.0;
  for (var item in items) {
    if (item.quantity > 0) {
      totalSum += item.price * item.quantity;
    }
  }
  return totalSum;
});