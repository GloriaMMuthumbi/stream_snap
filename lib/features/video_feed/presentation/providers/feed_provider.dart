import 'package:flutter/foundation.dart';
import 'package:stream_snap/features/video_feed/data/models/video_post.dart';
import 'package:stream_snap/features/video_feed/data/repositories/mock_video_repository.dart';
import 'package:stream_snap/features/video_feed/logic/video_controller_pool.dart';

class FeedProvider extends ChangeNotifier {
  final MockVideoRepository _repository = MockVideoRepository();
  final VideoControllerPool _controllerPool = VideoControllerPool();

  List<VideoPost> videos = [];
  int currentIndex = 0;
  bool isLoading = false;

  VideoControllerPool get pool => _controllerPool;

  Future<void> loadFeed() async {
    isLoading = true;
    notifyListeners();

    try {
      videos = await _repository.fetchFeedVideos();
      if (videos.isNotEmpty) {
        //add first two videos instantly
        await _controllerPool.initializeController(videos[0]);
        if (videos.length > 1) {
          await _controllerPool.initializeController(videos[1]);
        }
        _controllerPool.getController(videos[0].id)?.play();
      }
    } catch (e) {
      print('Failed to load feed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //scrolling logic
  Future<void> handlePageChanged(int newIndex) async {
    if (newIndex < 0 || newIndex >= videos.length) return;

    final oldIndex = currentIndex;
    currentIndex = newIndex;
    notifyListeners();

    //pause old video
    final oldVideo = videos[oldIndex];
    _controllerPool.getController(oldVideo.id)?.pause();

    //new video
    final currentVideo = videos[currentIndex];
    _controllerPool.getController(currentVideo.id)?.play();

    //prefetch next video
    if (currentIndex + 1 < videos.length) {
      await _controllerPool.initializeController(videos[currentIndex + 1]);
    }

    //dispose distant trailing videos
    if (currentIndex - 2 >= 0) {
      await _controllerPool.disposeController(videos[currentIndex - 2].id);
    }

    //dispose any distant trailing videos
    if (currentIndex + 2 < videos.length) {
      await _controllerPool.disposeController(videos[currentIndex + 2].id);
    }
  }

  @override
  void dispose() {
    _controllerPool.clearAll();
    super.dispose();
  }
}
