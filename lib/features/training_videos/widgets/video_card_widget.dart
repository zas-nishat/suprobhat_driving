import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suprobhat_driving_app/app/config/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoCardWidget extends StatelessWidget {
  final String title;
  final String videoUrl;

  const VideoCardWidget({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  void _openVideo(BuildContext context) async {
    final uri = Uri.tryParse(videoUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open video')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('Invalid YouTube link')),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openVideo(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSmallBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: YoutubePlayer.getThumbnail(
                  videoId: videoId,
                  quality: ThumbnailQuality.medium,
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) =>
                        const Center(child: Icon(Icons.broken_image)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(kSmallPadding),
              child: Text(
                title,
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
