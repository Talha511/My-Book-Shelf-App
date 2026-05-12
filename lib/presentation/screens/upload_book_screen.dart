import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_loader.dart';
import '../viewmodels/home_viewmodel.dart';

class UploadBookScreen extends StatefulWidget {
  const UploadBookScreen({super.key});

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  File? _coverImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _categoryCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null) setState(() => _coverImage = File(picked.path));
  }

  void _showImageSourceSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primary),
                title: Text(l10n.pickFromGallery, style: context.ts.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primary),
                title: Text(l10n.pickFromCamera, style: context.ts.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    await context.read<HomeViewModel>().addBook(
          title: _titleCtrl.text.trim(),
          author: _authorCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          imageUrl: _coverImage?.path ?? '',
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: l10n.uploadSuccess,
      text: l10n.uploadSuccessSubtitle,
      confirmBtnColor: AppColors.primary,
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.uploadBook,
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: AppLoader(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.uploadBook, style: context.ts.h2),
                const SizedBox(height: 4),
                Text(l10n.uploadBookSubtitle,
                    style: context.ts.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 28),

                // Cover Image Picker
                Text(l10n.bookCover, style: context.ts.labelMedium),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.accent),
                    ),
                    child: _coverImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_coverImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_outlined,
                                  size: 48, color: AppColors.accent),
                              const SizedBox(height: 8),
                              Text(l10n.bookCover,
                                  style: context.ts.bodySmall.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(l10n.bookTitle, style: context.ts.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleCtrl,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.bookTitleRequired
                      : null,
                  decoration: InputDecoration(
                    hintText: l10n.bookTitleHint,
                    prefixIcon: const Icon(Icons.book_outlined,
                        color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),

                Text(l10n.bookAuthor, style: context.ts.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _authorCtrl,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.bookAuthorRequired
                      : null,
                  decoration: InputDecoration(
                    hintText: l10n.bookAuthorHint,
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),

                Text(l10n.bookCategory, style: context.ts.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _categoryCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.bookCategoryHint,
                    prefixIcon: const Icon(Icons.category_outlined,
                        color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),

                Text(l10n.bookDescription, style: context.ts.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.bookDescriptionRequired
                      : null,
                  decoration: InputDecoration(
                    hintText: l10n.bookDescriptionHint,
                    prefixIcon: const Icon(Icons.description_outlined,
                        color: AppColors.primary),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      disabledBackgroundColor: AppColors.textLigth,
                    ),
                    child: Text(l10n.uploadBook,
                        style: context.ts.labelMedium
                            .copyWith(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
