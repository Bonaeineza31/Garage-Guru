import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';

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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Last Updated: May 15, 2025', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: AppSpacing.lg),
            _p('GarageGuru Ltd ("us", "we", or "our") operates the GarageGuru mobile application and website (collectively, the "Service"). This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.'),
            SizedBox(height: AppSpacing.lg),
            _h('1. Information Collection and Use'),
            _p('We collect several different types of information for various purposes to provide and improve our Service to you.'),
            SizedBox(height: AppSpacing.sm),
            _sub('Types of Data Collected:'),
            _p('Personal Data: While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:'),
            SizedBox(height: AppSpacing.sm),
            _bullets(['Email address', 'First name and last name', 'Phone number', 'Address, State, Province, ZIP/Postal code, City', 'National ID number', 'Vehicle registration information', 'Payment information', 'Cookies and Usage Data']),
            SizedBox(height: AppSpacing.sm),
            _p('Usage Data: We may also collect information on how the Service is accessed and used ("Usage Data"). This Usage Data may include information such as your device\'s Internet Protocol address, browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, and other diagnostic data.'),
            SizedBox(height: AppSpacing.lg),
            _h('2. Use of Data'),
            _p('GarageGuru Ltd uses the collected data for various purposes:'),
            SizedBox(height: AppSpacing.sm),
            _bullets(['To provide and maintain our Service', 'To notify you about changes to our Service', 'To allow you to participate in interactive features of our Service', 'To provide customer support', 'To gather analysis so that we can improve our Service', 'To monitor the usage of our Service', 'To detect, prevent and address technical issues']),
            SizedBox(height: AppSpacing.lg),
            _h('3. Transfer of Data'),
            _p('Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ from those of your jurisdiction.'),
            SizedBox(height: AppSpacing.sm),
            _p('Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.'),
            SizedBox(height: AppSpacing.lg),
            _h('4. Disclosure of Data'),
            _sub('Legal Requirements'),
            _p('GarageGuru Ltd may disclose your Personal Data in the good faith belief that such action is necessary to:'),
            SizedBox(height: AppSpacing.sm),
            _bullets(['Comply with a legal obligation', 'Protect and defend the rights or property of GarageGuru Ltd', 'Prevent or investigate possible wrongdoing in connection with the Service', 'Protect the personal safety of users of the Service or the public', 'Protect against legal liability']),
            SizedBox(height: AppSpacing.lg),
            _h('5. Security of Data'),
            _p('The security of your data is important to us but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.'),
            SizedBox(height: AppSpacing.lg),
            _h('6. Service Providers'),
            _p('We may employ third party companies and individuals to facilitate our Service ("Service Providers"), provide the Service on our behalf, perform Service-related services or assist us in analysing how our Service is used. These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.'),
            SizedBox(height: AppSpacing.lg),
            _h('7. Links to Other Sites'),
            _p('Our Service may contain links to other sites that are not operated by us. We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.'),
            SizedBox(height: AppSpacing.lg),
            _h('8. Children\'s Privacy'),
            _p('Our Service does not address anyone under the age of 18 ("Children"). We do not knowingly collect personally identifiable information from anyone under the age of 18.'),
            SizedBox(height: AppSpacing.lg),
            _h('9. Changes to This Privacy Policy'),
            _p('We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.'),
            SizedBox(height: AppSpacing.lg),
            _h('10. Contact Us'),
            _p('If you have any questions about this Privacy Policy, please contact us:'),
            SizedBox(height: AppSpacing.sm),
            _bullets(['By email: privacy@garageguru.rw', 'By phone: +250 788 000 000', 'By mail: KG 11 Ave, Kigali, Rwanda']),
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
      child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
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
