import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import '../../../../../../l10n/app_localizations.dart';

class AddServicePage extends StatefulWidget {
  final CategoryModel? selectedCategory;
  const AddServicePage({super.key, this.selectedCategory});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  int _nameLength = 0;
  int _descLength = 0;

  CategoryModel? _selectedCategoryModel;
  String _selectedPriceType = 'Fixed';
  String? _selectedDuration;

  List<CategoryModel> _categories = [];
  bool _isLoadingCategories = true;
  bool _isSaving = false;

  List<String> _durations = [];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(
      () => setState(() => _nameLength = _nameController.text.length),
    );
    _descController.addListener(
      () => setState(() => _descLength = _descController.text.length),
    );

    _generateDurations();

    if (widget.selectedCategory != null) {
      _selectedCategoryModel = widget.selectedCategory;
      _isLoadingCategories = false;
    } else {
      _loadCategories();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final storeId = await inj<ReportDatasource>().getManagerStoreId(user.id);
      if (storeId == null) return;

      final categories = await inj<StoreDatasource>()
          .fetchCategoriesWithServices(storeId);
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
      }
    }
  }

  void _generateDurations() {
    for (int i = 5; i <= 120; i += 5) {
      _durations.add(_formatDuration(i));
    }
    for (int i = 135; i <= 720; i += 15) {
      _durations.add(_formatDuration(i));
    }
    _selectedDuration = _durations.firstWhere(
      (d) => d == '1h',
      orElse: () => _durations.first,
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    int h = minutes ~/ 60;
    int m = minutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}min';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.newService,
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _buildBasicDetailsTab(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBasicDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.basicDetails,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildLabelWithCounter(AppLocalizations.of(context)!.serviceName, _nameLength, 255),
          const SizedBox(height: 8),
          _buildTextField(
            _nameController,
            AppLocalizations.of(context)!.addServiceNameHint,
            255,
          ),
          const SizedBox(height: 24),

          _buildLabel(AppLocalizations.of(context)!.menuCategory),
          const SizedBox(height: 8),
          if (widget.selectedCategory != null)
            TextField(
              controller: TextEditingController(
                text: widget.selectedCategory!.name,
              ),
              readOnly: true,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: _inputDecoration(''),
            )
          else if (_isLoadingCategories)
            _buildDropdown(
              items: [],
              value: null,
              hint: AppLocalizations.of(context)!.selectCategory,
              onChanged: (val) {},
            )
          else
            _buildDropdown(
              items: _categories.map((e) => e.name).toList(),
              value: _selectedCategoryModel?.name,
              hint: AppLocalizations.of(context)!.selectCategory,
              onChanged: (val) {
                setState(() {
                  _selectedCategoryModel = _categories.firstWhere(
                    (e) => e.name == val,
                  );
                });
              },
            ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.categoryDisplayDesc,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          _buildLabelWithCounter(AppLocalizations.of(context)!.descriptionOptional, _descLength, 1000),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLength: 1000,
            maxLines: 4,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              AppLocalizations.of(context)!.addShortDescription,
            ).copyWith(counterText: ""),
          ),
          const SizedBox(height: 40),

          Text(
            AppLocalizations.of(context)!.pricingAndDuration,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(AppLocalizations.of(context)!.price),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _inputDecoration('0.00').copyWith(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 8,
                            top: 14,
                          ),
                          child: Text(
                            '₫',
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        fillColor: _selectedPriceType == 'Free'
                            ? Colors.grey.shade100
                            : Colors.white,
                        filled: _selectedPriceType == 'Free',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Duration
          _buildLabel(AppLocalizations.of(context)!.duration),
          const SizedBox(height: 8),
          _buildDropdown(
            items: _durations,
            value: _selectedDuration,
            hint: AppLocalizations.of(context)!.selectDuration,
            onChanged: (val) =>
                setState(() => _selectedDuration = val as String?),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLabelWithCounter(String text, int current, int max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel(text),
        Text(
          '$current/$max',
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    int maxLength,
  ) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: _inputDecoration(hint).copyWith(counterText: ""),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String? value,
    required String hint,
    required Function(dynamic) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          value != null ? value : hint,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            color: value != null ? Colors.black : Colors.grey.shade400,
          ),
        ),
        items: items
            .map(
              (item) => DropdownItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: PhosphorIcon(PhosphorIconsRegular.caretDown, size: 20),
          iconEnabledColor: Colors.black,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          offset: const Offset(0, -5),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.quicksand(color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    );
  }

  Future<void> _saveService() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final priceStr = _priceController.text.trim();
    final price = double.tryParse(priceStr);

    if (name.isEmpty) {
      SnackBarHelper.showAlert(AppLocalizations.of(context)!.serviceNameEmptyError);
      return;
    }
    if (_selectedCategoryModel == null) {
      SnackBarHelper.showAlert(AppLocalizations.of(context)!.selectCategoryError);
      return;
    }
    if (price == null) {
      SnackBarHelper.showAlert(AppLocalizations.of(context)!.validPriceError);
      return;
    }
    if (_selectedDuration == null) {
      SnackBarHelper.showAlert(AppLocalizations.of(context)!.selectDurationError);
      return;
    }

    int durationMinutes = 0;
    final matchH = RegExp(r'(\d+)h').firstMatch(_selectedDuration!);
    final matchM = RegExp(r'(\d+)min').firstMatch(_selectedDuration!);
    if (matchH != null) {
      durationMinutes += int.parse(matchH.group(1)!) * 60;
    }
    if (matchM != null) {
      durationMinutes += int.parse(matchM.group(1)!);
    }

    setState(() => _isSaving = true);
    try {
      await inj<StoreDatasource>().addService(
        name: name,
        description: desc,
        durationMinutes: durationMinutes,
        price: price,
        categoryId: _selectedCategoryModel!.id,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveService,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isSaving
            ? LoadingAnimationWidget.progressiveDots(
                color: Colors.white,
                size: 30,
              )
            : Text(
                AppLocalizations.of(context)!.save,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
