import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';

class CustomerHeader extends StatelessWidget {
  final String? title;
  final bool showSearch;
  final TextEditingController? searchController;
  final Function(String)? onSearch;

  const CustomerHeader({
    super.key,
    this.title,
    this.showSearch = true,
    this.searchController,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
              Text(
                title ?? 'GarageGuru',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              _buildNotificationBadge(context),
            ],
          ),
        ),
        if (showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                boxShadow: Theme.of(context).brightness == Brightness.dark ? [] : AppShadows.card,
              ),
              child: Row(
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationBadge(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF4B5563)),
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
              border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
