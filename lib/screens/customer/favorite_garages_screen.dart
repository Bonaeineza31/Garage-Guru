import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/garage_card.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';

class FavoriteGaragesScreen extends StatelessWidget {
  const FavoriteGaragesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Favorited Garages',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: BlocBuilder<GarageBloc, GarageState>(
        builder: (context, state) {
          final favorites = state.allGarages.where((g) => g.isFavorite).toList();

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your liked garages will appear here',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final garage = favorites[index];
              return GarageCard(
                garage: garage,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GarageDetailScreen(garage: garage),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
