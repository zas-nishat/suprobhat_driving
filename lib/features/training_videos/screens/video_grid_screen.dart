import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suprobhat_driving_app/app/data/providers/video_provider.dart';
import 'package:suprobhat_driving_app/features/training_videos/widgets/video_thumbnail_card.dart';
import 'package:suprobhat_driving_app/shared_widgets/custom_app_bar.dart';

class VideoGridScreen extends StatelessWidget {
  const VideoGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Training Videos'),
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.videoIds.isEmpty) {
            return const Center(
              child: Text('No training videos available.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 16 / 9, // Standard video aspect ratio
            ),
            itemCount: videoProvider.videoIds.length,
            itemBuilder: (context, index) {
              final videoId = videoProvider.videoIds[index];
              return VideoThumbnailCard(videoId: videoId);
            },
          );
        },
      ),
    );
  }
}
