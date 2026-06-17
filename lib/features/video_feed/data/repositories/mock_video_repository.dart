import 'package:stream_snap/features/video_feed/data/models/video_post.dart';

class MockVideoRepository {
  Future<List<VideoPost>> fetchFeedVideos() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      const VideoPost(
        id: 'vid_001',
        url:
            'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-42226-large.mp4',
        username: 'nature_explorer',
        caption: 'Blossoms in the wind 🌸 #nature #cinematic'),
      const VideoPost(
        id: 'vid_004',
        url: 'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-a-pool-42319-large.mp4',
        caption: 'Poolside afternoons are unmatched. ☀️ #summer',
        username: 'lounge_days',
      ),
    ];
  }
}
