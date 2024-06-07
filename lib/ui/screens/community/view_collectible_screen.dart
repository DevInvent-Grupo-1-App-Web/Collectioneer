import 'dart:developer';

import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/services/collectible_service.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class ViewCollectibleScreen extends StatefulWidget {
  const ViewCollectibleScreen({super.key});

  @override
  State<ViewCollectibleScreen> createState() => _ViewCollectibleScreenState();
}

class _ViewCollectibleScreenState extends State<ViewCollectibleScreen> {
  final int collectibleId = UserPreferences().getCollectibleId();
  Collectible? collectible;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    log('Collectible ID: $collectibleId');
    return FutureBuilder<Collectible>(
      future: CollectibleService().getCollectible(collectibleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text('Error on displaying: ${snapshot.error}')));
        } else {
          final collectible = snapshot.data;
          return Scaffold(
            appBar: AppTopBar(
              title: collectible?.name ?? 'Not found',
              allowBack: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView(
                children: [
                  Image.network(
                      "https://collectioneer.blob.core.windows.net/collectioneer-multimedia/1/man.jpg"),
                      const SizedBox(height: 16),
                  Text(collectible?.name ?? 'Not found',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    "@userhandle",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text("4.8", style: Theme.of(context).textTheme.titleMedium,),
                          Text(" (126)", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.comment, color: Theme.of(context).colorScheme.primary),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 48,),
                  Text("Descripción", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(collectible?.description ?? 'No description', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
