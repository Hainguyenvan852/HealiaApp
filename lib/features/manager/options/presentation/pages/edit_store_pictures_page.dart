import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/image_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/utils/color_theme.dart';
import '../../../../../../l10n/app_localizations.dart';

class EditStorePicturesPage extends StatefulWidget {
  final StoreModel store;
  final List<ImageModel> existingImages;

  const EditStorePicturesPage({
    Key? key,
    required this.store,
    required this.existingImages,
  }) : super(key: key);

  @override
  State<EditStorePicturesPage> createState() => _EditStorePicturesPageState();
}

class _EditStorePicturesPageState extends State<EditStorePicturesPage> {
  final ImagePicker _picker = ImagePicker();

  String? _currentCoverUrl;
  File? _newCoverFile;
  bool _coverDeleted = false;

  List<ImageModel> _currentImages = [];
  List<ImageModel> _deletedImages = [];
  List<File> _newImages = [];

  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _currentCoverUrl = widget.store.primaryImageUrl.isNotEmpty
        ? widget.store.primaryImageUrl
        : null;
    _currentImages = List.from(widget.existingImages);
  }

  void _checkForChanges() {
    bool changed = false;
    if (_newCoverFile != null || _coverDeleted) changed = true;
    if (_deletedImages.isNotEmpty) changed = true;
    if (_newImages.isNotEmpty) changed = true;

    if (_hasChanges != changed) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _newCoverFile = File(image.path);
          _coverDeleted = false;
          _checkForChanges();
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickGridImage() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          for (var img in images) {
            _newImages.add(File(img.path));
          }
          _checkForChanges();
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void _removeCoverImage() {
    setState(() {
      _newCoverFile = null;
      _currentCoverUrl = null;
      _coverDeleted = true;
      _checkForChanges();
    });
  }

  void _removeGridImage(int index, {required bool isNew}) {
    setState(() {
      if (isNew) {
        _newImages.removeAt(index);
      } else {
        _deletedImages.add(_currentImages[index]);
        _currentImages.removeAt(index);
      }
      _checkForChanges();
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final supabase = Supabase.instance.client;
      String? finalCoverUrl = _currentCoverUrl;

      // 1. Upload new cover image if any
      if (_newCoverFile != null) {
        final fileName =
            'cover_${DateTime.now().millisecondsSinceEpoch}_${widget.store.id}.jpg';
        // Assume bucket 'store_images' exists.
        await supabase.storage
            .from('store_images')
            .upload(
              fileName,
              _newCoverFile!,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );
        finalCoverUrl = supabase.storage
            .from('store_images')
            .getPublicUrl(fileName);
      } else if (_coverDeleted) {
        finalCoverUrl = '';
      }

      // Update cover in stores table if changed
      if (_newCoverFile != null || _coverDeleted) {
        await supabase
            .from('stores')
            .update({'image_url': finalCoverUrl})
            .eq('id', widget.store.id);
      }

      // 2. Delete removed images from store_images table
      if (_deletedImages.isNotEmpty) {
        final idsToDelete = _deletedImages.map((e) => e.id).toList();
        await supabase
            .from('store_images')
            .delete()
            .inFilter('id', idsToDelete);
        // Optionally, delete from storage bucket if needed, but not strictly required for this demo
      }

      // 3. Upload new grid images and insert into store_images
      for (var file in _newImages) {
        final fileName =
            'grid_${DateTime.now().millisecondsSinceEpoch}_${widget.store.id}.jpg';
        await supabase.storage
            .from('store_images')
            .upload(
              fileName,
              file,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );
        final imgUrl = supabase.storage
            .from('store_images')
            .getPublicUrl(fileName);
        await supabase.from('store_images').insert({
          'store_id': widget.store.id,
          'image_url': imgUrl,
        });
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Save error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
                  AppLocalizations.of(context)!.changeImage,
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
                  AppLocalizations.of(context)!.deleteImage,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.updateLocationPictures,
                    style: GoogleFonts.quicksand(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCoverImageSection(),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.fileTypeAndSizeInfo,
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
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCoverImageSection() {
    final bool hasImage = _newCoverFile != null || _currentCoverUrl != null;

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
                    child: _newCoverFile != null
                        ? Image.file(_newCoverFile!, fit: BoxFit.cover)
                        : CachedNetworkImage(
                            imageUrl: _currentCoverUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: ColorTheme.mainAppColor(),
                                size: 24,
                              ),
                            ),
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addYourPicture,
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
                          AppLocalizations.of(context)!.chooseAFile,
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
              AppLocalizations.of(context)!.coverImage,
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4EFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesGrid() {
    final int totalItems =
        _currentImages.length + _newImages.length + 1; // +1 for Add button

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
        if (index == totalItems - 1) {
          // Last item is Add button
          return _buildAddImageCard();
        }

        if (index < _currentImages.length) {
          // Existing remote image
          return _buildImageCard(
            imageUrl: _currentImages[index].imageUrl,
            isNew: false,
            index: index,
          );
        } else {
          // New local file image
          final localIndex = index - _currentImages.length;
          return _buildImageCard(
            file: _newImages[localIndex],
            isNew: true,
            index: localIndex,
          );
        }
      },
    );
  }

  Widget _buildAddImageCard() {
    return GestureDetector(
      onTap: _pickGridImage,
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

  Widget _buildImageCard({
    String? imageUrl,
    File? file,
    required bool isNew,
    required int index,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade100,
            child: isNew
                ? Image.file(file!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: ColorTheme.mainAppColor(),
                        size: 20,
                      ),
                    ),
                  ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              _showMenuOptions(
                onEdit:
                    _pickGridImage, // Just adds another image for now, or could replace
                onDelete: () => _removeGridImage(index, isNew: isNew),
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

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _hasChanges && !_isSaving ? _saveChanges : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: _isSaving
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 24,
                )
              : Text(
                  AppLocalizations.of(context)!.save,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _hasChanges ? Colors.white : Colors.grey.shade500,
                  ),
                ),
        ),
      ),
    );
  }
}
