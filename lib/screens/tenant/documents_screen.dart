import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../widgets/tenant/document_card.dart';
import '../../widgets/common/snackbar_helper.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isInternational = false;

  final List<Map<String, String>> _internationalDocs = [
    {'label': 'Passport Size Photo', 'icon': '📸'},
    {'label': 'Passport Photo', 'icon': '📖'},
    {'label': 'Visa Photo', 'icon': '🛂'},
    {'label': 'Arrival Stamp Photo', 'icon': '📌'},
    {'label': 'C-Form Photo', 'icon': '📋'},
    {'label': 'University ID Photo', 'icon': '🎓'},
  ];

  final List<Map<String, String>> _nationalDocs = [
    {'label': 'Passport Size Photo', 'icon': '📸'},
    {'label': 'Tenant Aadhar Card Photo', 'icon': '🪪'},
    {'label': 'Parent Aadhar Card Photo', 'icon': '🪪'},
    {'label': 'University ID Photo', 'icon': '🎓'},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: kFadeDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _docs => _isInternational ? _internationalDocs : _nationalDocs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLivinkeyBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: Colors.white, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Documents'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: _isInternational ? 'International' : 'National',
              dropdownColor: kLivinkeyBlack,
              underline: const SizedBox.shrink(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'International',
                  child: Text('🌍 International'),
                ),
                DropdownMenuItem(
                  value: 'National',
                  child: Text('🇮🇳 National'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _isInternational = value == 'International';
                });
                HapticFeedback.selectionClick();
              },
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kLivinkeyGreen.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kLivinkeyGreen.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: kLivinkeyGreen.withOpacity(0.7),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tap on any document to view it in full screen',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Document Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _docs.length,
                itemBuilder: (context, index) {
                  final hasPhoto = DateTime.now().millisecondsSinceEpoch % 3 != 0;
                  return DocumentCard(
                    doc: _docs[index],
                    hasPhoto: hasPhoto,
                    onTap: () => _showDocumentPreview(_docs[index]['label']!),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Download Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        SnackbarHelper.show(context, 'All documents selected for download');
                      },
                      icon: const Icon(Icons.download_rounded, color: Colors.white),
                      label: const Text(
                        'Download Selected',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: kLivinkeyGreen.withOpacity(0.3),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SnackbarHelper.show(context, 'Downloading all documents...');
                      },
                      icon: const Icon(Icons.download_rounded, color: Colors.black),
                      label: const Text(
                        'Download All',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLivinkeyGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentPreview(String label) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: kLivinkeyBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kLivinkeyGreen.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kLivinkeyGreen.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '📄',
                    style: TextStyle(
                      fontSize: 60,
                      color: kLivinkeyGreen.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SnackbarHelper.show(context, 'Document downloaded');
                      },
                      icon: const Icon(Icons.download_rounded, color: Colors.black),
                      label: const Text(
                        'Download',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLivinkeyGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}