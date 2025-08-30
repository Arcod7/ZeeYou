import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:zeeyou/env/env.dart';
import 'package:zeeyou/models/color_shade.dart';
import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/providers/current_location_provider.dart';
import 'package:zeeyou/screens/map.dart';
import 'package:zeeyou/l10n/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:zeeyou/widgets/event_details/external_link.dart';

class LinkLocation extends ConsumerStatefulWidget {
  const LinkLocation({
    super.key,
    required this.colors,
    required this.onLocationPicked,
    required this.location,
    this.creatingEvent = false,
  });

  final ColorShade colors;
  final void Function(PlaceLocation) onLocationPicked;
  final PlaceLocation? location;
  final bool creatingEvent;

  @override
  ConsumerState<LinkLocation> createState() => _LinkLocationState();
}

class _LinkLocationState extends ConsumerState<LinkLocation> {
  var _isGettingLocation = false;

  Future<PlaceLocation> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Env.mapsApiKey}');

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
      location.requestPermission();
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      if (Platform.isIOS) {
        permissionGranted = await location.requestPermission();
      } else {
        permissionGranted = await location.requestPermission();
      }
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    print('Getting location');
    try {
      locationData = await location.getLocation();
    } catch (e) {
      print(e);
      return null;
    }
    print('Got location');
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
    return ExternalLink(
      text: _isGettingLocation
          ? l10n.gettingLocation
          : widget.location != null
              ? widget.location!.address
              : l10n.noLocationForNow,
      icon: Icons.location_on_outlined,
      colors: widget.colors,
      onTap: () async {
        PlaceLocation? actualLocation;
        final currentLocation = ref.watch(currentLocationProvider);
        // if (widget.creatingEvent && currentLocation == null) {
        //   actualLocation = await _getCurrentLocation();
        //   if (actualLocation != null) {
        //     ref.watch(currentLocationProvider.notifier).state = actualLocation;
        //     // widget.onCurrentLocationGet(actualLocation);
        //   }
        // }
        _selectOnMap(actualLocation ?? currentLocation);
      },
      isGetting: _isGettingLocation,
      isNone: widget.location == null,
    );
  }
}
