import 'package:collectioneer/dao/post_dao.dart';
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

  retrieveSavedPost() async {
    var post = await PostDao().fetch();

    if (post.isEmpty) {
      return;
    }

    setState(() {
      postTitle.text = post[0]['title'];
      postContent.text = post[0]['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (postTitle.text.isEmpty && postContent.text.isEmpty) {
      retrieveSavedPost();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear publicación"),
        leading: IconButton(
            onPressed: () {
              if (postContent.text.isNotEmpty && postTitle.text.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("¿Estás seguro de que quieres salir?"),
                      content: const Text("Tu publicación no se guardará."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () {
                            
                           PostDao().deleteAll();
                            Navigator.pop(context);
                            Navigator.pop(
                                context);
                          },
                          child: const Text("Salir"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () async {
              await PostDao().insert(postTitle.text, postContent.text);

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Publicación guardada")));

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          TextField(
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            controller: postTitle,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: "Título de tu publicación...",
              border: InputBorder.none,
            ),
          ),
          const Divider(
            height: 16.0,
          ),
          TextField(
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
          if (postTitle.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Incluye un título antes de enviar."),
            ));
            return;
          }

          if (postContent.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No puedes compartir una publicación vacía."),
            ));
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

          PostDao().deleteAll();
        },
        child: const Icon(Icons.publish),
      ),
    );
  }
}
