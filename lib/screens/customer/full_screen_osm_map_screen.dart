import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:garage_guru/models/garage_model.dart';
import 'package:garage_guru/widgets/garage_osm_map.dart';

/// Full-screen OpenStreetMap: browse garages with labels, or pick a single location.
class FullScreenOsmMapScreen extends StatefulWidget {
  const FullScreenOsmMapScreen({
    super.key,
    this.garages = const [],
    this.pickLocation = false,
    this.initialPick,
  });

  final List<GarageModel> garages;
  final bool pickLocation;
  final LatLng? initialPick;

  static Future<LatLng?> openPickLocation(
    BuildContext context, {
    LatLng? initialPick,
  }) {
    return Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenOsmMapScreen(
          pickLocation: true,
          initialPick: initialPick,
        ),
      ),
    );
  }

  static Future<void> openGarages(
    BuildContext context, {
    required List<GarageModel> garages,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenOsmMapScreen(garages: garages),
      ),
    );
  }

  @override
  State<FullScreenOsmMapScreen> createState() => _FullScreenOsmMapScreenState();
}

class _FullScreenOsmMapScreenState extends State<FullScreenOsmMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.initialPick;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.pickLocation && widget.garages.isNotEmpty) {
        _fitGarages(widget.garages);
      }
    });
  }

  void _fitGarages(List<GarageModel> garages) {
    fitMapToGarages(_mapController, garages);
  }

  @override
  Widget build(BuildContext context) {
    final garagesWithCoords = widget.garages
        .where((g) => g.latitude != 0.0 || g.longitude != 0.0)
        .toList();
    final markers = <Marker>[
      ...garagesWithCoords.map(garageLabelMarker),
      if (widget.pickLocation && _picked != null)
        selectionPinMarker(_picked!, label: 'Selected'),
    ];

    final initial = widget.pickLocation
        ? (_picked ?? kDefaultMapCenter)
        : (garagesWithCoords.isNotEmpty
            ? LatLng(
                garagesWithCoords.first.latitude,
                garagesWithCoords.first.longitude,
              )
            : kDefaultMapCenter);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pickLocation ? 'Choose location' : 'Map'),
        actions: [
          if (widget.pickLocation)
            IconButton(
              tooltip: 'Use this location',
              icon: const Icon(Icons.check),
              onPressed: _picked == null
                  ? null
                  : () => Navigator.pop(context, _picked),
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initial,
              initialZoom: widget.pickLocation ? 14 : 13,
              minZoom: 3,
              maxZoom: 19,
              interactionOptions:
                  const InteractionOptions(flags: InteractiveFlag.all),
              onTap: widget.pickLocation
                  ? (_, latLng) {
                      setState(() => _picked = latLng);
                      _mapController.move(latLng, _mapController.camera.zoom);
                    }
                  : null,
            ),
            children: [
              buildOsmTileLayer(),
              MarkerLayer(markers: markers),
            ],
          ),
          MapControlOverlay(
            mapController: _mapController,
            onFitAll: (!widget.pickLocation && garagesWithCoords.isNotEmpty)
                ? () => _fitGarages(widget.garages)
                : null,
            padding: const EdgeInsets.only(right: 12, top: 12),
          ),
        ],
      ),
    );
  }
}
