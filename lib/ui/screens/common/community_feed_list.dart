import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/collectible_feed_view.dart';
import 'package:flutter/material.dart';

class CommunityFeedList extends StatefulWidget {
  const CommunityFeedList({super.key});

  @override
  State<CommunityFeedList> createState() => _CommunityFeedListState();
}

class _CommunityFeedListState extends State<CommunityFeedList> {
  List<FeedItem> _feed = [];
  final _communityService = CommunityService();

  void _loadFeed() async {
    final feed = await _communityService.getCommunityFeed();
    setState(() {
      _feed = feed;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  @override
  Widget build(BuildContext context) {
    return _feed.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 32),
            itemCount: _feed.length,
            itemBuilder: (context, index) {
              return CollectibleFeedView(
                  sourceItem: _feed[index],
                  width: MediaQuery.of(context).size.width);
            },
          );
  }
}
