import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
import 'package:garage_guru/screens/garage/add_garage_screen.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedGarageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return Stack(
            children: [
              Container(
                color: const Color(0xFFF0F4F8),
                child: CustomPaint(
                  size: mapSize,
                  painter: _MapPlaceholderPainter(),
                ),
              ),
              ..._buildMarkers(mapSize),
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
                  onPressed: () {},
                  backgroundColor: AppColors.surface,
                  elevation: 4,
                  child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
                ),
              ),
              Positioned(
                // Place above the bottom horizontal garage list.
                bottom: 190,
                right: AppSpacing.lg,
                child: FloatingActionButton.small(
                  heroTag: 'addGarage',
                  onPressed: () async {
                    final added = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => const AddGarageScreen(),
                      ),
                    );
                    if (!mounted) return;
                    if (added == true) setState(() {});
                  },
                  backgroundColor: AppColors.surface,
                  elevation: 4,
                  child: const Icon(Icons.add_location_alt_rounded, color: AppColors.primary),
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
                    itemCount: MockData.garages.length,
                    itemBuilder: (context, index) {
                      return GarageMapCard(
                        garage: MockData.garages[index],
                        onTap: () {
                          setState(() => _selectedGarageIndex = index);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GarageDetailScreen(
                                garage: MockData.garages[index],
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

  List<Widget> _buildMarkers(Size mapSize) {
    final garages = MockData.garages;
    if (garages.isEmpty) return const [];

    final minLat = garages.map((g) => g.latitude).reduce((a, b) => a < b ? a : b);
    final maxLat = garages.map((g) => g.latitude).reduce((a, b) => a > b ? a : b);
    final minLon = garages.map((g) => g.longitude).reduce((a, b) => a < b ? a : b);
    final maxLon = garages.map((g) => g.longitude).reduce((a, b) => a > b ? a : b);

    final latRange = (maxLat - minLat);
    final lonRange = (maxLon - minLon);

    const markerWidthPx = 40.0; // Approx width used for clamping.
    const markerHeightPx = 80.0; // Approx height used for clamping.
    const leftOffset = 20.0;
    const topOffset = 40.0;

    double xForGarage(GarageModel g) {
      final t = lonRange == 0 ? 0.5 : (g.longitude - minLon) / lonRange;
      final x = t * mapSize.width;
      return x.clamp(0.0, mapSize.width);
    }

    double yForGarage(GarageModel g) {
      final t = latRange == 0 ? 0.5 : (maxLat - g.latitude) / latRange;
      final y = t * mapSize.height;
      return y.clamp(0.0, mapSize.height);
    }

    return List.generate(garages.length, (index) {
      final garage = garages[index];
      final x = xForGarage(garage);
      final y = yForGarage(garage);
      final isSelected = index == _selectedGarageIndex;

      return Positioned(
        left: (x - leftOffset).clamp(-markerWidthPx, mapSize.width - markerWidthPx),
        top: (y - topOffset).clamp(-markerHeightPx, mapSize.height - markerHeightPx),
        child: GestureDetector(
          onTap: () => setState(() => _selectedGarageIndex = index),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: AppShadows.elevated,
                ),
                child: Text(
                  garage.name.split(' ').first,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.location_on,
                color: isSelected ? AppColors.primary : AppColors.accent,
                size: isSelected ? 36 : 28,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    paint.color = const Color(0xFFD0D8E0);
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    paint.color = const Color(0xFFC0C8D0);
    paint.strokeWidth = 3;
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}