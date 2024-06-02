import 'package:flutter/material.dart';

class AuctionParticipationScreen extends StatefulWidget {
  const AuctionParticipationScreen({Key? key}) : super(key: key);

  @override
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
        title: Center(
          child: Text(
            "Detalles",
            style: TextStyle(fontSize: 22),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            SizedBox(height: 16),
            Text(
              "Stormtrooper | Lego",
              style: TextStyle(fontSize: 16),
            ),
            Text(
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
                SizedBox(width: 8),
                Text(
                  "4.8",
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Image.asset(
                  'assets/images/comment.png',
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
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
            SizedBox(height: 40),
            Text(
              "Descripción",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Esta es la sexta versión de esta emblemática figura, perfecta para agregar a tu colección y exhibir con orgullo",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
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
                  child: Text("Pujar"),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showOfferDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Realizar Oferta"),
          content: TextField(
            controller: _offerController,
            decoration: InputDecoration(
              labelText: 'Ingrese su oferta',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                if (_offerController.text.isNotEmpty) {
                  setState(() {
                    price = "S/. " + _offerController.text;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    ).then((_) {
      _offerController.clear(); // Clear the text field after dialog is closed
    });
  }
}