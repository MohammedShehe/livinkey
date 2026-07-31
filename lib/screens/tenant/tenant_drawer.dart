import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/common/snackbar_helper.dart';

class TenantDrawer extends StatelessWidget {
  const TenantDrawer({super.key});

  // Helper method to get responsive logo size for drawer
  double _getLogoSize(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Use the smaller dimension to ensure it fits
    final double minDimension = screenWidth < screenHeight ? screenWidth : screenHeight;
    
    // For tablets (width >= 600), use larger size
    if (screenWidth >= 600) {
      return minDimension * 0.25; // 25% of screen width for tablets
    }
    // For large phones
    else if (screenWidth >= 400) {
      return minDimension * 0.20; // 20% of screen width for large phones
    }
    // For small phones
    else {
      return minDimension * 0.18; // 18% of screen width for small phones
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive logo size
    final double logoSize = _getLogoSize(context);
    
    return Drawer(
      backgroundColor: kLivinkeyBlack,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(logoSize),
            Expanded(
              child: Column(
                children: [
                  _buildDrawerItem(
                    icon: Icons.description_rounded,
                    title: 'Terms of Service',
                    onTap: () {
                      SnackbarHelper.show(context, 'Terms of Service');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy Policy',
                    onTap: () {
                      SnackbarHelper.show(context, 'Privacy Policy');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent_rounded,
                    title: 'Support',
                    onTap: () {
                      _showSupportOptions(context);
                    },
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                    ),
                    child: const Text(
                      'A COMPLETE HOME',
                      style: TextStyle(
                        color: kLivinkeyGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double logoSize) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kLivinkeyGreen.withOpacity(0.15),
            Colors.transparent,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Image.asset(
          kGeneralLogo,
          height: logoSize,
          width: logoSize,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white.withOpacity(0.6),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.white.withOpacity(0.2),
        size: 20,
      ),
      onTap: onTap,
      hoverColor: kLivinkeyGreen.withOpacity(0.05),
      splashColor: kLivinkeyGreen.withOpacity(0.1),
    );
  }

  void _showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kLivinkeyBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Support',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _buildSupportOption(
              icon: FontAwesomeIcons.whatsapp,
              color: const Color(0xFF25D366),
              title: 'WhatsApp',
              subtitle: '+91 98783 83497',
              onTap: () => _launchUrl(context, kWhatsAppUrl),
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              icon: FontAwesomeIcons.instagram,
              color: const Color(0xFFE4405F),
              title: 'Instagram',
              subtitle: '@livinkey',
              onTap: () => _launchUrl(context, kInstagramUrl),
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              icon: Icons.email_rounded,
              color: Colors.blue,
              title: 'Email',
              subtitle: 'livinkey@gmail.com',
              onTap: () => _launchEmail(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle regular URLs (WhatsApp, Instagram, etc).
  // Note: we deliberately do NOT gate this on canLaunchUrl(). On Android 11+
  // canLaunchUrl() can return a false negative for implicit intents (like
  // mailto: or wa.me links) unless the querying app's package visibility is
  // declared — see the <queries> note below. Attempting the launch directly
  // and catching failures is more reliable in practice.
  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showUnableToOpenSnackbar(context, url);
      }
    } catch (_) {
      if (context.mounted) {
        _showUnableToOpenSnackbar(context, url);
      }
    }
  }

  // Dedicated method for launching email with layered fallbacks so the
  // support option always resolves to *something* useful for the user.
  Future<void> _launchEmail(BuildContext context) async {
    const String email = 'livinkey@gmail.com';

    // Try progressively simpler mailto URIs. Some mail apps / OEM Android
    // builds fail to resolve a mailto: URI that includes query parameters,
    // so we fall back to a bare address if the richer one fails.
    final List<Uri> attempts = [
      Uri(scheme: 'mailto', path: email, query: 'subject=Support%20Inquiry'),
      Uri(scheme: 'mailto', path: email),
    ];

    for (final uri in attempts) {
      try {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      } catch (_) {
        // Try the next, simpler URI.
      }
    }

    // No mail app could handle it (or none is installed) — copy the address
    // so the user can still reach support instead of hitting a dead end.
    await Clipboard.setData(const ClipboardData(text: email));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No email app found. Copied $email to clipboard.'),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showUnableToOpenSnackbar(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unable to open: $url'),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}