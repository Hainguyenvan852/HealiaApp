import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TermsAndPolicyPage extends StatefulWidget {
  const TermsAndPolicyPage({super.key});

  @override
  State<TermsAndPolicyPage> createState() => _TermsAndPolicyPageState();
}

class _TermsAndPolicyPageState extends State<TermsAndPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: PhosphorIcon(PhosphorIcons.arrowLeft(), color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Healia',
            style: GoogleFonts.dancingScript(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: false,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.termsOfUse),
              Tab(text: AppLocalizations.of(context)!.privacyPolicy),
              Tab(text: AppLocalizations.of(context)!.termsOfService),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTermsOfUseTab(),
            _buildPrivacyPolicyTab(),
            _buildTermsOfServiceTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsOfUseTab() {
    return _buildDocumentContent(
      title: AppLocalizations.of(context)!.termsOfUseTitle,
      sections: [
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfUseHeader1,
          body: AppLocalizations.of(context)!.termsOfUseBody1
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfUseHeader2,
          body: AppLocalizations.of(context)!.termsOfUseBody2,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfUseHeader3,
          body: AppLocalizations.of(context)!.termsOfUseBody3,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfUseHeader4,
          body: AppLocalizations.of(context)!.termsOfUseBody4,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfUseHeader5,
          body: AppLocalizations.of(context)!.termsOfUseBody5,
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicyTab() {
    return _buildDocumentContent(
      title: AppLocalizations.of(context)!.privacyPolicyTitle,
      sections: [
        _SectionInfo(
          heading: AppLocalizations.of(context)!.privacyPolicyHeader1,
          body: AppLocalizations.of(context)!.privacyPolicyBody1,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.privacyPolicyHeader2,
          body: AppLocalizations.of(context)!.privacyPolicyBody2,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.privacyPolicyHeader3,
          body: AppLocalizations.of(context)!.privacyPolicyBody3,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.privacyPolicyHeader4,
          body: AppLocalizations.of(context)!.privacyPolicyBody4,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.privacyPolicyHeader5,
          body: AppLocalizations.of(context)!.privacyPolicyBody5,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.privacyPolicyHeader6,
          body: AppLocalizations.of(context)!.privacyPolicyBody6,
        ),
      ],
    );
  }

  Widget _buildTermsOfServiceTab() {
    return _buildDocumentContent(
      title: AppLocalizations.of(context)!.termsOfServiceTitle,
      sections: [
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfServiceHeader1,
          body: AppLocalizations.of(context)!.termsOfServiceBody1,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfServiceHeader2,
          body: AppLocalizations.of(context)!.termsOfServiceBody2,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfServiceHeader3,
          body: AppLocalizations.of(context)!.termsOfServiceBody3,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfServiceHeader4,
          body: AppLocalizations.of(context)!.termsOfServiceBody4,
        ),
        _SectionInfo(
          heading: AppLocalizations.of(context)!.termsOfServiceHeader5,
          body: AppLocalizations.of(context)!.termsOfServiceBody5,
        ),
      ],
    );
  }

  Widget _buildDocumentContent({
    required String title,
    required List<_SectionInfo> sections,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          ...sections.map((section) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.heading,
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      section.body,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionInfo {
  final String heading;
  final String body;

  _SectionInfo({required this.heading, required this.body});
}