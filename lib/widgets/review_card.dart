import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/models/review_model.dart';
class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: review.customerImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          review.customerImageUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              review.customerName[0].toUpperCase(),
                              style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          review.customerName[0].toUpperCase(),
                          style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: cs.onSurface),
                    ),
                    Text(
                      review.timeAgo,
                      style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.starFilled.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.starFilled,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            review.comment,
            style: AppTextStyles.body.copyWith(color: cs.onSurface),
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Image.network(
                      review.images[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: cs.surfaceContainerHighest,
                        child: Icon(Icons.image, color: cs.onSurfaceVariant),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          if (review.reply != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.reply_rounded, size: 16, color: cs.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Owner\'s Response',
                        style: AppTextStyles.label.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    review.reply!,
                    style: AppTextStyles.bodySmall.copyWith(color: cs.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> distribution;

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    this.distribution = const {5: 200, 4: 80, 3: 40, 2: 15, 1: 7},
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: AppTextStyles.heading1.copyWith(
                fontSize: 50,
                color: cs.onSurface,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                if (index < averageRating.floor()) {
                  return const Icon(Icons.star, color: AppColors.starFilled, size: 20);
                } else if (index < averageRating) {
                  return const Icon(Icons.star_half, color: AppColors.starFilled, size: 20);
                }
                return Icon(Icons.star_border, color: cs.outlineVariant, size: 20);
              }),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$totalReviews reviews',
              style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final star = 5 - index;
              final count = distribution[star] ?? 0;
              final maxCount = distribution.values.fold<int>(0, (a, b) => a > b ? a : b);
              final ratio = maxCount > 0 ? count / maxCount : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '$star',
                      style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.star, color: AppColors.starFilled, size: 12),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          backgroundColor: cs.outlineVariant.withValues(alpha: 0.5),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.starFilled),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$count',
                        style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}