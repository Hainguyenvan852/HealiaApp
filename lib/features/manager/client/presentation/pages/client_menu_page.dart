import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_client_page.dart';
import 'client_profile_page.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/shared/datasource/client_datasource.dart';
import 'package:healio_app/shared/models/client_model.dart';
import '../../../../../l10n/app_localizations.dart';

enum ClientSortOption { tenAZ, tenZA, ngayTaoCuNhat, ngayTaoMoiNhat }

class ClientMenuPage extends StatefulWidget {
  const ClientMenuPage({super.key});

  @override
  State<ClientMenuPage> createState() => _ClientMenuPageState();
}

class _ClientMenuPageState extends State<ClientMenuPage> {
  String _searchQuery = '';
  ClientSortOption _currentSortOption = ClientSortOption.tenAZ;
  List<ClientModel> _allClients = [];
  bool _isLoading = true;
  int? _storeId;
  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final currentUser = inj<CheckCurrentUserUseCase>().call();

      final response = await Supabase.instance.client
          .from('stores')
          .select('*')
          .eq('manager_id', currentUser!.id)
          .single();

      _storeId = response['id'] as int;
      final clients = await inj<ClientDatasource>().getClientsByStoreId(
        _storeId!,
      );
      if (mounted) {
        setState(() {
          _allClients = clients;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<ClientModel> get _processedClients {
    var list = _allClients.where((client) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return client.fullName.toLowerCase().contains(query) ||
          client.email.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      switch (_currentSortOption) {
        case ClientSortOption.tenAZ:
          return a.fullName.compareTo(b.fullName);
        case ClientSortOption.tenZA:
          return b.fullName.compareTo(a.fullName);
        case ClientSortOption.ngayTaoCuNhat:
          return a.createdAt.compareTo(b.createdAt);
        case ClientSortOption.ngayTaoMoiNhat:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return list;
  }

  void _openFilterSheet() async {
    final selectedSort = await showModalBottomSheet<ClientSortOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _FilterBottomSheet(initialSort: _currentSortOption);
      },
    );

    if (selectedSort != null) {
      setState(() {
        _currentSortOption = selectedSort;
      });
    }
  }

  Future<void> _exportToCsv(BuildContext context, String extension) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filename =
          'clients_export_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final path = '${directory.path}/$filename';
      final file = File(path);

      String csvData =
          "Full Name,Email,Phone,Date of Birth,Gender,Joined Date\n";

      for (var client in _processedClients) {
        final dob = client.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(client.dateOfBirth!)
            : '';
        final createdAt = DateFormat('dd/MM/yyyy').format(client.createdAt);
        final gender = client.gender == 1
            ? AppLocalizations.of(context)!.male
            : (client.gender == 2
                  ? AppLocalizations.of(context)!.female
                  : AppLocalizations.of(context)!.other);
        csvData +=
            '"${client.fullName}","${client.email}","${client.phoneNumber ?? ''}","$dob","$gender","$createdAt"\n';
      }

      await file.writeAsString(csvData);

      if (mounted) {
        Navigator.pop(context); // close bottom sheet
        await Share.shareXFiles([
          XFile(path),
        ], text: AppLocalizations.of(context)!.exportedClientList);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Error exporting data: $e');
      }
    }
  }

  void showClientActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return _ClientActionsMenu(
          onExportCsv: () => _exportToCsv(context, 'csv'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildTopActions(context),
                  const SizedBox(height: 24),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: ColorTheme.mainAppColor(),
                          size: 50,
                        ),
                      )
                    : _buildClientsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () => showClientActionsBottomSheet(context),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewClientPage(storeId: _storeId!),
              ),
            );
            if (result == true) {
              _loadClients();
            }
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.add,
                style: GoogleFonts.quicksand(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.add, size: 20, color: Colors.black87),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.clientsList,
          style: GoogleFonts.quicksand(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.manageClientsDesc,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchClientsHint,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF6B4EFF)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
            color: _currentSortOption != ClientSortOption.tenAZ
                ? const Color(0xFFF3F0FF)
                : Colors.transparent,
          ),
          child: IconButton(
            icon: Icon(
              Icons.tune,
              color: _currentSortOption != ClientSortOption.tenAZ
                  ? const Color(0xFF6B4EFF)
                  : Colors.black87,
            ),
            onPressed: _openFilterSheet,
          ),
        ),
      ],
    );
  }

  Widget _buildClientsList() {
    final clients = _processedClients;

    if (clients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            AppLocalizations.of(context)!.noClientsAvailable,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: clients.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final client = clients[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFF3F0FF),
            child: Text(
              client.fullName.isNotEmpty
                  ? client.fullName[0].toUpperCase()
                  : '?',
              style: GoogleFonts.quicksand(
                color: const Color(0xFF6B4EFF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            client.fullName,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            '${client.phoneNumber} • ${client.email}',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClientProfilePage(client: client),
              ),
            );
            if (result == 'deleted' ||
                (result != null && result is ClientModel)) {
              _loadClients();
            }
          },
        );
      },
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final ClientSortOption initialSort;

  const _FilterBottomSheet({required this.initialSort});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late ClientSortOption _localSelectedSort;

  @override
  void initState() {
    super.initState();
    _localSelectedSort = widget.initialSort;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 8, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.allFilters,
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                const Icon(Icons.sort, color: Colors.black87),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.sortBy,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: const Color(0xFF6B4EFF),
                  child: Text(
                    '1',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildRadioOption(
            AppLocalizations.of(context)!.nameAZ,
            ClientSortOption.tenAZ,
          ),
          _buildRadioOption(
            AppLocalizations.of(context)!.nameZA,
            ClientSortOption.tenZA,
          ),
          _buildRadioOption(
            AppLocalizations.of(context)!.creationDateOldest,
            ClientSortOption.ngayTaoCuNhat,
          ),
          _buildRadioOption(
            AppLocalizations.of(context)!.creationDateNewest,
            ClientSortOption.ngayTaoMoiNhat,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _localSelectedSort =
                            ClientSortOption.tenAZ; // Đặt về mặc định
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.clearFilters,
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _localSelectedSort);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.apply,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, ClientSortOption option) {
    bool isSelected = _localSelectedSort == option;
    return InkWell(
      onTap: () => setState(() => _localSelectedSort = option),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (isSelected) const Icon(Icons.check, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}

class _ClientActionsMenu extends StatelessWidget {
  const _ClientActionsMenu({required this.onExportCsv});
  final VoidCallback onExportCsv;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black87, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Text(
                AppLocalizations.of(context)!.exportData,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildActionItem(
              icon: Icons.insert_drive_file_outlined,
              title: 'CSV',
              isDocumentIcon: true,
              documentLabel: 'CSV',
              onTap: onExportCsv,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDocumentIcon = false,
    String documentLabel = '',
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          children: [
            isDocumentIcon
                ? _buildCustomDocumentIcon(documentLabel)
                : Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDocumentIcon(String label) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 28,
            color: Colors.black87,
          ),
          Positioned(
            bottom: 4,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
