import 'package:flutter/material.dart';
import 'package:suprobhat_driving_app/features/training_videos/screens/video_player_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';

class VideoThumbnailCard extends StatelessWidget {
  final String videoId;

  const VideoThumbnailCard({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoId: videoId),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSmallBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                YoutubePlayer.getThumbnail(videoId: videoId, quality: ThumbnailQuality.medium),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kSmallPadding),
              child: Text(
                'Video Title (Placeholder)', // TODO: Fetch actual video title if needed
                style: kBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
