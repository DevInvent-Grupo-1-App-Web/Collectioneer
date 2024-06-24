import 'package:collectioneer/services/models/post_request.dart';
import 'package:collectioneer/services/post_service.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController postTitle = TextEditingController();
  final TextEditingController postContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Preview not available")));
              },
              icon: const Icon(Icons.preview_outlined)),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Local save not available")));
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          TextField(
            controller: postContent,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            decoration: const InputDecoration(
              hintText: "Write your post here...",
              border: InputBorder.none,
            ),
          ),
          TextField(
            controller: postTitle,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            decoration: const InputDecoration(
              hintText: "Write your post here...",
              border: InputBorder.none,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PostRequest request = PostRequest(
              title: postTitle.text,
              content: postContent.text,
              communityId: UserPreferences().getLatestActiveCommunity()!,
              authorId: UserPreferences().getUserId());

          PostService().postPost(request).then((value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Post created")));
          });
        },
        child: const Icon(Icons.publish),
      ),
    );
  }
}
