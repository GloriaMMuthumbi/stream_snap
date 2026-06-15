import 'package:video_player/video_player.dart';

class VideoCacheManager {
  //this stores active controllers [keyed by index in the feed]
  final Map<int, VideoPlayerController> _controllers = {};

    /// Previous + Current + Next
  static const int maxActiveControllers = 3;

  Future<VideoPlayerController> getController(int index, String url) async {
    //check if its available and return it if it is.
    if (_controllers.containsKey(index)) {
      return _controllers[index]!;
    }

    //kill a controller if number of controllers is more than 3
    if (_controllers.length >= maxActiveControllers) {
      _disposeOutdatedController(index);
    }

    //initializa new controller
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    await controller.setLooping(true);

    _controllers[index] = controller;
    print(
        "LOG: controller initialized for index $index. Total active controllers: ${_controllers.length}");
    return controller;
  }

  //function to dispose furthest controller from list of active contollers
  void _disposeOutdatedController(int currentIndex) {
    //find the index furthest from current position of user
    int? furthestIndex;
    int maxDistance = -1;

    for (final idx in _controllers.keys) {
        final distance = (idx - currentIndex).abs();
            if (distance > maxDistance) {
                maxDistance = distance;
                furthestIndex = idx;
            }
        }

        if (furthestIndex != null) {
            _controllers[furthestIndex]!.dispose();
            _controllers.remove(furthestIndex);
            print("LOG: contoller disposed at index $furthestIndex.");
        }
    }

    //function to dispose all controllers
    void disposeAll() {
        for (var c in _controllers.values) {
            c.dispose();
        }
        _controllers.clear();
    }
}
