import 'dart:developer';
import 'dart:io';
import 'package:collectioneer/services/collectible_service.dart';
import 'package:collectioneer/services/models/collectible_request.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateCollectibleScreen extends StatefulWidget {
  const CreateCollectibleScreen({super.key});

  @override
  State<CreateCollectibleScreen> createState() =>
      _CreateCollectibleScreenState();
}

class _CreateCollectibleScreenState extends State<CreateCollectibleScreen> {
  final GlobalKey<_CreateCollectibleFormState> _formKey = GlobalKey();
  final CollectibleService _collectibleService = CollectibleService();

  void showExitModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Discard changes?"),
          content: const Text("Are you sure you want to discard the changes?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Discard"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> postCollectible() async {
    final CollectibleRequest request =
        _formKey.currentState!.getCollectibleRequest();
    return await _collectibleService.createCollectible(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: "Create collectionable",
        allowBack: true,
        onBack: showExitModal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreateCollectibleForm(key: _formKey),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postCollectible();
          Navigator.pop(context);
          log("Save collectible");
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class CreateCollectibleForm extends StatefulWidget {
  const CreateCollectibleForm({super.key});

  @override
  State<CreateCollectibleForm> createState() => _CreateCollectibleFormState();
}

class _CreateCollectibleFormState extends State<CreateCollectibleForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  CollectibleRequest getCollectibleRequest() {
    return CollectibleRequest(
      name: _titleController.text,
      description: _descriptionController.text,
      value: double.parse(_priceController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CollectiblePictureSelector(),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: "Title",
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            prefixText: _priceController.text.isEmpty ? "S/ " : null,
            hintText: "Precio",
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Description",
          ),
        ),
      ],
    );
  }
}

class CollectiblePictureSelector extends StatefulWidget {
  const CollectiblePictureSelector({super.key});

  @override
  State<CollectiblePictureSelector> createState() =>
      _CollectiblePictureSelectorState();
}

class _CollectiblePictureSelectorState
    extends State<CollectiblePictureSelector> {
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
                      FilledButton.icon(
                        icon: const Icon(Icons.photo_camera),
                        label: const Text("Take a photo"),
                        onPressed: _pickImageFromCamera,
                      ),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
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