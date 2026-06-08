import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healio_app/features/manager/widgets/step_progress_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/marketplace_setup_cubit.dart';
import 'marketplace_store_description_screen.dart';

class MarketplaceStorePhotosScreen extends StatefulWidget {
  const MarketplaceStorePhotosScreen({super.key});

  @override
  State<MarketplaceStorePhotosScreen> createState() =>
      _MarketplaceStorePhotosScreenState();
}

class _MarketplaceStorePhotosScreenState
    extends State<MarketplaceStorePhotosScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _coverPhoto;
  List<File> _galleryPhotos = [];

  @override
  void initState() {
    super.initState();
    final state = context.read<MarketplaceSetupCubit>().state;
    _coverPhoto = state.coverPhoto;
    _galleryPhotos = List.from(state.galleryPhotos);
  }

  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _coverPhoto = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickGridImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          for (var img in images) {
            if (_galleryPhotos.length < 9) {
              _galleryPhotos.add(File(img.path));
            } else {
              break; // max 9 photos
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void _removeCoverImage() {
    setState(() {
      _coverPhoto = null;
    });
  }

  void _removeGridImage(int index) {
    setState(() {
      _galleryPhotos.removeAt(index);
    });
  }

  void _showMenuOptions({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(
                  AppLocalizations.of(context)!.changePhoto,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  AppLocalizations.of(context)!.deletePhoto,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onNext() {
    int totalPhotos = (_coverPhoto != null ? 1 : 0) + _galleryPhotos.length;
    if (totalPhotos < 3) {
      SnackBarHelper.showAlert(
        AppLocalizations.of(context)!.pleaseSelectAtLeast3Photos,
      );
      return;
    }

    context.read<MarketplaceSetupCubit>().updateCoverPhoto(_coverPhoto);
    context.read<MarketplaceSetupCubit>().updateGalleryPhotos(_galleryPhotos);

    final cubit = context.read<MarketplaceSetupCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: cubit,
          child: const MarketplaceStoreDescriptionScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const StepProgressBar(
          currentStep: 2,
          totalSteps: 3,
          padding: EdgeInsets.zero,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.addPhotos,
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.addCoverAndGalleryPhotos,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildCoverImageSection(),
                  const SizedBox(height: 12),

                  Text(
                    AppLocalizations.of(context)!.photoFormatRequirement,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildImagesGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.continuee,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImageSection() {
    final bool hasImage = _coverPhoto != null;

    return Stack(
      children: [
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: Colors.grey.shade300,
            strokeWidth: 1.5,
            dashPattern: const [6, 4],
            radius: const Radius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_coverPhoto!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addCoverPhoto,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _pickCoverImage,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.choosePhoto,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (hasImage)
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                _showMenuOptions(
                  onEdit: _pickCoverImage,
                  onDelete: _removeCoverImage,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5DFFF)),
            ),
            child: Text(
              AppLocalizations.of(context)!.coverPhoto,
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4EFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesGrid() {
    // Show Add button if we have less than 9 images
    final bool canAddMore = _galleryPhotos.length < 9;
    final int totalItems = _galleryPhotos.length + (canAddMore ? 1 : 0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (canAddMore && index == totalItems - 1) {
          // Last item is Add button
          return _buildAddImageCard();
        }

        return _buildImageCard(file: _galleryPhotos[index], index: index);
      },
    );
  }

  Widget _buildAddImageCard() {
    return GestureDetector(
      onTap: _pickGridImages,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: Colors.grey.shade300,
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
          radius: const Radius.circular(12),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.black54, size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard({required File file, required int index}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade100,
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              _showMenuOptions(
                onEdit: _pickGridImages,
                onDelete: () => _removeGridImage(index),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
