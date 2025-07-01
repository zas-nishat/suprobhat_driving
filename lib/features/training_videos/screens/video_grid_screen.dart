import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelPage extends StatefulWidget {
  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  String url = "https://www.youtube.com/@suprobhatdrivingtrainingce5295";

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open the video')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _openUrl(url);
        },
        child: ListView(
          children: [
            Container(
              height: 180,
              color: Colors.grey[800],
              child: Center(
                child: Text(
                  'Channel Banner',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/suprobhat.png"),
                  ),
                  SizedBox(width: 16),

                  // Name & Handle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suprobhat Driving Training Centre',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@suprobhatdrivingtrainingce5295',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),

                  // Subscribe Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey[700]),

            // Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'All kinds of light vehicles training centre.\n'
                'Duration of Training: One Month.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
