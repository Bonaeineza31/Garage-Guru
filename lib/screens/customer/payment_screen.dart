import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';

class PaymentScreen extends StatefulWidget {
  final GarageModel garage;
  final List<ServiceModel> services;
  final double totalAmount;
  final DateTime scheduledDate;
  final String scheduledTime;

  const PaymentScreen({
    super.key,
    required this.garage,
    required this.services,
    required this.totalAmount,
    required this.scheduledDate,
    required this.scheduledTime,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'card';
  bool _isProcessing = false;
  bool _paymentSuccess = false;

  @override
  Widget build(BuildContext context) {
    if (_paymentSuccess) return _buildSuccessScreen();

    return Scaffold(
      appBar: const GgAppBar(title: 'Payment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Image.network(
                            widget.garage.coverImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.garage_rounded, color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.garage.name, style: AppTextStyles.subtitle),
                            Text(widget.garage.address, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  ...widget.services.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(s.name, style: AppTextStyles.body)),
                        Text(s.formattedPrice, style: AppTextStyles.body),
                      ],
                    ),
                  )),
                  const Divider(height: AppSpacing.xxl),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _formatDate(widget.scheduledDate),
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      const Icon(Icons.schedule_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(widget.scheduledTime, style: AppTextStyles.body),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: AppTextStyles.body),
                      Text('\$${widget.totalAmount.toStringAsFixed(2)}', style: AppTextStyles.body),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Service Fee', style: AppTextStyles.body),
                      Text('\$2.99', style: AppTextStyles.body),
                    ],
                  ),
                  const Divider(height: AppSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.heading3),
                      Text(
                        '\$${(widget.totalAmount + 2.99).toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('Payment Method', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            _buildPaymentOption(
              'card',
              'Credit/Debit Card',
              Icons.credit_card,
              '**** **** **** 4242',
            ),
            _buildPaymentOption(
              'paypal',
              'PayPal',
              Icons.account_balance_wallet,
              'alex@example.com',
            ),
            _buildPaymentOption(
              'cash',
              'Cash on Service',
              Icons.money,
              'Pay at the garage',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppShadows.bottomNav,
        ),
        child: SafeArea(
          child: GgButton(
            label: 'Pay \$${(widget.totalAmount + 2.99).toStringAsFixed(2)}',
            isLoading: _isProcessing,
            useGradient: true,
            onPressed: _handlePayment,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String id, String title, IconData icon, String subtitle) {
    final isSelected = _paymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.04) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitle),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _paymentMethod,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _paymentSuccess = true;
      });
    });
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.successGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Payment Successful!',
                style: AppTextStyles.heading2.copyWith(letterSpacing: -0.3),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your booking has been confirmed.\nYou will receive a confirmation email shortly.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl * 2),
              GgButton(
                label: 'Back to Home',
                useGradient: true,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const CustomerShell()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              GgButton(
                label: 'View Booking',
                isOutlined: true,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const CustomerShell(initialTab: 2)),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
