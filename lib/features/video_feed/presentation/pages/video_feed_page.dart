import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_snap/features/video_feed/presentation/providers/feed_provider.dart';
import 'package:stream_snap/features/video_feed/presentation/widgets/video_player_item.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({super.key});

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadFeed();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<FeedProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (provider.videos.isEmpty) {
          return const Center(
            child: Text(
              "No videos available.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: provider.videos.length,
            onPageChanged: (index) {
              provider.handlePageChanged(index);
            },
            itemBuilder: (context, index) {
              final video = provider.videos[index];
              //fetch allocated controller for the video
              final nativeController = provider.pool.getController(video.id);

              return Stack(
                children: [
                  //Video Rendering Engine
                  VideoPlayerItem(controller: nativeController),
                  
                  //UI Overlay content
                  Positioned(
                    left: 16,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@${video.username}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Text(
                          video.caption,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14
                          ),
                        )
                      ],
                    )
                  )
                ],
              );
            });
      }),
    );
  }
}
