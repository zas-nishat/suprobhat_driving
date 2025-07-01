import 'package:flutter/material.dart';

class ChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Banner Image
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
                  child: Icon(Icons.school, size: 40, color: Colors.blueAccent),
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
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('Subscribe'),
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
    );
  }
}
