import 'package:flutter/material.dart';

class ConvertAnAuctionScreen extends StatefulWidget {
  const ConvertAnAuctionScreen({Key? key}) : super(key: key);

  @override
  _ConvertAnAuctionScreenState createState() => _ConvertAnAuctionScreenState();
}

class _ConvertAnAuctionScreenState extends State<ConvertAnAuctionScreen> {
  String selectedOption = "Ninguna";
  List<String> items = ["Ninguna", "Subasta", "Venta"];
  String price = "";
  String time = "";
  String priceSale = "";
  String title = "Stormtrooper | Lego";
  String description =
      "Esta es la sexta versión de esta emblemática figura, perfecta para agregar a tu colección y exhibir con orgullo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Editar",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontFamily: 'fontFamily'),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.zero),
                  child: Image.asset(
                    'assets/images/sample_image.jpg',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Título",
                style: TextStyle(fontSize: 18, fontFamily: 'fontFamily'),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontFamily: 'fontFamily'),
              ),
              const SizedBox(height: 20),
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 18, fontFamily: 'fontFamily'),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16, fontFamily: 'fontFamily'),
              ),
              const SizedBox(height: 20),
              const Text(
                "Estado",
                style: TextStyle(fontSize: 18, fontFamily: 'fontFamily'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
