import 'package:collectioneer/models/comment.dart';
import 'package:collectioneer/models/element_type.dart';
import 'package:collectioneer/models/review.dart';
import 'package:collectioneer/services/comment_service.dart';
import 'package:collectioneer/services/models/comment_request.dart';
import 'package:collectioneer/services/models/review_request.dart';
import 'package:collectioneer/services/review_service.dart';
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
    return widget.type == ElementType.collectible ? 
    DoubleInteraction(type: widget.type) : CommentScreen(type: widget.type);
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: CommentsList(type: widget.type,),
          ),
          CommentInput(type: widget.type,),
        ],
      ),
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

class DoubleInteraction extends StatefulWidget {
  const DoubleInteraction({super.key, required this.type});
  final ElementType type;

  @override
  State<DoubleInteraction> createState() => _DoubleInteractionState();
}

class _DoubleInteractionState extends State<DoubleInteraction> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Comentarios'),
            Tab(text: 'Reseñas'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              CommentScreen(type: widget.type),
              ReviewScreen()
            ],
          ),
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
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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

class ReviewsList extends StatefulWidget {
  const ReviewsList({super.key});

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReviewService().getReviewsForCollectible(UserPreferences().getActiveElement()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final reviews = snapshot.data as List<Review>;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userId.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(review.content),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          if (index < review.rating) {
                            return Icon(Icons.star, size: 16, color: Theme.of(context).colorScheme.primary);
                          } else {
                            return Icon(Icons.star_outline, size: 16, color: Theme.of(context).colorScheme.primary);
                          }
                        }),
                      )
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

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ReviewsList(),
          ),
          ReviewInput(),
        ],
      ),
    );
  }
}

class ReviewInput extends StatefulWidget {
  const ReviewInput({super.key});

  @override
  State<ReviewInput> createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInput> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children:
          List.generate(
            5,
            (index) => IconButton(
              icon: Icon(index < _rating ? Icons.star : Icons.star_outline),
              color: index < 5 ? Theme.of(context).colorScheme.primary : null,
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            ),
          )
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Escribe una reseña...',
                ),
                controller: _controller,
              ),
            ),
            const SizedBox(width: 8,),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  final review = ReviewRequest(
                    reviewerId: UserPreferences().getUserId(),
                    collectibleId: UserPreferences().getActiveElement(),
                    content: _controller.text,
                    rating: _rating
                  );
                  
                  await ReviewService().postReview(review);
        
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}