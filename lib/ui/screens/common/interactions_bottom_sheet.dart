import 'package:flutter/material.dart';

class CommentsBottomSheet extends StatefulWidget {

  const CommentsBottomSheet({
    super.key
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
            children: const [
              CommentsList(),
              ReviewsList(),
            ],
          ),
        ),
        if (_selectedIndex == 0) _buildCommentForm(),
        if (_selectedIndex == 1) _buildReviewForm(),
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
          child: Row(
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
          child: Row(
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
                      decoration: const InputDecoration(
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
        /*
        comments.add({
          'text': commentText,
          'image': 'URL_de_la_imagen',
          'username': username,
        });
         */
        _commentController.clear();
      });
      FocusScope.of(context).unfocus(); // Ocultar el teclado
    }
  }

  void _addReview(String username) {
    final String reviewText = _reviewController.text.trim();
    if (reviewText.isNotEmpty && _rating > 0) {
      setState(() {
        /*
        widget.reviews.add({
          'text': reviewText,
          'image': 'URL_de_la_imagen',
          'username': username,
          'rating': _rating,
        });
         */
        _reviewController.clear();
        _rating = 0; // Restablecer la calificación después de agregar la reseña
      });
      FocusScope.of(context).unfocus(); // Ocultar el teclado
    }
  }
}

class CommentsList extends StatefulWidget {

  const CommentsList({super.key});

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  List<Map<String, String>> comments = List.empty();

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

class ReviewsList extends StatefulWidget {

  const ReviewsList({super.key});

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  List<Map<String, dynamic>> reviews = List.empty();

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
