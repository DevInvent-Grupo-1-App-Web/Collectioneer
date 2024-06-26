import 'package:collectioneer/dao/favourites_dao.dart';
import 'package:collectioneer/models/element_type.dart';
import 'package:collectioneer/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:collectioneer/ui/screens/common/interactions_bottom_sheet.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../../models/post.dart';

class ViewPostScreen extends StatefulWidget {
  const ViewPostScreen({super.key});

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  final int postId = UserPreferences().getActiveElement();
  late Post post;
  bool isLoading = true;
  late bool isFavourite = false;

  void _checkFavourite() async {
    isFavourite = await FavouritesDao().isFavourite(postId, ElementType.post);
  }

  @override
  void initState() {
    super.initState();
    _checkFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PostService().getPost(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              appBar: AppTopBar(
                title: "Cargando...",
                allowBack: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        } else if (snapshot.hasError) {
          return Text('Error al mostrar: ${snapshot.error}');
        } else {
          if (snapshot.data == null) {
            _exitInError("Sin datos disponibles", context);
          }
          post = snapshot.data!;

          return Scaffold(
            appBar: AppTopBar(
              title: post.title, 
              allowBack: true,
              actions: [
                IconButton(
                  onPressed: () async
                  {
                    if (isFavourite) {
                      await FavouritesDao().removeFavourite(postId, ElementType.post);
                    } else {
                      await FavouritesDao().addFavourite(postId, ElementType.post);
                    }
                    setState(() {
                      isFavourite = !isFavourite;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavourite ? "Añadido a guardados" : "Eliminado de guardados"),
                        duration: const Duration(seconds: 2),
                      )
                    );
                  }
                , icon: Icon(isFavourite ? Icons.bookmark : Icons.bookmark_add_outlined)
                )
              ],),
            body: Padding(
                padding: const EdgeInsets.all(32),
                child: ListView(
                  children: [
                    buildMarkdown(post.content),
                    const Divider(height: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${post.authorId.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Text(
                            DateFormat('yMMMd').format(post.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ]),
                  ],
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showCommentBottomSheet(context);
              },
              child: const Icon(Icons.comment),
            ),
          );
        }
      },
    );
  }

  Widget buildMarkdown(String content) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return MarkdownBody(
      data: content,
      styleSheet: MarkdownStyleSheet(
          p: TextStyle(color: isDark ? Colors.white : Colors.black)),
    );
  }

  void _exitInError(String error, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showCommentBottomSheet(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxHeight = screenHeight * 0.8;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const InteractionBottomSheet(type: ElementType.post));
      },
    );
  }
}
