import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zeeyou/models/place.dart';

final currentLocationProvider = StateProvider<PlaceLocation?>((ref) {
  return null;
});
