import 'package:collectioneer/services/models/post_request.dart';
import 'package:collectioneer/services/post_service.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

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
        title: const Text("Crear publicación"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vista previa aún no disponible")));
              },
              icon: const Icon(Icons.preview_outlined)),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Guardado local aún no disponible")));
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          TextField(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),
            controller: postTitle,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: "Título de tu publicación...",
              border: InputBorder.none,
            ),
          ),
          const Divider(height: 16.0,),
          TextField(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),
            controller: postContent,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            decoration: const InputDecoration(
              hintText: "Escribe aquí...",
              border: InputBorder.none,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(postTitle.text.isEmpty) {
            ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(content: Text("Incluye un título antes de enviar."),)
            );
            return;
          }

          if (postContent.text.isEmpty) {
            ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(content: Text("No puedes compartir una publicación vacía."),)
            );
            return;
          }

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
