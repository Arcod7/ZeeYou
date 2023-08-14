import 'package:zeeyou/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(widget.isSelecting ? l10n.chooseLocation : l10n.yourPos),
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
      body: GoogleMap(
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
    );
  }
}
