import 'package:flutter/material.dart';
import 'package:stream_snap/features/video_feed/presentation/providers/feed_provider.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;
  final FeedProvider feedProvider;

  const AppLifecycleObserver(
      {super.key, required this.child, required this.feedProvider});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    //register class to listen to native lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    //prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final currentVideoList = widget.feedProvider.videos;
    if (currentVideoList.isEmpty) return;

    //get current video that is playing/visible
    final currentVideoID =
        currentVideoList[widget.feedProvider.currentIndex].id;
    final activeController =
        widget.feedProvider.pool.getController(currentVideoID);

    if (activeController == null || !activeController.value.isInitialized)
      return;

    //handle transition states
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      debugPrint("LOG: The App has been paused.");
      activeController.pause();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("LOG: The App has resumed.");
      activeController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
