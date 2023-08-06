import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/screens/map.dart';

import 'package:http/http.dart' as http;

class EventDetailsLocation extends StatefulWidget {
  const EventDetailsLocation(
      {required this.color,
      required this.lightColor,
      required this.onLocationPicked,
      required this.location,
      this.creatingEvent = false,
      super.key});

  final Color color;
  final Color lightColor;
  final void Function(PlaceLocation) onLocationPicked;
  final PlaceLocation? location;
  final bool creatingEvent;

  @override
  State<EventDetailsLocation> createState() => _EventDetailsLocationState();
}

class _EventDetailsLocationState extends State<EventDetailsLocation> {
  var _isGettingLocation = false;

  Future<void> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyAD0jDfG3ZmI-aFtjVOpZ6vXradG5tvLm8');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      // _pickedLocation = PlaceLocation(
      //   latitude: lat,
      //   longitude: lng,
      //   address: address,
      // );
      _isGettingLocation = false;
    });
    widget.onLocationPicked(PlaceLocation(
      latitude: lat,
      longitude: lng,
      address: address,
    ));
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    await _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
            builder: (ctx) => MapScreen(
                location: widget.location ??
                    const PlaceLocation(
                        latitude: 1.0, longitude: 1.0, address: ''))));

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  void initState() {
    super.initState();
    if (widget.creatingEvent) {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _selectOnMap,
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
      title: _isGettingLocation
          ? const CircularProgressIndicator.adaptive()
          : Text(
              widget.location != null
                  ? widget.location!.address
                  // widget.event.location != null
                  //     ? widget.event.location!.address
                  : "Pas d'endroit prévu pour le moment",
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
