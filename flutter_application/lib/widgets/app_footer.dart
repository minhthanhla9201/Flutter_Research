import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Hot Movies App', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Liên hệ: support@hotmovies.app | Hotline: 1900 1234', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(icon: const Icon(Icons.facebook, color: Colors.white), onPressed: () {}, tooltip: 'Facebook'),
            IconButton(icon: const Icon(Icons.email, color: Colors.white), onPressed: () {}, tooltip: 'Email'),
            IconButton(icon: const Icon(Icons.web, color: Colors.white), onPressed: () {}, tooltip: 'Website'),
          ]),
          const SizedBox(height: 8),
          Text('© 2025 Hot Movies. All rights reserved.', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
        ],
      ),
    );
  }
}