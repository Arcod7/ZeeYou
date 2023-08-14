import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/providers/current_location_provider.dart';
import 'package:zeeyou/screens/map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart' as http;

class EventDetailsLocation extends ConsumerStatefulWidget {
  const EventDetailsLocation({
    super.key,
    required this.color,
    required this.lightColor,
    required this.onLocationPicked,
    required this.location,
    this.creatingEvent = false,
  });

  final Color color;
  final Color lightColor;
  final void Function(PlaceLocation) onLocationPicked;
  final PlaceLocation? location;
  final bool creatingEvent;

  @override
  ConsumerState<EventDetailsLocation> createState() =>
      _EventDetailsLocationState();
}

class _EventDetailsLocationState extends ConsumerState<EventDetailsLocation> {
  var _isGettingLocation = false;

  Future<PlaceLocation> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyAD0jDfG3ZmI-aFtjVOpZ6vXradG5tvLm8');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    final placeLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
      address: address,
    );

    setState(() {
      // _pickedLocation = PlaceLocation(
      //   latitude: lat,
      //   longitude: lng,
      //   address: address,
      // );
      _isGettingLocation = false;
    });
    widget.onLocationPicked(placeLocation);
    return placeLocation;
  }

  Future<PlaceLocation?> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return null;
    }

    final placeLocation = await _savePlace(lat, lng);
    return placeLocation;
  }

  void _selectOnMap(PlaceLocation? startLocation) async {
    final pickedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (ctx) => MapScreen(
        location: startLocation ??
            const PlaceLocation(
              latitude: 46.068613,
              longitude: 6.568107,
              address: '',
            ),
      ),
    ));

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      onTap: () async {
        PlaceLocation? actualLocation;
        final currentLocation = ref.watch(currentLocationProvider);
        if (widget.creatingEvent && currentLocation == null) {
          actualLocation = await _getCurrentLocation();
          if (actualLocation != null) {
            ref.watch(currentLocationProvider.notifier).state = actualLocation;
            // widget.onCurrentLocationGet(actualLocation);
          }
        }
        _selectOnMap(actualLocation ?? currentLocation);
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.lightColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.location_on_outlined,
          color: widget.color,
          size: 23,
        ),
      ),
      title: Text(
        _isGettingLocation ? l10n.gettingLocation :
        widget.location != null
            ? widget.location!.address
            // widget.event.location != null
            //     ? widget.event.location!.address
            : l10n.noLocationForNow,
        style: TextStyle(
          color: widget.color,
        ),
      ),
      trailing: _isGettingLocation
          ? const CircularProgressIndicator.adaptive()
          : null,
    );
  }
}
