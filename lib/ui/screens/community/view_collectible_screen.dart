import 'dart:developer';

import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/services/collectible_service.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';

class ViewCollectibleScreen extends StatefulWidget {
  const ViewCollectibleScreen({super.key});

  @override
  State<ViewCollectibleScreen> createState() => _ViewCollectibleScreenState();
}

class _ViewCollectibleScreenState extends State<ViewCollectibleScreen> {
  final int collectibleId = 3;
  Collectible? collectible;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    CollectibleService().getCollectible(collectibleId).then((value) {
      setState(() {
        collectible = value;
        isLoading = false;
      });
    }).catchError((error) {
      log('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: collectible?.name ?? 'Collectible',
        allowBack: true,
      ),
      body: ListView(
              children: [
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(collectible?.name ?? ''),
                ),
                ListTile(
                  title: const Text('Description'),
                  subtitle: Text(collectible?.description ?? ''),
                ),
                ListTile(
                  title: const Text('Value'),
                  subtitle: Text(collectible?.value.toString() ?? ''),
                ),
              ],
            )

    );
  }
}
