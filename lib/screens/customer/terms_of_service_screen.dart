import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of Service', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Last Updated: May 15, 2025', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),

            _buildParagraph(
              'Welcome to GarageGuru. These Terms of Service ("Terms") govern your use of the GarageGuru mobile application and website (collectively, the "Service") operated by GarageGuru Ltd ("us", "we", or "our"). By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms, you may not access the Service.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('1. Use of Service'),
            _buildParagraph(
              'GarageGuru provides a platform for vehicle owners in Rwanda to track repairs, access financing, and manage vehicle insurance. By using our Service, you represent that you are at least 18 years of age and are legally able to enter into binding contracts.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('2. Account Registration'),
            _buildParagraph(
              'When you create an account with us, you must provide accurate, complete, and current information. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password. You agree not to disclose your password to any third party.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('3. Loan Terms and Conditions'),
            _buildSubSection('3.1 Eligibility'),
            _buildParagraph(
              'To be eligible for a loan through GarageGuru you must be a Rwandan resident, at least 18 years old, with a valid ID, proof of income, and a registered vehicle on our platform.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSubSection('3.2 Loan Application'),
            _buildParagraph(
              'Loan applications are subject to credit assessment and approval. GarageGuru reserves the right to approve, decline, or modify any loan application at its discretion. Approved loans are disbursed directly to registered garages on our platform.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSubSection('3.3 Repayment'),
            _buildParagraph(
              'You agree to repay any approved loan amount plus applicable interest and fees as specified in your loan agreement. Late payments may attract penalties as provided in your loan agreement.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSubSection('3.4 Interest Rates'),
            _buildParagraph(
              'Interest rates on GarageGuru loans vary based on loan amount, duration, and your credit profile. All applicable rates will be clearly disclosed before you accept any loan offer.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('4. Insurance Services'),
            _buildSubSection('4.1 Insurance Providers'),
            _buildParagraph(
              'GarageGuru partners with licensed insurance providers in Rwanda. We act as an intermediary only and are not directly responsible for any insurance claims or disputes between you and the insurance provider.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSubSection('4.2 Policy Management'),
            _buildParagraph(
              'You are responsible for providing accurate vehicle and personal information when applying for insurance. Any misrepresentation may result in policy cancellation or claim denial.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('5. Garage Services'),
            _buildParagraph(
              'GarageGuru connects vehicle owners with registered garages. We do not directly provide vehicle repair services. Any service agreement is between you and the garage. GarageGuru is not liable for the quality, safety, legality, or any other aspect of the services provided by garages.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('6. Payments'),
            _buildParagraph(
              'All payments processed through GarageGuru are handled by secure third-party payment processors. By making a payment, you agree to the terms of the payment processor. GarageGuru does not store your full payment card details.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('7. Intellectual Property'),
            _buildParagraph(
              'The Service and its original content, features and functionality are and will remain the exclusive property of GarageGuru Ltd and its licensors. Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of GarageGuru Ltd.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('8. Limitation of Liability'),
            _buildParagraph(
              'In no event shall GarageGuru Ltd, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of (or inability to access or use) the Service.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('9. Governing Law'),
            _buildParagraph(
              'These Terms shall be governed and construed in accordance with the laws of Rwanda, without regard to its conflict of law provisions. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts located in Kigali, Rwanda.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('10. Changes to Terms'),
            _buildParagraph(
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('11. Termination'),
            _buildParagraph(
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms. Upon termination, your right to use the Service will immediately cease.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('12. Contact Us'),
            _buildParagraph('If you have any questions about these Terms, please contact us:'),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'By email: legal@garageguru.rw',
              'By phone: +250 788 000 000',
              'By mail: KG 11 Ave, Kigali, Rwanda',
            ]),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSubSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.7),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
