import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/screens/customer/find_garages_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
import 'package:garage_guru/screens/customer/emergency_repair_screen.dart';
import 'package:garage_guru/screens/customer/request_repair_form_screen.dart';
import 'package:garage_guru/screens/customer/repairs_screen.dart';
import 'package:garage_guru/screens/customer/battery_service_screen.dart';
import 'package:garage_guru/screens/customer/tire_service_screen.dart';
import 'package:garage_guru/screens/customer/oil_change_screen.dart';
import 'package:garage_guru/screens/customer/add_vehicle_screen.dart';
import 'package:garage_guru/screens/owner/add_garage_screen.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';
import 'package:garage_guru/blocs/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildSearchBar(),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.garage_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          const Text(
            'GarageGuru',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF4B5563)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF9CA3AF), size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find nearby repair shops',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
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
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('garages').snapshots(),
            builder: (context, snapshot) {
              Set<Marker> markers = {};
              LatLng initialPosition = const LatLng(-1.9441, 30.0619); // Kigali Default

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final lat = (data['latitude'] ?? 0.0).toDouble();
                  final lng = (data['longitude'] ?? 0.0).toDouble();
                  final name = data['name'] ?? 'Garage';

                  if (lat != 0.0 && lng != 0.0) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(doc.id),
                        position: LatLng(lat, lng),
                        infoWindow: InfoWindow(title: name),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                      ),
                    );
                  }
                }
              }

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 13,
                    ),
                    markers: markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                    // disable fullscreen control so it doesn't overlap the FAB
                    liteModeEnabled: false,
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
              );
            },
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
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyRepairScreen())),
          ),
          const SizedBox(width: 8),
          _actionBtn(
            'Schedule Repair',
            const Color(0xFF038DDB),
            Icons.calendar_today_rounded,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestRepairFormScreen())),
          ),
          const SizedBox(width: 8),
          _actionBtn(
            'Repair Updates',
            const Color(0xFF19B25A),
            Icons.shield_outlined,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RepairsScreen())),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OilChangeScreen()));
              }),
              _serviceItem('Tire Service', Icons.settings_input_component_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TireServiceScreen()));
              }),
              _serviceItem('Battery', Icons.battery_charging_full_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BatteryServiceScreen()));
              }),
              _serviceItem('Add Vehicle', Icons.add_circle_outline_rounded, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddVehicleScreen()));
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
            decoration: const BoxDecoration(color: Color(0xFFE0F2FE), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF0EA5E9), size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FindGaragesScreen())),
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
          Icon(garage.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded, color: garage.isFavorite ? Colors.red : const Color(0xFFD1D5DB)),
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
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0F2FE)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Color(0xFFE0F2FE), shape: BoxShape.circle),
                  child: const Icon(Icons.calendar_today_rounded, color: Color(0xFF0EA5E9), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Oil Change Due', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text('Toyota Camry • RAC 881C', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      const Text('Due in 2 days or 300km', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
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
