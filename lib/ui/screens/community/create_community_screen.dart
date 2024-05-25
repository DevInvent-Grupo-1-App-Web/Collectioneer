import 'dart:developer';

import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                TextFormField(
                  controller: _communityNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la Comunidad', filled: true),
                ),
                const SizedBox(height: 36.0),
                TextFormField(
                  controller: _communityDescriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Descripción de la Comunidad', filled: true),
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
                      log('Creación de comunidad fallida: $e');
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