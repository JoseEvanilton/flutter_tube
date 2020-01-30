import 'package:http/http.dart' as http;

import 'dart:convert';
import 'models/video.dart';
const API_KEY = "AIzaSyAUSAzo9p_S-ZQ2nlF3y99nU83Y-r7fD-8";

class Api {

  String _search;
  String _nextToken;

  search(String search) async {
    _search = search;
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );
    return decode(response);
  }

  nextPage() async {

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
    );
    return decode(response);
  }


  List<Video> decode(http.Response response) {
    if(response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _nextToken = decoded["nextPageToken"];
      List<Video> videos = decoded["items"].map<Video>(
          (map) {
            return Video.fromJson(map);
          }
      ).toList();
      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}