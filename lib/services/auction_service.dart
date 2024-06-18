import 'dart:convert';
import 'dart:developer';
import 'package:collectioneer/models/auction.dart';
import 'package:collectioneer/models/bid.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/services/models/bid_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

import 'models/auction_request.dart';

class AuctionService extends BaseService {
  static final AuctionService _singleton = AuctionService._internal();

  factory AuctionService() {
    return _singleton;
  }

  AuctionService._internal();

  Future<Auction?> getAuction({auctionId = int}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auctions/$auctionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    
    return Auction.fromJson(jsonDecode(response.body));
  }

  Future<Auction> postAuction({request = AuctionRequest}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auctions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode > 299) {
      log(response.statusCode.toString());
      throw Exception(response.body);
    }

    return Auction.fromJson(jsonDecode(response.body));
  }

  Future<Bid?> postBid({request = BidRequest}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auctions/bids'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return Bid.fromJson(jsonDecode(response.body));
  }
}