import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoProvider with ChangeNotifier {
  // This list will hold the YouTube video IDs
  final List<String> _videoIds = [
    'Rs1zMDbmdHI&t=55s', // Example video ID 1
    'Rs1zMDbmdHI&t=55s', // Example video ID 2
    '_y_J-211_0Q', // Example video ID 3
    // Add more video IDs from the YouTube channel: https://www.youtube.com/@suprobhatdrivingtrainingce5295
    // You'll need to manually extract these IDs from the video URLs.
  ];

  List<String> get videoIds => _videoIds;

  // You might want to add a method to fetch video titles/thumbnails
  // from the YouTube Data API if you want more dynamic content.
  // For now, we'll rely on the youtube_player_flutter package to handle thumbnails.
}
