import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  double _currentPosition = 0;
  double _totalDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    // Determinar si la URL es local o remota
    if (widget.videoUrl.startsWith('http')) {
      // URL remota
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    } else {
      // Asset local
      _controller = VideoPlayerController.asset(widget.videoUrl);
    }

    // Inicializar el controlador
    await _controller.initialize();
    
    // Actualizar el estado
    if (mounted) {
      setState(() {
        _isInitialized = true;
        _totalDuration = _controller.value.duration.inMilliseconds.toDouble();
      });
      
      // Agregar listener para actualizar la posición del video
      _controller.addListener(_videoListener);
    }
  }

  void _videoListener() {
    if (mounted && _controller.value.isInitialized) {
      setState(() {
        _currentPosition = _controller.value.position.inMilliseconds.toDouble();
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = _controller.value.isPlaying;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? "${twoDigits(duration.inHours)}:" : ""}$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    
    // Asegurarse de restaurar la orientación original
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: _isFullScreen 
        ? null 
        : AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.fullscreen),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
      body: SafeArea(
        child: Column(
          children: [
            _buildVideoPlayer(),
            if (!_isFullScreen) _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        color: Colors.black,
        height: _isFullScreen ? MediaQuery.of(context).size.height : 250,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (!_isPlaying)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            if (_isFullScreen)
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ),
            if (_isFullScreen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildProgressBar(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProgressBar(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.replay_10,
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
                onPressed: () {
                  final newPosition = _controller.value.position - const Duration(seconds: 10);
                  _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
                },
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Theme.of(context).colorScheme.primary,
                  size: 48,
                ),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: Icon(
                  Icons.forward_10,
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
                onPressed: () {
                  final newPosition = _controller.value.position + const Duration(seconds: 10);
                  final duration = _controller.value.duration;
                  _controller.seekTo(newPosition > duration ? duration : newPosition);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final duration = _controller.value.duration;
    final position = _controller.value.position;
    
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            thumbColor: Theme.of(context).colorScheme.primary,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Colors.grey[300],
          ),
          child: Slider(
            value: _currentPosition.clamp(0, _totalDuration),
            min: 0,
            max: _totalDuration,
            onChanged: (value) {
              setState(() {
                _currentPosition = value;
              });
              _controller.seekTo(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position)),
              Text(_formatDuration(duration)),
            ],
          ),
        ),
      ],
    );
  }
}