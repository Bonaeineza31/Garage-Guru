import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Full-screen map with OpenStreetMap tiles — 100% free, no API keys.
/// Compatible with Firebase; uses real garage coordinates and user location.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  int _selectedGarageIndex = 0;
  Position? _userPosition;
  bool _locationLoading = true;
  String? _locationError;
  static const double _defaultZoom = 13;
  static const LatLng _defaultCenter = LatLng(37.7749, -122.4194); // San Francisco

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        setState(() {
          _locationLoading = false;
          _locationError = 'Location permission denied';
        });
        _centerOnGarages();
        return;
      }
    }

    try {
      final pos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userPosition = pos;
          _locationLoading = false;
          _locationError = null;
        });
        _mapController.move(
          LatLng(pos.latitude, pos.longitude),
          _defaultZoom,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationLoading = false;
          _locationError = 'Could not get location';
        });
        _centerOnGarages();
      }
    }
  }

  void _centerOnGarages() {
    if (MockData.garages.isEmpty) return;
    final garage = MockData.garages[_selectedGarageIndex];
    _mapController.move(
      LatLng(garage.latitude, garage.longitude),
      _defaultZoom,
    );
  }

  void _goToMyLocation() {
    if (_userPosition != null) {
      _mapController.move(
        LatLng(_userPosition!.latitude, _userPosition!.longitude),
        _defaultZoom,
      );
    } else {
      _initLocation();
    }
  }

  LatLng get _initialCenter {
    if (_userPosition != null) {
      return LatLng(_userPosition!.latitude, _userPosition!.longitude);
    }
    if (MockData.garages.isNotEmpty) {
      final g = MockData.garages.first;
      return LatLng(g.latitude, g.longitude);
    }
    return _defaultCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _defaultZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (_, __) {},
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.garage_guru',
                maxZoom: 19,
                minZoom: 3,
              ),
              MarkerLayer(
                markers: _buildMarkers(),
              ),
              RichAttributionWidget(
                animationConfig: const ScaleRAWA(),
                showFlutterMapAttribution: false,
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
          _buildSearchBar(),
          _buildMyLocationButton(),
          if (_locationLoading) _buildLoadingOverlay(),
          if (_locationError != null) _buildErrorBanner(),
          _buildGarageCarousel(),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    if (_userPosition != null) {
      markers.add(
        Marker(
          point: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
      );
    }

    for (int i = 0; i < MockData.garages.length; i++) {
      final garage = MockData.garages[i];
      final isSelected = i == _selectedGarageIndex;
      markers.add(
        Marker(
          point: LatLng(garage.latitude, garage.longitude),
          width: 70,
          height: 56,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedGarageIndex = i);
              _mapController.move(
                LatLng(garage.latitude, garage.longitude),
                _defaultZoom,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: AppShadows.elevated,
                  ),
                  child: Text(
                    garage.name.split(' ').first,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Icon(
                  Icons.location_on,
                  color: isSelected ? AppColors.primary : AppColors.accent,
                  size: isSelected ? 28 : 24,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSpacing.md,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: GgSearchBar(
        hint: 'Search this area...',
        onFilterTap: () {},
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      bottom: 180,
      right: AppSpacing.lg,
      child: FloatingActionButton.small(
        heroTag: 'location',
        onPressed: _goToMyLocation,
        backgroundColor: AppColors.surface,
        elevation: 4,
        child: Icon(
          Icons.my_location_rounded,
          color: _userPosition != null ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppShadows.elevated,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text('Getting your location...', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppShadows.elevated,
        ),
        child: Row(
          children: [
            Icon(Icons.location_off, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(_locationError!, style: AppTextStyles.bodySmall),
            ),
            TextButton(
              onPressed: _initLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGarageCarousel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140,
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: MockData.garages.length,
          itemBuilder: (context, index) {
            final garage = MockData.garages[index];
            return GarageMapCard(
              garage: garage,
              onTap: () {
                setState(() => _selectedGarageIndex = index);
                _mapController.move(
                  LatLng(garage.latitude, garage.longitude),
                  _defaultZoom,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GarageDetailScreen(garage: garage),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
