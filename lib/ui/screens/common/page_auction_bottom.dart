
import 'package:flutter/material.dart';

enum UserRole { client, author }

class AuctionPage extends StatefulWidget {
  
  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  UserRole _userRole = UserRole.author; // Cambia esto a UserRole.client para probar la vista del cliente
  double _currentBid = 100.0;
  DateTime _auctionEndTime = DateTime.now().add(Duration(hours: 1));
  List<double> _bids = [];
  bool _isEditable = true; // Inicialmente true para permitir la edición

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _userRole == UserRole.client ? _clientBottomSheet() : _authorBottomSheet(),
        );
      },
    );
  }

  Widget _clientBottomSheet() {
    TextEditingController _bidController = TextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Última puja: \$$_currentBid'),
            CountdownTimer(endTime: _auctionEndTime),
            TextField(
              controller: _bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingrese su puja'),
            ),
            ElevatedButton(
              onPressed: () {
                double newBid = double.tryParse(_bidController.text) ?? 0.0;
                if (newBid > _currentBid) {
                  setState(() {
                    _currentBid = newBid;
                    _bids.add(newBid);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Pujar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authorBottomSheet() {
    TextEditingController _initialBidController = TextEditingController(text: _currentBid.toString());
    TextEditingController _timeLimitController = TextEditingController(text: _auctionEndTime.difference(DateTime.now()).inMinutes.toString());

    if (_isEditable) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _initialBidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Puja inicial'),
              ),
              TextField(
                controller: _timeLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Tiempo límite (minutos)'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentBid = double.parse(_initialBidController.text);
                    _auctionEndTime = DateTime.now().add(Duration(minutes: int.parse(_timeLimitController.text)));
                    _isEditable = false; // Establece _isEditable en false aquí
                  });
                  Navigator.pop(context);
                },
                child: Text('Realizar cambios'),
              ),
            ],
          ),
        ),
      );
    } else {
      return _viewOnlyAuthorBottomSheet();
    }
  }

  Widget _viewOnlyAuthorBottomSheet() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Puja inicial: \$${_currentBid.toStringAsFixed(2)}'),
          Text('Tiempo límite: ${_auctionEndTime.difference(DateTime.now()).inMinutes} minutos'),
          Text('Pujas realizadas:'),
          ..._bids.map((bid) => Text('\$${bid.toStringAsFixed(2)}')).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subasta'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showBottomSheet,
          child: Icon(_userRole == UserRole.client ? Icons.attach_money : _bids.isEmpty ? Icons.brush : Icons.visibility),
        ),
      ),
    );
  }
}

class CountdownTimer extends StatelessWidget {
  final DateTime endTime;

  CountdownTimer({required this.endTime});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (context, snapshot) {
        Duration remaining = endTime.difference(DateTime.now());
        if (remaining.isNegative) {
          return Text('La subasta ha terminado');
        } else {
          return Text('${remaining.inMinutes}:${remaining.inSeconds % 60}');
        }
      },
    );
  }
}