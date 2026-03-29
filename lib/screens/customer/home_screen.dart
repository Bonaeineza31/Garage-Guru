import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/customer_header.dart';
import 'package:garage_guru/screens/customer/find_garages_screen.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
import 'package:garage_guru/screens/customer/emergency_repair_screen.dart';
import 'package:garage_guru/screens/customer/request_repair_form_screen.dart';
import 'package:garage_guru/screens/customer/battery_service_screen.dart';
import 'package:garage_guru/screens/customer/tire_service_screen.dart';
import 'package:garage_guru/screens/customer/oil_change_screen.dart';
import 'package:garage_guru/screens/customer/add_vehicle_screen.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';
import 'package:garage_guru/screens/owner/add_garage_screen.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  MapLibreMapController? _mapController;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerHeader(),
              _buildMapPreview(),
              _buildActionButtons(),
              _buildQuickServices(),
              _buildNearbyGarages(),
              _buildUpcomingMaintenance(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildMapPreview() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              MapLibreMap(
                styleString: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12?access_token=pk.eyJ1Ijoic2Fta3dpemVyYSIsImEiOiJjbWw2dThxcHUwMW85M2ZzNml2cW16aGs1In0.eqdDYMtaD4ZQ35VVYGs01g',
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-1.9441, 30.0619),
                  zoom: 13,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onStyleLoadedCallback: () async {
                  final snapshot = await FirebaseFirestore.instance.collection('garages').get();
                  for (var doc in snapshot.docs) {
                    final data = doc.data();
                    final lat = num.tryParse(data['latitude']?.toString() ?? '0')?.toDouble() ?? 0.0;
                    final lng = num.tryParse(data['longitude']?.toString() ?? '0')?.toDouble() ?? 0.0;
                    if (lat != 0.0 && lng != 0.0 && _mapController != null) {
                      await _mapController!.addSymbol(SymbolOptions(
                        geometry: LatLng(lat, lng),
                        iconImage: 'mapbox-marker-icon-blue',
                        textField: data['name'] ?? '',
                        textOffset: const Offset(0, 1.5),
                        textSize: 11,
                      ));
                    }
                  }
                },
                myLocationEnabled: true,
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                compassEnabled: false,
              ),
              Positioned(
                bottom: 12,
                right: 60,
                child: FloatingActionButton.small(
                  heroTag: 'add_garage_fab',
                  backgroundColor: const Color(0xFF0EA5E9),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddGarageScreen()),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _actionBtn(
            'Emergency Repair',
            const Color(0xFFF05138),
            Icons.warning_amber_rounded,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyRepairScreen())),
          ),
          const SizedBox(width: 8),
          _actionBtn(
            'Schedule Repair',
            const Color(0xFF038DDB),
            Icons.calendar_today_rounded,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestRepairFormScreen())),
          ),
          const SizedBox(width: 8),
          _actionBtn(
            'Repair Updates',
            const Color(0xFF19B25A),
            Icons.shield_outlined,
            () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerShell(initialTab: 2))),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color color, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServices() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _serviceItem('Oil Change', Icons.oil_barrel_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => OilChangeScreen()));
              }),
              _serviceItem('Tire Service', Icons.settings_input_component_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => TireServiceScreen()));
              }),
              _serviceItem('Battery', Icons.battery_charging_full_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => BatteryServiceScreen()));
              }),
              _serviceItem('Add Vehicle', Icons.add_circle_outline_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddVehicleScreen()));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, 
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
            ),
            child: Icon(icon, color: const Color(0xFF0EA5E9), size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildNearbyGarages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nearby Garages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FindGaragesScreen())),
                child: const Text('View All', style: TextStyle(color: Color(0xFF038DDB), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        BlocBuilder<GarageBloc, GarageState>(
          builder: (context, state) {
            if (state.status == GarageStatus.loading) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
            if (state.status == GarageStatus.failure) return const Padding(padding: EdgeInsets.all(16), child: Text('Failed to load garages'));
            
            final garages = state.allGarages.take(3).toList();

            if (garages.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('No garages found nearby'));

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: garages.length,
              itemBuilder: (context, index) => _buildGarageTile(garages[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGarageTile(GarageModel garage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(garage.coverImageUrl, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(garage.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Text('${garage.distanceKm}Km', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star_rounded,
                              color: starIndex < garage.rating.floor() ? Colors.orange : const Color(0xFFD1D5DB),
                              size: 14,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          garage.rating.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              garage.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded, 
              color: garage.isFavorite ? Colors.red : const Color(0xFFD1D5DB)
            ),
            onPressed: () {
              context.read<GarageBloc>().add(ToggleFavorite(garage));
            },
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GarageDetailScreen(garage: garage))),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0F2FE),
              foregroundColor: const Color(0xFF0369A1),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMaintenance() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Maintenance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
              boxShadow: Theme.of(context).brightness == Brightness.dark ? [] : AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
                  child: Icon(Icons.calendar_today_rounded, color: Theme.of(context).colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Oil Change Due', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text('Toyota Camry • RAC 881C', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
                      Text('Due in 2 days or 300km', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OilChangeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0F2FE),
                          foregroundColor: const Color(0xFF0369A1),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Schedule Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
