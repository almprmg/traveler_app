import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path/path.dart' as path;
import 'package:traveler_app/base/app_bottom_sheet.dart';
import 'package:traveler_app/base/custom_snackbar.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class FileHelper {
  static const int maxFileSizeInBytes = 2 * 1024 * 1024; // 2MB
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from gallery
  static Future<SelectedFile?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return await _processImageFile(pickedFile);
      }
      return null;
    } catch (e) {
      _showErrorSnackbar(
        '${'error_picking_image_from_gallery'.tr}: ${e.toString()}',
      );
      return null;
    }
  }

  /// Take photo from camera
  static Future<SelectedFile?> takePhotoFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return await _processImageFile(pickedFile);
      }
      return null;
    } catch (e) {
      _showErrorSnackbar(
        '${'error_taking_photo_from_camera'.tr}: ${e.toString()}',
      );
      return null;
    }
  }

  /// Pick PDF document
  static Future<SelectedFile?> pickPdfDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true, // Important for Web and avoiding File(path)
      );

      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;

        // Check file size
        if (file.size > maxFileSizeInBytes) {
          _showErrorSnackbar(
            '${'file_size_exceeds_limit'.tr}. ${'selected_file'.tr}: ${_formatFileSize(file.size)}',
          );
          return null;
        }

        // Get file bytes
        Uint8List? fileBytes = file.bytes;

        if (fileBytes != null) {
          return SelectedFile(
            name: file.name,
            bytes: fileBytes,
            size: file.size,
            type: FileType.custom,
            mimeType: 'application/pdf',
          );
        }
      }
      return null;
    } catch (e) {
      _showErrorSnackbar('${'error_picking_pdf_document'.tr}: ${e.toString()}');
      return null;
    }
  }

  /// Pick any document (images, PDFs, etc.)
  static Future<SelectedFile?> pickAnyDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'gif'],
        allowMultiple: false,
        withData: true, // Important for Web and avoiding File(path)
      );

      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;

        // Check file size
        if (file.size > maxFileSizeInBytes) {
          _showErrorSnackbar(
            '${'file_size_exceeds_limit'.tr}. ${'selected_file'.tr}: ${_formatFileSize(file.size)}',
          );
          return null;
        }

        // Get file bytes
        Uint8List? fileBytes = file.bytes;

        if (fileBytes != null) {
          String mimeType = _getMimeType(file.extension ?? '');

          return SelectedFile(
            name: file.name,
            bytes: fileBytes,
            size: file.size,
            type: _getFileTypeFromExtension(file.extension ?? ''),
            mimeType: mimeType,
          );
        }
      }
      return null;
    } catch (e) {
      _showErrorSnackbar('${'error_picking_document'.tr}: ${e.toString()}');
      return null;
    }
  }

  /// Show file selection options bottom sheet
  static void showFileSelectionBottomSheet({
    required Function(SelectedFile) onFileSelected,
    bool showCamera = true,
    bool showGallery = true,
    bool showDocuments = true,
  }) {
    Get.bottomSheet(
      AppBottomSheet(
        title: 'select_file'.tr,
        shrinkContent: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacing16,
            AppTheme.spacing12,
            AppTheme.spacing16,
            AppTheme.spacing16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCamera) ...[
                _buildOptionTile(
                  icon: HugeIcons.strokeRoundedCamera01,
                  title: 'take_photo'.tr,
                  subtitle: 'capture_using_camera'.tr,
                  onTap: () async {
                    Get.back();
                    final file = await takePhotoFromCamera();
                    if (file != null) onFileSelected(file);
                  },
                ),
                const SizedBox(height: 8),
              ],
              if (showGallery) ...[
                _buildOptionTile(
                  icon: HugeIcons.strokeRoundedImage02,
                  title: 'choose_from_gallery'.tr,
                  subtitle: 'select_image_from_gallery'.tr,
                  onTap: () async {
                    Get.back();
                    final file = await pickImageFromGallery();
                    if (file != null) onFileSelected(file);
                  },
                ),
                const SizedBox(height: 8),
              ],
              if (showDocuments)
                _buildOptionTile(
                  icon: HugeIcons.strokeRoundedFile01,
                  title: 'choose_document'.tr,
                  subtitle: 'select_pdf_or_image_file'.tr,
                  onTap: () async {
                    Get.back();
                    final file = await pickAnyDocument();
                    if (file != null) onFileSelected(file);
                  },
                ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Private helper methods
  static Future<SelectedFile?> _processImageFile(XFile pickedFile) async {
    final int fileSize = await pickedFile.length();

    // Check file size
    if (fileSize > maxFileSizeInBytes) {
      _showErrorSnackbar(
        '${'image_size_exceeds_limit'.tr}. ${'selected_image'.tr}: ${_formatFileSize(fileSize)}',
      );
      return null;
    }

    final Uint8List fileBytes = await pickedFile.readAsBytes();
    final String fileName = pickedFile.name;
    // Use mimeType from XFile if available, otherwise try to guess from name
    String mimeType = pickedFile.mimeType ?? '';
    if (mimeType.isEmpty) {
      mimeType = _getMimeTypeFromPath(fileName);
    }

    return SelectedFile(
      name: fileName,
      bytes: fileBytes,
      size: fileSize,
      type: FileType.image,
      mimeType: mimeType,
    );
  }

  static Widget _buildOptionTile({
    required List<List<dynamic>> icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radius12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: HugeIcon(
                  icon: icon,
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.withColor(
                        AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.withColor(
                        AppTypography.bodySmall,
                        AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              HugeIcon(
                icon: Get.find<LocalizationController>().isLtr
                    ? HugeIcons.strokeRoundedArrowRight01
                    : HugeIcons.strokeRoundedArrowLeft01,
                color: AppTheme.textTertiary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showErrorSnackbar(String message) {
    GlobalSnackBar.show(message, SnackType.error);
  }

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  static String _getMimeTypeFromPath(String filePath) {
    final String extension = path.extension(filePath).toLowerCase();
    return _getMimeType(extension.replaceFirst('.', ''));
  }

  static FileType _getFileTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return FileType.image;
      case 'pdf':
        return FileType.custom;
      default:
        return FileType.any;
    }
  }
}

/// Model class for selected file
class SelectedFile {
  final String name;
  final Uint8List bytes;
  final int size;
  final FileType type;
  final String mimeType;

  SelectedFile({
    required this.name,
    required this.bytes,
    required this.size,
    required this.type,
    required this.mimeType,
  });

  String get sizeFormatted => FileHelper._formatFileSize(size);

  bool get isImage => type == FileType.image;
  bool get isPdf => mimeType == 'application/pdf';
}
