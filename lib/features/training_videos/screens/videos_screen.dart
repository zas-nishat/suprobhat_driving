import 'package:flutter/material.dart';
import '../widgets/video_card_widget.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final List<Map<String, String>> videos = [
    {
      'title':
          'সুপ্রভাত ড্রাইভিং ট্রেনিং সেন্টার। প্রশিক্ষণরত অবস্থায় মোঃ জাহেদ আল সাবিত সাহেব। ঢাকা।☎️01945191220',
      'url': 'https://www.youtube.com/watch?v=oJ7-mcz7H9w&t=1027s',
    },
    {
      'title':
          'সুপ্রভাত ড্রাইভিং ট্রেনিং সেন্টার। প্রশিক্ষণরত অবস্থায় মোঃ আব্দুল আল মাসুদ সাহেব। ঢাকা☎️01945191220',
      'url': 'https://www.youtube.com/watch?v=Rs1zMDbmdHI',
    },
    {
      'title':
          'সুপ্রভাত ড্রাইভিং ট্রেনিং সেন্টার। প্রশিক্ষণরত অবস্থায় মোঃ তাওসিফ আহমেদ জারিফ সাহেব। 🚗☎️01945191220',
      'url': 'https://www.youtube.com/watch?v=Quabh2ZWt8E',
    },

    // Add more video data here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training Videos')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2 / 2,
          children:
              videos.map((video) {
                return VideoCardWidget(
                  title: video['title']!,
                  videoUrl: video['url']!,
                );
              }).toList(),
        ),
      ),
    );
  }
}
