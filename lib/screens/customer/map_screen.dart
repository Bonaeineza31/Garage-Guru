import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedGarageIndex = 0;
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('garages').snapshots(),
        builder: (context, snapshot) {
          final garages = snapshot.data?.docs
                  .map((doc) => GarageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                  .toList() ??
              [];

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194),
                  zoom: 12,
                ),
                markers: _buildGoogleMarkers(garages),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) => _mapController = controller,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + AppSpacing.md,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: GgSearchBar(
              hint: 'Search this area...',
              onFilterTap: () {},
            ),
          ),
          Positioned(
            bottom: 180,
            right: AppSpacing.lg,
            child: FloatingActionButton.small(
              heroTag: 'location',
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    const LatLng(37.7749, -122.4194),
                    12.0,
                  ),
                );
              },
              backgroundColor: AppColors.surface,
              elevation: 4,
              child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: garages.length,
                itemBuilder: (context, index) {
                  return GarageMapCard(
                    garage: garages[index],
                    onTap: () {
                      setState(() => _selectedGarageIndex = index);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GarageDetailScreen(
                            garage: garages[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
      },
      ),
    );
  }

  Set<Marker> _buildGoogleMarkers(List<GarageModel> garages) {
    return garages.asMap().entries.map((entry) {
      final index = entry.key;
      final garage = entry.value;
      
      return Marker(
        markerId: MarkerId(garage.id),
        position: LatLng(garage.latitude, garage.longitude),
        infoWindow: InfoWindow(
          title: garage.name,
          snippet: garage.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          index == _selectedGarageIndex 
              ? BitmapDescriptor.hueBlue 
              : BitmapDescriptor.hueRed,
        ),
        onTap: () {
          setState(() => _selectedGarageIndex = index);
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(LatLng(garage.latitude, garage.longitude)),
          );
        },
      );
    }).toSet();
  }
}