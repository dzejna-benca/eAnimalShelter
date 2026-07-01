import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/announcement.dart';
import '../models/requests/announcement_insert_request.dart';
import '../models/requests/announcement_update_request.dart';
import '../providers/announcement_provider.dart';
import '../providers/base_provider.dart';
import '../utils/announcement_validator.dart';
import '../utils/message_helper.dart';

class AnnouncementDialog extends StatefulWidget {
  final Announcement? announcement;

  const AnnouncementDialog({
    super.key,
    this.announcement,
  });

  @override
  State<AnnouncementDialog> createState() =>
      _AnnouncementDialogState();
}

class _AnnouncementDialogState
    extends State<AnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  File? selectedImage;
  String? _imageUrl;

  String? get fullImageUrl {
    if (_imageUrl == null ||
        _imageUrl!.isEmpty) {
      return null;
    }

    final apiBase =
        BaseProvider.baseUrl!
            .replaceAll("/api/", "/");

    return "$apiBase${_imageUrl!}";
  }
  bool get isEdit =>
      widget.announcement != null;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.announcement?.title ?? '',
    );

    _contentController = TextEditingController(
      text: widget.announcement?.content ?? '',
    );

    _imageUrl =
        widget.announcement?.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();

      final image =
          await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      setState(() {
        selectedImage = File(image.path);
      });
      if (!mounted) return;
      
      final uploadedPath =
          await context
              .read<AnnouncementProvider>()
              .uploadImage(
                selectedImage!,
              );

      setState(() {
        _imageUrl = uploadedPath;
      });
    } catch (e) {
      if (!mounted) return;

      MessageHelper.showError(
        context,
        e.toString(),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    try {
      final provider =
          context.read<AnnouncementProvider>();

      if (isEdit) {
        await provider.update(
          widget.announcement!.announcementId,
          AnnouncementUpdateRequest(
            title:
                _titleController.text.trim(),
            content:
                _contentController.text.trim(),
            imageUrl: _imageUrl,
            isActive:
                widget.announcement!.isActive,
          ).toJson(),
        );
      } else {
        await provider.insert(
          AnnouncementInsertRequest(
            title:
                _titleController.text.trim(),
            content:
                _contentController.text.trim(),
            imageUrl: _imageUrl,
          ).toJson(),
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      MessageHelper.showError(
        context,
        e.toString(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 700,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEdit
                          ? "Edit News"
                          : "Add News",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      validator:
                          AnnouncementValidator.validateTitle,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Content",
                      ),
                      validator:
                          AnnouncementValidator.validateContent,
                    ),

                    const SizedBox(height: 20),

                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else if (_imageUrl != null &&
                        _imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12),
                        child: Image.network(
                          fullImageUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                            height: 180,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image,
                              size: 60,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.photo_library,
                        ),
                        label: Text(
                          _imageUrl == null
                              ? "Select Image"
                              : "Change Image",
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () =>
                              Navigator.pop(
                            context,
                          ),
                          child: const Text(
                            "Cancel",
                          ),
                        ),

                        const SizedBox(width: 10),

                        ElevatedButton(
                          onPressed: _save,
                          child: Text(
                            isEdit
                                ? "Save"
                                : "Add",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}