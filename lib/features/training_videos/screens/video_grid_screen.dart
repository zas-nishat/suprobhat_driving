import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelPage extends StatefulWidget {
  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  final String channelUrl =
      "https://www.youtube.com/@suprobhatdrivingtrainingce5295";
  final String phoneNumber = "01945191220";
  final String whatsappNumber = "01945191220";
  final String imoNumber = "01945191220";
  final String userName = "Md. Ashraf Ali";

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open the link')));
    }
  }

  void _callNumber(String number) async {
    final uri = Uri.parse("tel:$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String number) async {
    final url = "https://wa.me/$number";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Channel Banner
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

          // Channel Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/suprobhat.png"),
                ),
                SizedBox(width: 16),

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

                ElevatedButton(
                  onPressed: () {
                    _openUrl(channelUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    'view channel',
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'All kinds of light vehicles training centre.\n'
              'Duration of Training: One Month.',
              style: TextStyle(fontSize: 16),
            ),
          ),

          SizedBox(height: 20),

          // Contact Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Info",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone"),
                  subtitle: Text(phoneNumber),
                  onTap: () => _callNumber(phoneNumber),
                ),

                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text("WhatsApp"),
                  subtitle: Text(whatsappNumber),
                  onTap: () => _openWhatsApp(whatsappNumber),
                ),

                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text("IMO"),
                  subtitle: Text(imoNumber),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
