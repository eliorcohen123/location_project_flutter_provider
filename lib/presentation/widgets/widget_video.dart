import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class WidgetVideo extends StatefulWidget {
  final String url;

  const WidgetVideo({Key key, @required this.url}) : super(key: key);

  @override
  _WidgetVideoState createState() => _WidgetVideoState();
}

class _WidgetVideoState extends State<WidgetVideo> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _showVideo();
        } else {
          return _loading();
        }
      },
    );
  }

  Widget _showVideo() {
    return Container(
      child: Card(
        key: PageStorageKey(widget.url),
        elevation: ResponsiveScreen().widthMediaQuery(context, 5),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(
                  ResponsiveScreen().widthMediaQuery(context, 8)),
              child: Chewie(
                key: PageStorageKey(widget.url),
                controller: ChewieController(
                  videoPlayerController: _videoPlayerController,
                  aspectRatio: 4 / 2,
                  autoInitialize: true,
                  looping: false,
                  autoPlay: false,
                  errorBuilder: (context, errorMessage) {
                    return Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
