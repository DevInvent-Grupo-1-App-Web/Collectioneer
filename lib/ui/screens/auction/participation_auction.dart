import 'package:flutter/material.dart';

class AuctionParticipationScreen extends StatefulWidget {
  const AuctionParticipationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuctionParticipationScreenState createState() =>
      _AuctionParticipationScreenState();
}

class _AuctionParticipationScreenState extends State<AuctionParticipationScreen> {
  String price = "S/. 4 750.00";
  final TextEditingController _offerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Detalles",
            style: TextStyle(fontSize: 22),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  'assets/images/sample_image.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Stormtrooper | Lego",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "@userhandle",
              style: TextStyle(fontSize: 11),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/star.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "4.8",
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/comment.png',
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Última oferta",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "S/ 4500",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Acaba en:",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "13 hrs",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Descripción",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "Esta es la sexta versión de esta emblemática figura, perfecta para agregar a tu colección y exhibir con orgullo",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _showOfferDialog();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(price),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showOfferDialog();
                  },
                  child: const Text("Pujar"),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

void _showOfferDialog() {
  showDialog(
    context: context, // This is correct
    builder: (BuildContext dialogContext) { // Use this context
      return AlertDialog(
        title: const Text("Realizar Oferta"),
        content: TextField(
          controller: _offerController,
          decoration: const InputDecoration(
            labelText: 'Ingrese su oferta',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Use dialogContext
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              if (_offerController.text.isNotEmpty) {
                setState(() {
                  price = "S/. ${_offerController.text}";
                });
              }
              Navigator.of(dialogContext).pop(); // Use dialogContext
            },
            child: const Text("Aceptar"),
          ),
        ],
      );
    },
  ).then((_) {
    _offerController.clear(); // Clear the text field after dialog is closed
  });
}}