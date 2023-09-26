import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:zeeyou/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:zeeyou/tools/google_api_key.dart';

class WaitBeforePop extends StatelessWidget {
  const WaitBeforePop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/android_foreground.png'),
          const Text('...', style: TextStyle(fontSize: 40)),
        ],
      ),
    ));
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  final _controller = TextEditingController();
  String? _sessionToken;
  List<dynamic> _placeList = [];
  late GoogleMapController _mapController;

  onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = const Uuid().v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void navigateToSearchedPlace(String placeId) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseUrl?place_id=$placeId&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final location =
          json.decode(response.body)['result']['geometry']['location'];
      setState(() => _pickedLocation = LatLng(
            location['lat'],
            location['lng'],
          ));
      _mapController.animateCamera(CameraUpdate.newLatLng(_pickedLocation!));
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  void initState() {
    _controller.addListener(() {
      _onChanged();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final markerPosition = LatLng(
      widget.location.latitude,
      widget.location.longitude,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const WaitBeforePop()));
            await Future.delayed(const Duration(milliseconds: 200));
            if (context.mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          },
        ),
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Seek your location here",
            focusColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Icon(Icons.map),
            suffixIcon: Icon(Icons.cancel),
          ),
          onTapOutside: (pointer) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              setState(() {
                _placeList = [];
              });
            });
          },
          // onSubmitted: (submit) {
          //   print(submit);
          //   print(_pickedLocation!.latitude);

          //   _mapController.animateCamera(
          //       CameraUpdate.newLatLng(_pickedLocation ?? markerPosition));
          // },
        ), // Text(widget.isSelecting ? l10n.chooseLocation : l10n.yourPos),
        actions: [
          if (_pickedLocation != null && widget.isSelecting)
            TextButton.icon(
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WaitBeforePop()));
                await Future.delayed(const Duration(milliseconds: 500));
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(_pickedLocation);
                }
              },
              icon: const Icon(Icons.save),
              label: Text(l10n.save),
            )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            onTap: !widget.isSelecting
                ? null
                : (position) {
                    setState(() {
                      _pickedLocation = position;
                    });
                  },
            initialCameraPosition: CameraPosition(
              target: markerPosition,
              zoom: 16,
            ),
            markers: (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('id1'),
                      position: _pickedLocation ?? markerPosition,
                    ),
                  },
          ),
          if (_placeList.isNotEmpty)
            Positioned(
              child: Container(
                color: Colors.white.withOpacity(0.8),
                height: 200,
                child: ListView.builder(
                  itemCount: _placeList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_placeList[index]['description']),
                      onTap: () {
                        _controller.text = _placeList[index]['description'];

                        navigateToSearchedPlace(_placeList[index]['place_id']);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
