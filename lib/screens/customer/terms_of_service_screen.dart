import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';

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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Terms of Service',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of Service', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Last Updated: May 15, 2025', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: AppSpacing.lg),
            _p('Welcome to GarageGuru. These Terms of Service ("Terms") govern your use of the GarageGuru mobile application and website (collectively, the "Service") operated by GarageGuru Ltd ("us", "we", or "our"). By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms, you may not access the Service.'),
            SizedBox(height: AppSpacing.lg),
            _h('1. Use of Service'),
            _p('GarageGuru provides a platform for vehicle owners in Rwanda to track repairs, access financing, and manage vehicle insurance. By using our Service, you represent that you are at least 18 years of age and are legally able to enter into binding contracts.'),
            SizedBox(height: AppSpacing.lg),
            _h('2. Account Registration'),
            _p('When you create an account with us, you must provide accurate, complete, and current information. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.'),
            SizedBox(height: AppSpacing.sm),
            _p('You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password. You agree not to disclose your password to any third party.'),
            SizedBox(height: AppSpacing.lg),
            _h('3. Loan Terms and Conditions'),
            _sub('3.1 Eligibility'),
            _p('To be eligible for a loan through GarageGuru you must be a Rwandan resident, at least 18 years old, with a valid ID, proof of income, and a registered vehicle on our platform.'),
            SizedBox(height: AppSpacing.sm),
            _sub('3.2 Loan Application'),
            _p('Loan applications are subject to credit assessment and approval. GarageGuru reserves the right to approve, decline, or modify any loan application at its discretion. Approved loans are disbursed directly to registered garages on our platform.'),
            SizedBox(height: AppSpacing.sm),
            _sub('3.3 Repayment'),
            _p('You agree to repay any approved loan amount plus applicable interest and fees as specified in your loan agreement. Late payments may attract penalties as provided in your loan agreement.'),
            SizedBox(height: AppSpacing.sm),
            _sub('3.4 Interest Rates'),
            _p('Interest rates on GarageGuru loans vary based on loan amount, duration, and your credit profile. All applicable rates will be clearly disclosed before you accept any loan offer.'),
            SizedBox(height: AppSpacing.lg),
            _h('4. Insurance Services'),
            _sub('4.1 Insurance Providers'),
            _p('GarageGuru partners with licensed insurance providers in Rwanda. We act as an intermediary only and are not directly responsible for any insurance claims or disputes between you and the insurance provider.'),
            SizedBox(height: AppSpacing.sm),
            _sub('4.2 Policy Management'),
            _p('You are responsible for providing accurate vehicle and personal information when applying for insurance. Any misrepresentation may result in policy cancellation or claim denial.'),
            SizedBox(height: AppSpacing.lg),
            _h('5. Garage Services'),
            _p('GarageGuru connects vehicle owners with registered garages. We do not directly provide vehicle repair services. Any service agreement is between you and the garage. GarageGuru is not liable for the quality, safety, legality, or any other aspect of the services provided by garages.'),
            SizedBox(height: AppSpacing.lg),
            _h('6. Payments'),
            _p('All payments processed through GarageGuru are handled by secure third-party payment processors. By making a payment, you agree to the terms of the payment processor. GarageGuru does not store your full payment card details.'),
            SizedBox(height: AppSpacing.lg),
            _h('7. Intellectual Property'),
            _p('The Service and its original content, features and functionality are and will remain the exclusive property of GarageGuru Ltd and its licensors. Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of GarageGuru Ltd.'),
            SizedBox(height: AppSpacing.lg),
            _h('8. Limitation of Liability'),
            _p('In no event shall GarageGuru Ltd, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of the Service.'),
            SizedBox(height: AppSpacing.lg),
            _h('9. Governing Law'),
            _p('These Terms shall be governed and construed in accordance with the laws of Rwanda, without regard to its conflict of law provisions. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts located in Kigali, Rwanda.'),
            SizedBox(height: AppSpacing.lg),
            _h('10. Changes to Terms'),
            _p('We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect.'),
            SizedBox(height: AppSpacing.lg),
            _h('11. Termination'),
            _p('We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms. Upon termination, your right to use the Service will immediately cease.'),
            SizedBox(height: AppSpacing.lg),
            _h('12. Contact Us'),
            _p('If you have any questions about these Terms, please contact us:'),
            SizedBox(height: AppSpacing.sm),
            _bullets(['By email: legal@garageguru.rw', 'By phone: +250 788 000 000', 'By mail: KG 11 Ave, Kigali, Rwanda']),
            SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _h(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }

  Widget _sub(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _p(String text) {
    return Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.7));
  }

  Widget _bullets(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 4, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Expanded(child: Text(item, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.6))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
