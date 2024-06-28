import 'dart:developer';
import 'dart:io';

import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final TextEditingController _communityNameController = TextEditingController();
  final TextEditingController _communityDescriptionController = TextEditingController();

  Future<bool> _createCommunity() async {
    final String communityName = _communityNameController.text;
    final String communityDescription = _communityDescriptionController.text;

    try {
      await CommunityService().createCommunity(communityName, communityDescription);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create community: $e'),
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Comunidad'),
        centerTitle: true,
      ), 
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ListView(
          children: [
            const CommunityPictureSelector(
              key: Key('community_picture_selector'),

            ),
            const SizedBox(height: 36.0),
            Column(
              children: [
                TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _communityNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la Comunidad', filled: true),
                ),
                const SizedBox(height: 36.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  minLines: 5,
                  maxLines: null,
                  controller: _communityDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de la Comunidad', 
                    filled: true,
                    alignLabelWithHint: true, // Aligns the label with the top line
                  ),
                ),
                const SizedBox(height: 36.0),
                FilledButton(
                  onPressed: () async {
                    try {
                      if (await _createCommunity()) {
                        if (mounted) {
                          navigateTo(AppRoutes.home);
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to create community: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Crear Comunidad'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }
}
class CommunityPictureSelector extends StatefulWidget {
  const CommunityPictureSelector({super.key});

  @override
  State<CommunityPictureSelector> createState() => _CommunityPictureSelectorState();
}

class _CommunityPictureSelectorState extends State<CommunityPictureSelector> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        height: 240,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_image != null)
                Image.file(
                  File(_image!.path),
                  fit: BoxFit.fill,
                ),
              if (_image == null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo_camera),
                        label: const Text("Take a photo"),
                        onPressed: _pickImageFromCamera,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Choose from gallery"),
                        onPressed: _pickImageFromGallery,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}