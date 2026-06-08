import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/manager/options/presentation/pages/business_setup_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/category_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/report_menu_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/staff_management_page.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../account setups/presentation/pages/marketplace_intro_screen.dart';
import '../../../calendar/presentation/pages/manager_profile_page.dart';
import '../../../calendar/presentation/pages/notification_page.dart';
import '../../../../../../l10n/app_localizations.dart';

class GridMenuPage extends StatefulWidget {
  const GridMenuPage({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<GridMenuPage> createState() => _GridMenuPageState();
}

class _GridMenuPageState extends State<GridMenuPage> {
  Future<Map<String, dynamic>> getCurrentStore() async {
    final response = await Supabase.instance.client
        .from('stores')
        .select('*')
        .eq('manager_id', widget.currentUser.id)
        .single();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F9),
      body: SafeArea(
        child: FutureBuilder(
          future: getCurrentStore(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: ColorTheme.mainAppColor(),
                  size: 50,
                ),
              );
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text(asyncSnapshot.error.toString()));
            }

            final isActive = asyncSnapshot.data!['is_active'] as bool;
            final String storeType =
                asyncSnapshot.data!['store_type'] as String;

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (!isActive)
                    _buildActivatePlanBanner(context, asyncSnapshot.data!),
                  _buildTopHeader(context),
                  const SizedBox(height: 40),
                  _buildMenuGrid(context, storeType, isActive),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivatePlanBanner(
    BuildContext context,
    Map<String, dynamic> store,
  ) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarketplaceIntroScreen(store: store),
          ),
        );
        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        color: const Color(0xFF6B4EFF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(PhosphorIcons.usersThree(), color: Colors.black87),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.addToWorkspace,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  PhosphorIcons.bell(PhosphorIconsStyle.bold),
                  size: 25,
                  color: Colors.black87,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManagerProfilePage(currentUser: widget.currentUser),
                  ),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: widget.currentUser.avatarUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: widget.currentUser.avatarUrl!,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) {
                                return Text(
                                  widget.currentUser.fullName[0],
                                  style: GoogleFonts.quicksand(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          )
                        : Text(
                            widget.currentUser.fullName[0],
                            style: GoogleFonts.quicksand(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, String storeType, bool isActive) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': AppLocalizations.of(context)!.catalog,
        'icon': PhosphorIcons.bookOpenText(),
        'tap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryPage()),
        ),
      },
      if (storeType == 'team')
        {
          'title': AppLocalizations.of(context)!.team,
          'icon': PhosphorIcons.usersThree(),
          'tap': () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StaffManagementPage()),
          ),
        },
      {
        'title': AppLocalizations.of(context)!.reports,
        'icon': PhosphorIcons.chartLineUp(),
        'tap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportSummaryPage()),
        ),
      },
      {
        'title': AppLocalizations.of(context)!.businessSettings,
        'icon': PhosphorIcons.gearSix(),
        'tap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessSetupPage(isActive: isActive),
          ),
        ),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.45,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return _buildMenuCard(
            item['title'],
            item['icon'],
            onTap: item['tap'],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 26, color: Colors.black87),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
