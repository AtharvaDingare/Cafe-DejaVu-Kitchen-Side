import 'package:flutter_riverpod/flutter_riverpod.dart';

class KitchenTypeCountNotifier extends StateNotifier<Map<String, int>> {
  KitchenTypeCountNotifier() : super({});
  void addItem(String kitchenType) {
    Map<String, int> tempo = state;
    if (tempo.containsKey(kitchenType)) {
      tempo[kitchenType] = tempo[kitchenType]! + 1;
    } else {
      tempo[kitchenType] = 1;
    }
    state = tempo;
  }

  void removeItem(String kitchenType) {
    Map<String, int> tempo = state;
    tempo[kitchenType] = tempo[kitchenType]! - 1;
    if (tempo[kitchenType] == 0) {
      tempo.remove(kitchenType);
    }
    state = tempo;
  }

  void changeState(Map<String, int> newState) {
    state = newState;
  }
}

final kitchenTypeCountProvider =
    StateNotifierProvider<KitchenTypeCountNotifier, Map<String, int>>(
  (ref) => KitchenTypeCountNotifier(),
);
