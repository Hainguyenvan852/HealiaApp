import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/manager/options/presentation/pages/edit_staff_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/staff_profile_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/utils/snackbar_helper.dart';
import '../../../../../../l10n/app_localizations.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  String _searchQuery = '';
  late Future<List<StaffModel>> _staffsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _staffsFuture = _fetchStaffs();
  }

  Future<List<StaffModel>> _fetchStaffs() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    final storeId = await inj<ReportDatasource>().getManagerStoreId(user.id);
    if (storeId == null) return [];
    return inj<StoreDatasource>().fetchTeamMembersByStore(storeId);
  }

  Future<bool?> showActionBottomSheet(
    BuildContext context,
    StaffModel selectedStaff,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context); // close bottom sheet
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditStaffPage(isEdit: true, staff: selectedStaff),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _staffsFuture = _fetchStaffs();
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.edit,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          AppLocalizations.of(context)!.deleteStaff,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          AppLocalizations.of(context)!.confirmDeleteStaff,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              AppLocalizations.of(context)!.delete,
                              style: GoogleFonts.quicksand(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        await inj<StoreDatasource>().deleteStaff(
                          staffId: selectedStaff.id,
                        );
                        Navigator.pop(context, true);
                        SnackBarHelper.showSuccess(
                          AppLocalizations.of(context)!.staffDeletedSuccessfully,
                        );
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        if (mounted) {
                          SnackBarHelper.showError('$e');
                        }
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.delete,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _isLoading ? null : () => Navigator.pop(context),
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.arrowLeft,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditStaffPage(isEdit: false),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {
                                    _staffsFuture = _fetchStaffs();
                                  });
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.add,
                              style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FutureBuilder<List<StaffModel>>(
                    future: _staffsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: ColorTheme.mainAppColor(),
                            size: 40,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('${AppLocalizations.of(context)!.errorPrefix}${snapshot.error}'));
                      }

                      final staffs = snapshot.data ?? [];
                      final filteredStaff = staffs.where((staff) {
                        return staff.fullName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                      }).toList();

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            Text(
                              AppLocalizations.of(context)!.staff,
                              style: GoogleFonts.quicksand(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),

                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              readOnly: _isLoading ? true : false,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.searchStaff,
                                hintStyle: GoogleFonts.quicksand(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            filteredStaff.isEmpty
                                ? Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noStaffFound,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredStaff.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          color: Colors.grey.shade200,
                                          height: 32,
                                        ),
                                    itemBuilder: (context, index) {
                                      return _buildStaffItem(
                                        filteredStaff[index],
                                      );
                                    },
                                  ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: ColorTheme.mainAppColor(),
                    size: 50,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStaffItem(StaffModel staff) {
    final nameParts = staff.fullName.trim().split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts.first[0].toUpperCase();
      if (nameParts.length > 1) {
        initials += nameParts.last[0].toUpperCase();
      }
    }

    return GestureDetector(
      onTap: _isLoading
          ? null
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StaffProfilePage(staff: staff),
                ),
              );
              if (result == true) {
                setState(() {
                  _staffsFuture = _fetchStaffs();
                });
              }
            },
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF64B5F6), width: 2),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1976D2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                staff.fullName,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: _isLoading
                  ? null
                  : () async {
                      final result = await showActionBottomSheet(
                        context,
                        staff,
                      );

                      if (result != null && result) {
                        setState(() {
                          _staffsFuture = _fetchStaffs();
                          _isLoading = false;
                        });
                      }
                    },
              child: const PhosphorIcon(
                PhosphorIconsRegular.dotsThreeVertical,
                size: 28,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
