import 'package:collectioneer/models/comment.dart';
import 'package:collectioneer/models/element_type.dart';
import 'package:collectioneer/services/comment_service.dart';
import 'package:collectioneer/services/models/comment_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class InteractionBottomSheet extends StatefulWidget {
  const InteractionBottomSheet({super.key, required this.type});
  final ElementType type;

  @override
  _InteractionBottomSheetState createState() => _InteractionBottomSheetState();
}

class _InteractionBottomSheetState extends State<InteractionBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CommentScreen(type: widget.type),
    );
  }
}

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.type});
  final ElementType type;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: CommentsList(type: widget.type,),
        ),
        CommentInput(type: widget.type,),
      ],
    );
  }
}

class CommentInput extends StatefulWidget {
  const CommentInput({super.key, required this.type});
  final ElementType type;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Escribe un comentario...',
            ),
            controller: _controller,
          ),
        ),
        const SizedBox(width: 8,),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () async {
            if (_controller.text.isNotEmpty) {
              final comment = CommentRequest(
                authorId: UserPreferences().getUserId(),
                content: _controller.text,
              );
              
              if (widget.type == ElementType.collectible) {
                await CommentService().postCollectibleComment(UserPreferences().getActiveElement() ,comment);
              } else {
                await CommentService().postPostComment(UserPreferences().getActiveElement() ,comment);
              }

              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}

class CommentsList extends StatefulWidget {
  const CommentsList({super.key, required this.type});
  final ElementType type;

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  late List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.type == ElementType.collectible ? CommentService()
          .getCollectibleComments(UserPreferences().getActiveElement()) : CommentService().getPostComments(UserPreferences().getActiveElement()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          comments = snapshot.data as List<Comment>;
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            comment.authorName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(comment.body),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

