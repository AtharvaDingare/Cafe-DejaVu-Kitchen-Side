import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemListNotifier extends StateNotifier<List<dynamic>> {
  OrderItemListNotifier() : super([]);
  void addItem(Map<String, dynamic> meal) {
    state = [...state, meal];
  }

  void removeItem(String orderId) {
    List<dynamic> updatedList = [];
    for (int i = 0; i < state.length; i++) {
      if (state[i]["_id"] != orderId) {
        updatedList.add(state[i]);
      }
    }
    state = updatedList;
  }

  void changeState(List<dynamic> newState) {
    state = newState;
  }
}

final orderItemListProvider =
    StateNotifierProvider<OrderItemListNotifier, List<dynamic>>(
  (ref) => OrderItemListNotifier(),
);
