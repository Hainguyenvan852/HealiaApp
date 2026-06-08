import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import 'package:healio_app/features/manager/options/presentation/pages/add_service_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import '../../../../../../l10n/app_localizations.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<CategoryModel>> _categoriesFuture;
  String _searchQuery = '';
  String _selectedCategory = 'All categories';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    final storeId = await inj<ReportDatasource>().getManagerStoreId(user.id);
    if (storeId == null) return [];
    return inj<StoreDatasource>().fetchCategoriesWithServices(storeId);
  }

  String formatDuration(int minutes) {
    int h = minutes ~/ 60;
    int m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    return '${m}min';
  }

  void showAddActionBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(PhosphorIcons.x(), size: 24),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const AddServicePage(),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _categoriesFuture = _fetchCategories();
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.singleService,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await showAddCategoryBottomSheet(context);
                    if (result == true) {
                      setState(() {
                        _categoriesFuture = _fetchCategories();
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.category,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
  }

  void showCategoryActionBottomSheet(
    BuildContext context,
    CategoryModel category,
  ) {
    showModalBottomSheet(
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(PhosphorIcons.x(), size: 24),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await showEditCategoryBottomSheet(
                      context,
                      category,
                    );
                    if (result == true) {
                      setState(() {
                        _categoriesFuture = _fetchCategories();
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
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddServicePage(selectedCategory: category),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _categoriesFuture = _fetchCategories();
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.addService,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.deletePermanently,
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
  }

  Future<bool?> showEditCategoryBottomSheet(
    BuildContext context,
    CategoryModel category,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryBottomSheet(category: category),
    );
  }

  Future<bool?> showAddCategoryBottomSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<CategoryModel>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: ColorTheme.mainAppColor(),
                  size: 50,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
                  style: GoogleFonts.quicksand(color: Colors.red),
                ),
              );
            }

            final categories = snapshot.data ?? [];
            final Map<String, int> categoryCounts = {};
            int totalServices = 0;

            for (var cat in categories) {
              int count = cat.services?.length ?? 0;
              categoryCounts[cat.name] = count;
              totalServices += count;
            }
            categoryCounts['All categories'] = totalServices;

            final List<String> categoryKeys = [
              'All categories',
              ...categories.map((e) => e.name),
            ];

            final Map<String, List<ServiceModel>> groupedServices = {};
            List<ServiceModel> allFilteredServices = [];

            for (var cat in categories) {
              if (cat.services == null) continue;

              final matchesCategory =
                  _selectedCategory == 'All categories' ||
                  cat.name == _selectedCategory;

              if (!matchesCategory) continue;

              final matchingServices = cat.services!.where((service) {
                return service.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
              }).toList();

              if (matchingServices.isNotEmpty) {
                groupedServices[cat.name] = matchingServices;
                allFilteredServices.addAll(matchingServices);
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.arrowLeft,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () => showAddActionBottomSheet(context),
                        icon: const PhosphorIcon(
                          PhosphorIconsRegular.plus,
                          size: 16,
                          color: Colors.black,
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.add,
                          style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.serviceMenu,
                        style: GoogleFonts.quicksand(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${AppLocalizations.of(context)!.serviceMenuDesc} ',
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.learnMore,
                              style: const TextStyle(
                                color: Color(0xFF6B4EFF),
                              ), // Link màu tím
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          )!.searchServiceName,
                          hintStyle: GoogleFonts.quicksand(
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
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
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: categoryKeys.map((category) {
                      final isSelected = _selectedCategory == category;
                      final count = categoryCounts[category]!;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                category == 'All categories'
                                    ? AppLocalizations.of(
                                        context,
                                      )!.allCategories
                                    : category,
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  count.toString(),
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: allFilteredServices.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noServicesFound,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: groupedServices.keys.length,
                          itemBuilder: (context, index) {
                            String categoryName = groupedServices.keys
                                .elementAt(index);
                            List<ServiceModel> servicesInCategory =
                                groupedServices[categoryName]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16,
                                    top: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        categoryName,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          final cat = categories.firstWhere(
                                            (c) => c.name == categoryName,
                                          );
                                          showCategoryActionBottomSheet(
                                            context,
                                            cat,
                                          );
                                        },
                                        child: const PhosphorIcon(
                                          PhosphorIconsRegular
                                              .dotsThreeVertical,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...servicesInCategory.map(
                                  (service) => _buildServiceItem(service),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFF87CEEB), width: 4)),
      ),
      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatDuration(service.duration),
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₫${service.price}',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBottomSheet extends StatefulWidget {
  final CategoryModel? category;
  const CategoryBottomSheet({super.key, this.category});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  final formKey = GlobalKey<FormFieldState>();

  int _descLength = 0;
  bool _isLoading = false;

  late List<ServiceModel> _currentServices;
  final List<ServiceModel> _deletedServices = [];

  bool get _hasChanges {
    final nameChanged =
        _nameController.text.trim() != (widget.category?.name ?? '');
    final descChanged =
        _descController.text.trim() != (widget.category?.description ?? '');
    final servicesChanged = _deletedServices.isNotEmpty;
    return nameChanged || descChanged || servicesChanged;
  }

  @override
  void initState() {
    super.initState();
    _currentServices = List.from(widget.category?.services ?? []);
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _descLength = _descController.text.length;
    _descController.addListener(() {
      setState(() {
        _descLength = _descController.text.length;
      });
    });
  }

  Future<void> _updateCategory() async {
    final name = _nameController.text.trim();
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await inj<StoreDatasource>().updateCategory(
        widget.category!.id,
        name,
        _descController.text.trim(),
      );
      for (final service in _deletedServices) {
        await inj<StoreDatasource>().deleteService(service.id);
      }
      if (mounted) {
        SnackBarHelper.showSuccess(
          AppLocalizations.of(context)!.categoryUpdatedSuccess,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addCategory() async {
    final name = _nameController.text.trim();
    if (!formKey.currentState!.validate()) {
      return;
    }
    final user = Supabase.instance.client.auth.currentUser;
    final storeId = await inj<ReportDatasource>().getManagerStoreId(user!.id);
    if (storeId == null) return;

    setState(() => _isLoading = true);
    try {
      await inj<StoreDatasource>().addCategory(
        name: name,
        description: _descController.text.trim(),
        storeId: storeId,
      );
      if (mounted) {
        SnackBarHelper.showSuccess(
          AppLocalizations.of(context)!.categoryAddedSuccess,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.category != null
                          ? AppLocalizations.of(context)!.editCategory
                          : AppLocalizations.of(context)!.addCategory,
                      style: GoogleFonts.quicksand(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(AppLocalizations.of(context)!.categoryName),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: formKey,
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _inputDecoration(),
                    validator: (value) => emptyValidation(value),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel(AppLocalizations.of(context)!.description),
                      Text(
                        '$_descLength/255',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    height: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _descController,
                            onChanged: (_) => setState(() {}),
                            maxLength: 255,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: AppLocalizations.of(
                                context,
                              )!.enterDescription,
                              hintStyle: GoogleFonts.quicksand(
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_currentServices.isNotEmpty) ...[
                    _buildLabel(AppLocalizations.of(context)!.services),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _currentServices.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final service = _currentServices[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            service.name,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '₫${service.price}',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _currentServices.removeAt(index);
                                _deletedServices.add(service);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading || !_hasChanges
                        ? null
                        : (widget.category != null
                              ? _updateCategory
                              : _addCategory),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
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
                ),
              ],
            ),
          ),
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
}
