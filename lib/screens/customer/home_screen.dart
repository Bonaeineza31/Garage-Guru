import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/bloc/garage/garage_bloc.dart';
import 'package:garage_guru/screens/customer/battery_service_screen.dart';
import 'package:garage_guru/screens/customer/emergency_repair_screen.dart';
import 'package:garage_guru/screens/customer/repairs_screen.dart';
import 'package:garage_guru/screens/customer/tire_service_screen.dart';
import 'package:garage_guru/screens/customer/add_vehicle_screen.dart';
import 'package:garage_guru/screens/customer/find_garages_screen.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/request_repair_form_screen.dart';
import 'package:garage_guru/widgets/garage_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 14),
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildMapPreview(),
                const SizedBox(height: 12),
                _buildPrimaryActions(),
                const SizedBox(height: 20),
                _buildQuickServices(),
                const SizedBox(height: 20),
                _buildNearbyGarages(),
                const SizedBox(height: 20),
                _buildUpcomingMaintenance(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: const Text(
            'G',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'GarageGuru',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Color(0xFF111827),
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            Positioned(
              right: 10,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          if (query.trim().isNotEmpty) {
            context.read<GarageBloc>().add(SearchGarages(query.trim()));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FindGaragesScreen(initialQuery: query.trim()),
              ),
            );
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF9CA3AF)),
          hintText: 'Find nearby repair shops',
          hintStyle: TextStyle(
            color: Color(0xFF9CA3AF),
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return BlocBuilder<GarageBloc, GarageState>(
      builder: (context, state) {
        final garages = state is GarageLoaded ? state.allGarages : [];
        final markers = garages.map((g) => Marker(
          markerId: MarkerId(g.id),
          position: LatLng(g.latitude, g.longitude),
          infoWindow: InfoWindow(title: g.name, snippet: g.address),
        )).toSet();

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-1.9441, 30.0619),
                zoom: 13,
              ),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: markers,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrimaryActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            color: const Color(0xFFFF5A3D),
            icon: Icons.warning_amber_rounded,
            label: 'Emergency Repair',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EmergencyRepairScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            color: const Color(0xFF1D9CE5),
            icon: Icons.event_note_rounded,
            label: 'Schedule Repair',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RequestRepairFormScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            color: const Color(0xFF11A85A),
            icon: Icons.shield_outlined,
            label: 'Repair Updates',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RepairsScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Services',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickServiceIcon(
              icon: Icons.bolt_rounded,
              label: 'Oil Change',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RequestRepairFormScreen(
                      initialRepairType: 'Oil Change',
                    ),
                  ),
                );
              },
            ),
            _QuickServiceIcon(
              icon: Icons.tire_repair_rounded,
              label: 'Tire Service',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TireServiceScreen()),
                );
              },
            ),
            _QuickServiceIcon(
              icon: Icons.battery_5_bar_rounded,
              label: 'Battery',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BatteryServiceScreen()),
                );
              },
            ),
            _QuickServiceIcon(
              icon: Icons.car_repair_rounded,
              label: 'Add Vehicle',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyGarages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Nearby Garages',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FindGaragesScreen()),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<GarageBloc, GarageState>(
          builder: (context, state) {
            if (state is GarageLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GarageLoaded) {
              final garages = state.allGarages.take(3).toList();
              if (garages.isEmpty) {
                return const Text(
                  'No nearby garages found.',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7280)),
                );
              }
              return Column(
                children: garages.map((garage) => GarageCard(
                  garage: garage,
                  isCompact: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => GarageDetailScreen(garage: garage)),
                  ),
                )).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingMaintenance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Maintenance',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 23,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5ECFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.calendar_today, size: 18, color: Color(0xFF0284C7)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oil Change Due',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Toyota Camry - RAC 881C',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Due in 2 days or 300km',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RequestRepairFormScreen(
                                initialRepairType: 'Oil Change',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5DB4EF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Schedule Now',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

class _ActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, color: Colors.white, size: 13),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickServiceIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFDFF0FF),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(icon, color: const Color(0xFF2196F3)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
          ),
        ],
      ),
    );
  }
}

