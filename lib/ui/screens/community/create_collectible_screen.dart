import 'dart:convert';
import 'dart:io';
import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/services/collectible_service.dart';
import 'package:collectioneer/services/media_service.dart';
import 'package:collectioneer/services/models/collectible_request.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CreateCollectibleScreen extends StatefulWidget {
  const CreateCollectibleScreen({super.key});

  @override
  State<CreateCollectibleScreen> createState() =>
      _CreateCollectibleScreenState();
}

class _CreateCollectibleScreenState extends State<CreateCollectibleScreen> {
  final GlobalKey<_CreateCollectibleFormState> _formKey = GlobalKey();
  final CollectibleService _collectibleService = CollectibleService();
  File? _imageFile;

  void onImagePicked(File pickedImage) {
    _imageFile = pickedImage;
  }

  void showExitModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¿Descartar cambios?",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
          content: Text(
            "¿Quieres descartas los cambios que hiciste? No podrás recuperarlos.",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Descartar"),
            ),
          ],
        );
      },
    );
  }

  Future<Collectible> postCollectible() async {
    final CollectibleRequest request =
        _formKey.currentState!.getCollectibleRequest();
    var collectible = await _collectibleService.createCollectible(request);
    UserPreferences().setActiveElement(collectible.id);
    return collectible;
  }

  Future postMedia(
      File imageFile, int collectibleId, String collectibleName) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    await MediaService().uploadMedia(collectibleName, base64Image, "image/jpeg",
        collectibleId, "collectible");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: "Crear coleccionable",
        allowBack: true,
        onBack: showExitModal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreateCollectibleForm(
                  key: _formKey, onImagePicked: onImagePicked),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_imageFile == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Por favor, selecciona una imagen."),
              ),
            );
            return;
          }

          var collectible = await postCollectible();
          String filename = path.basename(_imageFile!.path);
          postMedia(_imageFile!, collectible.id, filename);
          if (mounted) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class CreateCollectibleForm extends StatefulWidget {
  const CreateCollectibleForm({super.key, required this.onImagePicked});
  final Function(File) onImagePicked;

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
        CollectiblePictureSelector(onImagePicked: widget.onImagePicked),
        TextField(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: "Nombre del coleccionable",
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
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
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          controller: _descriptionController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Descriptción",
          ),
        ),
      ],
    );
  }
}

class CollectiblePictureSelector extends StatefulWidget {
  const CollectiblePictureSelector({super.key, required this.onImagePicked});
  final Function(File) onImagePicked;

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
      widget.onImagePicked(File(image.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      widget.onImagePicked(File(image.path));
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
                        label: const Text("Cámara"),
                        onPressed: _pickImageFromCamera,
                      ),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Escoger de la galería"),
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
