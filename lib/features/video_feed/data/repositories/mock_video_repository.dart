import 'package:stream_snap/features/video_feed/data/models/video_post.dart';

class MockVideoRepository {
  Future<List<VideoPost>> fetchFeedVideos() async {
    //simulate loading or network lag to test spinner
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      VideoPost(
        id: '1',
        url: 'assets/videos/tree_with_yellow_flowers.mp4',
        username: 'nature_explorer',
        caption: 'Experience this with me! ☀️',
      ),
      VideoPost(
        id: '2',
        url: 'assets/videos/waves_breaking_in_the_ocean.mp4',
        username: 'drone_pilot',
        caption: 'Absolutely mesmerizing and satisfying.',
      ),
      VideoPost(
        id: '3',
        url: 'assets/videos/forrest_stream_in_sunlight.mp4',
        username: 'serenity_now',
        caption: 'Breathe and listen. 😮‍💨👂',
      ),
      VideoPost(
        id: '4',
        url: 'assets/videos/milkyway_galaxy_in_the_night.mp4',
        username: 'astro_glance',
        caption: 'Look up!',
      ),
    ];
  }
}
