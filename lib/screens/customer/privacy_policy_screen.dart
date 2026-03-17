import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Last Updated: May 15, 2025', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),

            _buildParagraph(
              'GarageGuru Ltd ("us", "we", or "our") operates the GarageGuru mobile application and website (collectively, the "Service"). This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('1. Information Collection and Use'),
            _buildParagraph(
              'We collect several different types of information for various purposes to provide and improve our Service to you.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSubHeading('Types of Data Collected:'),
            _buildParagraph('Personal Data: While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:'),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'Email address',
              'First name and last name',
              'Phone number',
              'Address, State, Province, ZIP/Postal code, City',
              'National ID number',
              'Vehicle registration information',
              'Payment information',
              'Cookies and Usage Data',
            ]),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Usage Data: We may also collect information on how the Service is accessed and used ("Usage Data"). This Usage Data may include information such as your computer\'s Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers and other diagnostic data.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('2. Use of Data'),
            _buildParagraph('GarageGuru Ltd uses the collected data for various purposes:'),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'To provide and maintain our Service',
              'To notify you about changes to our Service',
              'To allow you to participate in interactive features of our Service when you choose to do so',
              'To provide customer support',
              'To gather analysis or valuable information so that we can improve our Service',
              'To monitor the usage of our Service',
              'To detect, prevent and address technical issues',
              'To provide you with news, special offers and general information about other goods, services and events which we offer',
            ]),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('3. Transfer of Data'),
            _buildParagraph(
              'Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ from those of your jurisdiction.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'If you are located outside Rwanda and choose to provide information to us, please note that we transfer the data, including Personal Data, to Rwanda and process it there.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildParagraph(
              'Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('4. Disclosure of Data'),
            _buildSubHeading('Legal Requirements'),
            _buildParagraph(
              'GarageGuru Ltd may disclose your Personal Data in the good faith belief that such action is necessary to:',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'Comply with a legal obligation',
              'Protect and defend the rights or property of GarageGuru Ltd',
              'Prevent or investigate possible wrongdoing in connection with the Service',
              'Protect the personal safety of users of the Service or the public',
              'Protect against legal liability',
            ]),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('5. Security of Data'),
            _buildParagraph(
              'The security of your data is important to us but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('6. Service Providers'),
            _buildParagraph(
              'We may employ third party companies and individuals to facilitate our Service ("Service Providers"), provide the Service on our behalf, perform Service-related services or assist us in analysing how our Service is used. These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('7. Links to Other Sites'),
            _buildParagraph(
              'Our Service may contain links to other sites that are not operated by us. If you click a third party link, you will be directed to that third party\'s site. We strongly advise you to review the Privacy Policy of every site you visit. We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('8. Children\'s Privacy'),
            _buildParagraph(
              'Our Service does not address anyone under the age of 18 ("Children"). We do not knowingly collect personally identifiable information from anyone under the age of 18. If you are a parent or guardian and you are aware that your Child has provided us with Personal Data, please contact us.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('9. Changes to This Privacy Policy'),
            _buildParagraph(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically for any changes.',
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection('10. Contact Us'),
            _buildParagraph('If you have any questions about this Privacy Policy, please contact us:'),
            const SizedBox(height: AppSpacing.sm),
            _buildBulletList([
              'By email: privacy@garageguru.rw',
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

  Widget _buildSubHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
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
                child: Text(item, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.6)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
