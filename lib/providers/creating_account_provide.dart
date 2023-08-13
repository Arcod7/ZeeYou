import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatingAccountNotifier extends StateNotifier<bool> {
  CreatingAccountNotifier() : super(false);

  void setValue(bool value) {
    state = value;
  }
}

final creatingAccount = StateNotifierProvider<CreatingAccountNotifier, bool>(
    (ref) => CreatingAccountNotifier());
