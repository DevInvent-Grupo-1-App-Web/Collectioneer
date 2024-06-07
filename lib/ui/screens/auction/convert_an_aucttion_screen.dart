import 'package:flutter/material.dart';

class ConvertAnAuctionScreen extends StatefulWidget {
  const ConvertAnAuctionScreen({super.key});

  @override
  _ConvertAnAuctionScreenState createState() =>
      _ConvertAnAuctionScreenState();
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
          child: Form(
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
                DropdownButtonFormField<String>(
                  value: selectedOption,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Muestra los campos de precio y tiempo si se selecciona Subasta
                if (selectedOption == "Subasta")
                  Column(
                    children: [
                      const Text(
                        "Precio Base:",
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'fontFamily'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Ingresa el precio",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            price = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Tiempo (Hrs):",
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'fontFamily'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Ingresa el tiempo",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            time = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}