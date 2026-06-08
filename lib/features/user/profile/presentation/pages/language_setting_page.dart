import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/blocs/language_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = context.read<LanguageCubit>().state.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(), color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.appLanguage,
          style: GoogleFonts.roboto(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        'assets/images/logo-app-2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Healia',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              AppLocalizations.of(context)!.suggestedLanguage,
              style: GoogleFonts.roboto(
                color: Color(0xFF005A8C),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: Text(
              AppLocalizations.of(context)!.defaultLanguage,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: _selectedLanguage == 'en'
                ? Icon(Icons.check, color: Color(0xFF005A8C), size: 26)
                : null,
            onTap: () {
              if (_selectedLanguage != 'en') {
                setState(() {
                  _selectedLanguage = 'en';
                });
                context.read<LanguageCubit>().changeLanguage('en');
              }
            },
          ),
          const SizedBox(height: 24),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              AppLocalizations.of(context)!.allLanguages,
              style: GoogleFonts.roboto(
                color: Color(0xFF005A8C),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: Text(
              AppLocalizations.of(context)!.vietnamese,
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
            ),
            trailing: _selectedLanguage == 'vi'
                ? Icon(Icons.check, color: Color(0xFF005A8C), size: 26)
                : null,
            onTap: () {
              if (_selectedLanguage != 'vi') {
                setState(() {
                  _selectedLanguage = 'vi';
                });
                context.read<LanguageCubit>().changeLanguage('vi');
              }
            },
          ),
        ],
      ),
    );
  }
}
