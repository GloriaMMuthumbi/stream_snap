import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_snap/core/observers/app_lifecycle_observer.dart';
import 'package:stream_snap/features/video_feed/presentation/pages/video_feed_page.dart';
import 'package:stream_snap/features/video_feed/presentation/providers/feed_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedProvider(),
      child: Consumer<FeedProvider>(builder: (context, feedProvider, child) {
        return MaterialApp(
          title: 'StreamSnap',
          debugShowCheckedModeBanner: false,
          theme:
              ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
          home: AppLifecycleObserver(
              feedProvider: feedProvider, child: const VideoFeedPage()),
        );
      }),
    );
  }
}
