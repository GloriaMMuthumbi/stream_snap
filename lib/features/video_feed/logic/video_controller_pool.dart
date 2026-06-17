import 'package:stream_snap/features/video_feed/data/models/video_post.dart';
import 'package:video_player/video_player.dart';

class VideoControllerPool {
  final Map<String, VideoPlayerController> _pool = {};

  VideoPlayerController? getController(String id) => _pool[id];

  //pre-initialization
  Future<void> initializeController(VideoPost video) async {
    if (_pool.containsKey(video.id)) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(video.url));
    _pool[video.id] = controller;

    try {
      await controller.initialize();
      controller.setLooping(true);
    } catch (e) {
      print('Error initializaing controller for video ${video.id}: $e');
      _pool.remove(video.id);
      await controller.dispose();
    }
  }

  //free memory
  Future<void> disposeController(String id) async {
    final controller = _pool.remove(id);
    if (controller != null) {
      await controller.dispose();
    }
  }

  //clears entire pool
  Future<void> clearAll() async {
    for (final controller in _pool.values) {
      await controller.dispose();
    }
    _pool.clear();
  }
}
