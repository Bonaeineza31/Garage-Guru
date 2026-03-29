import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:garage_guru/models/garage_model.dart';

/// OpenStreetMap tile config (free, no API key).
const String kOsmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const String kOsmUserAgent = 'com.example.garage_guru';
const LatLng kDefaultMapCenter = LatLng(-1.9441, 30.0619);

TileLayer buildOsmTileLayer() {
  return TileLayer(
    urlTemplate: kOsmTileUrl,
    userAgentPackageName: kOsmUserAgent,
    maxZoom: 19,
  );
}

/// Pin with garage name above; geographic point is tip of the pin.
Marker garageLabelMarker(GarageModel garage) {
  final name = garage.name.trim().isEmpty ? 'Garage' : garage.name.trim();
  return Marker(
    point: LatLng(garage.latitude, garage.longitude),
    width: 168,
    height: 92,
    alignment: Alignment.bottomCenter,
    rotate: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Material(
            color: Colors.white,
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Icon(Icons.location_on, color: Color(0xFF0EA5E9), size: 36),
      ],
    ),
  );
}

/// Selection pin for “pick on map” flows; optional label under chip.
Marker selectionPinMarker(LatLng point, {String? label}) {
  return Marker(
    point: point,
    width: label == null ? 48 : 160,
    height: label == null ? 48 : 92,
    alignment: Alignment.bottomCenter,
    rotate: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Material(
              color: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        const Icon(Icons.location_on, color: Colors.red, size: 40),
      ],
    ),
  );
}

List<Marker> garagesToMarkers(List<GarageModel> garages) {
  return garages
      .where((g) => g.latitude != 0.0 || g.longitude != 0.0)
      .map(garageLabelMarker)
      .toList();
}

/// Zoom map to show all garages (single pin → fixed zoom).
void fitMapToGarages(MapController mapController, List<GarageModel> garages) {
  final pts = garages
      .where((g) => g.latitude != 0.0 || g.longitude != 0.0)
      .map((g) => LatLng(g.latitude, g.longitude))
      .toList();
  if (pts.isEmpty) return;
  if (pts.length == 1) {
    mapController.move(pts.first, 15);
    return;
  }
  var south = pts.first.latitude;
  var north = pts.first.latitude;
  var west = pts.first.longitude;
  var east = pts.first.longitude;
  for (final p in pts) {
    south = math.min(south, p.latitude);
    north = math.max(north, p.latitude);
    west = math.min(west, p.longitude);
    east = math.max(east, p.longitude);
  }
  const pad = 0.01;
  mapController.fitCamera(
    CameraFit.bounds(
      bounds: LatLngBounds(
        LatLng(south - pad, west - pad),
        LatLng(north + pad, east + pad),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      maxZoom: 17,
    ),
  );
}

/// Zoom +/- (and optional fit-all) overlay for [Stack] on top of [FlutterMap].
class MapControlOverlay extends StatelessWidget {
  const MapControlOverlay({
    super.key,
    required this.mapController,
    this.onFitAll,
    this.minZoom = 3.0,
    this.maxZoom = 19.0,
    this.padding = const EdgeInsets.only(right: 8, top: 8),
  });

  final MapController mapController;
  final VoidCallback? onFitAll;
  final double minZoom;
  final double maxZoom;
  final EdgeInsets padding;

  void _zoomBy(double delta) {
    final cam = mapController.camera;
    final z = (cam.zoom + delta).clamp(minZoom, maxZoom);
    mapController.move(cam.center, z);
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.92);

    return Positioned(
      right: padding.right,
      top: padding.top,
      child: Material(
        color: surface,
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Zoom in',
              icon: const Icon(Icons.add),
              onPressed: () => _zoomBy(1),
            ),
            const Divider(height: 1),
            IconButton(
              tooltip: 'Zoom out',
              icon: const Icon(Icons.remove),
              onPressed: () => _zoomBy(-1),
            ),
            if (onFitAll != null) ...[
              const Divider(height: 1),
              IconButton(
                tooltip: 'Show all pins',
                icon: const Icon(Icons.fit_screen),
                onPressed: onFitAll,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bottom hint chip; tap opens full-screen map when [onTap] is set.
class ExpandMapHint extends StatelessWidget {
  const ExpandMapHint({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 4,
      child: Center(
        child: Material(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_full,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tap to enlarge map',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
