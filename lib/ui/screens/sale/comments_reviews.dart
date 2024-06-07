import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BottomSheet Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showBottomSheet(BuildContext context) async {
  List<Map<String, String>> comments = await _loadSavedComments();
  List<Map<String, dynamic>> reviews = []; // Aquí se almacenarán las reseñas con calificaciones

  double screenHeight = MediaQuery.of(context).size.height;
  double maxHeight = screenHeight * 0.8; // Establecer una fracción del tamaño de la pantalla como altura máxima

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CommentsBottomSheet(
          comments: comments,
          reviews: reviews,
        ),
      );
    },
  );
}


  Future<List<Map<String, String>>> _loadSavedComments() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedComments = prefs.getString('comments');
    if (savedComments != null) {
      List<dynamic> decodedComments = json.decode(savedComments);
      return decodedComments.map((item) {
        return Map<String, String>.from(item);
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter BottomSheet Example'),
      ),
      body: Center(
        child: ElevatedButton(
          
          onPressed: () => _showBottomSheet(context),
          child: const Text('Show BottomSheet'),
        ),
      ),
    );
  }
}

class CommentsBottomSheet extends StatefulWidget {
  final List<Map<String, String>> comments;
  final List<Map<String, dynamic>> reviews;

  const CommentsBottomSheet({
   super.key,
    required this.comments,
    required this.reviews,
  });

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  late int _selectedIndex;
  late PageController _pageController;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: 'Comentarios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Reseñas',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              CommentsList(comments: widget.comments),
              ReviewsList(reviews: widget.reviews),
            ],
          ),
        ),
        if (_selectedIndex == 0)
          _buildCommentForm(),
        if (_selectedIndex == 1)
          _buildReviewForm(),
      ],
    );
  }

  Widget _buildCommentForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre de Usuario',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('URL_de_la_imagen'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _commentController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            hintText: 'Agregar comentario...',
                            border: InputBorder.none,
                          ),
                        ),
                      ],

                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _addComment('Nombre de Usuario'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre de Usuario',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('URL_de_la_imagen'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _reviewController,
                          maxLength: 300,
                          decoration: const  InputDecoration(
                            hintText: 'Agregar reseña...',
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRatingStars(),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _addReview('Nombre de Usuario'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _setRating(1),
          icon: Icon(_rating >= 1 ? Icons.star : Icons.star_border),
          color: _rating >= 1 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => _setRating(2),
          icon: Icon(_rating >= 2 ? Icons.star : Icons.star_border),
          color: _rating >= 2 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => _setRating(3),
          icon: Icon(_rating >= 3 ? Icons.star : Icons.star_border),
          color: _rating >= 3 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => _setRating(4),
          icon: Icon(_rating >= 4 ? Icons.star : Icons.star_border),
          color: _rating >= 4 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => _setRating(5),
          icon: Icon(_rating >= 5 ? Icons.star : Icons.star_border),
          color: _rating >= 5 ? Colors.yellow : null,
        ),
      ],
    );
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

void _addComment(String username) {
  final String commentText = _commentController.text.trim();
  if (commentText.isNotEmpty) {
    setState(() {
      widget.comments.add({
        'text': commentText,
        'image': 'URL_de_la_imagen',
        'username': username,
      });
      _commentController.clear();
    });
    FocusScope.of(context).unfocus(); // Ocultar el teclado
  }
}

void _addReview(String username) {
  final String reviewText = _reviewController.text.trim();
  if (reviewText.isNotEmpty && _rating > 0) {
    setState(() {
      widget.reviews.add({
        'text': reviewText,
        'image': 'URL_de_la_imagen',
        'username': username,
        'rating': _rating,
      });
      _reviewController.clear();
      _rating = 0; // Restablecer la calificación después de agregar la reseña
    });
    FocusScope.of(context).unfocus(); // Ocultar el teclado
  }
}
}

class CommentsList extends StatelessWidget {
  final List<Map<String, String>> comments;

  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment['image']!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['username']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(comment['text']!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReviewsList extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(review['image']),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      review['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    _buildRatingStars(review['rating']),
                  ],
                ),
                const SizedBox(height: 8),
                Text(review['text']),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.yellow : null,
        ),
      ),
    );
  }
}
