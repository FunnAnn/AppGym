import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String dayTitle;
  final int percent;
  final String duration;
  final List<Map<String, String>> exercises;

  const WorkoutDetailScreen({
    super.key,
    required this.dayTitle,
    this.percent = 0,
    this.duration = '~ 38min',
    required this.exercises,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  VideoPlayerController? _jumpRopeController;
  VideoPlayerController? _dumbbellController;
  VideoPlayerController? _trxController;
  VideoPlayerController? _benchTricepsDipsController;
  VideoPlayerController? _bicepsCurlWithResistanceBandController;
  VideoPlayerController? _flutterKicksController;
  VideoPlayerController? _pushUpsController;
  VideoPlayerController? _chestStretchController;
  VideoPlayerController? _shoulderStretchController;
  VideoPlayerController? _tricepsStretchController;
  VideoPlayerController? _abdominalAndLowerBackStretchController;

  @override
  void initState() {
    super.initState();

    // Initialize Jump Rope Video
    _jumpRopeController = VideoPlayerController.asset('assets/videos/jump_rope.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        _jumpRopeController?.play(); // Auto play
      });

    // Initialize Dumbbell Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE dumbbell.mp4)
    _dumbbellController = VideoPlayerController.asset('assets/videos/dumbbell.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Dumbbell video initialized");
        _dumbbellController?.play(); // Auto play
      });

    // Initialize TRX Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE trx.mp4)
    _trxController = VideoPlayerController.asset('assets/videos/trx.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("TRX video initialized");
        _trxController?.play(); // Auto play
      });

    // Initialize Bench Triceps Dips Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE bench_triceps_dips.mp4)
    _benchTricepsDipsController = VideoPlayerController.asset('assets/videos/bench_triceps_dips.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Bench Triceps Dips video initialized");
        _benchTricepsDipsController?.play(); // Auto play
      });

    // Initialize Biceps Curl with Resistance Band Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE biceps_curl_with_band.mp4)
    _bicepsCurlWithResistanceBandController = VideoPlayerController.asset('assets/videos/biceps_curl_with_band.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Biceps Curl with Resistance Band video initialized");
        _bicepsCurlWithResistanceBandController?.play(); // Auto play
      });

    // Initialize Flutter Kicks Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE flutter_kicks.mp4)
    _flutterKicksController = VideoPlayerController.asset('assets/videos/flutter_kicks.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Flutter Kicks video initialized");
        _flutterKicksController?.play(); // Auto play
      });

    // Initialize Push Ups Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE push_ups.mp4)
    _pushUpsController = VideoPlayerController.asset('assets/videos/push_ups.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Push Ups video initialized");
        _pushUpsController?.play(); // Auto play
      });

    // Initialize Chest Stretch Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE chest_stretch.mp4)
    _chestStretchController = VideoPlayerController.asset('assets/videos/chest_stretch.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Chest Stretch video initialized");
        _chestStretchController?.play(); // Auto play
      });

    // Initialize Shoulder Stretch Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE shoulder_stretch.mp4)
    _shoulderStretchController = VideoPlayerController.asset('assets/videos/shoulder_stretch.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Shoulder Stretch video initialized");
        _shoulderStretchController?.play(); // Auto play
      });

    // Initialize Triceps Stretch Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE triceps_stretch.mp4)
    _tricepsStretchController = VideoPlayerController.asset('assets/videos/triceps_stretch.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Triceps Stretch video initialized");
        _tricepsStretchController?.play(); // Auto play
      });

    // Initialize Abdominal and Lower Back Stretch Video (SỬA ĐÚNG ĐƯỜNG DẪN FILE abdominal_lower_back_stretch.mp4)
    _abdominalAndLowerBackStretchController = VideoPlayerController.asset('assets/videos/abdominal_lower_back_stretch.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        print("Abdominal and Lower Back Stretch video initialized");
        _abdominalAndLowerBackStretchController?.play(); // Auto play
      });
      
  }

  @override
  void dispose() {
    _jumpRopeController?.dispose();
    _dumbbellController?.dispose();
    _trxController?.dispose();
    _benchTricepsDipsController?.dispose();
    _bicepsCurlWithResistanceBandController?.dispose();
    _flutterKicksController?.dispose();
    _pushUpsController?.dispose();
    _chestStretchController?.dispose();
    _shoulderStretchController?.dispose();
    _tricepsStretchController?.dispose();
    _abdominalAndLowerBackStretchController?.dispose();
    super.dispose();
  }

  void _showJumpRopeVideo(BuildContext context) async {
    if (_jumpRopeController != null && _jumpRopeController!.value.isInitialized) {
      await _jumpRopeController!.seekTo(Duration.zero);
      _jumpRopeController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _jumpRopeController != null && _jumpRopeController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_jumpRopeController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _jumpRopeController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _jumpRopeController?.pause();
    });
  }

  void _showDumbbellVideo(BuildContext context) async {
    if (_dumbbellController != null && _dumbbellController!.value.isInitialized) {
      await _dumbbellController!.seekTo(Duration.zero);
      _dumbbellController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _dumbbellController != null && _dumbbellController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_dumbbellController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _dumbbellController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _dumbbellController?.pause();
    });
  }

  void _showTrxVideo(BuildContext context) async {
    if (_trxController != null && _trxController!.value.isInitialized) {
      await _trxController!.seekTo(Duration.zero);
      _trxController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _trxController != null && _trxController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_trxController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _trxController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _trxController?.pause();
    });
  }

  void _showBenchTricepsDipsVideo(BuildContext context) async {
    if (_benchTricepsDipsController != null && _benchTricepsDipsController!.value.isInitialized) {
      await _benchTricepsDipsController!.seekTo(Duration.zero);
      _benchTricepsDipsController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _benchTricepsDipsController != null && _benchTricepsDipsController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_benchTricepsDipsController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _benchTricepsDipsController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _benchTricepsDipsController?.pause();
    });
  }
  
  void _showBicepsCurlWithResistanceBandVideo(BuildContext context) async {
    if (_bicepsCurlWithResistanceBandController != null && _bicepsCurlWithResistanceBandController!.value.isInitialized) {
      await _bicepsCurlWithResistanceBandController!.seekTo(Duration.zero);
      _bicepsCurlWithResistanceBandController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _bicepsCurlWithResistanceBandController != null && _bicepsCurlWithResistanceBandController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_bicepsCurlWithResistanceBandController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _bicepsCurlWithResistanceBandController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _bicepsCurlWithResistanceBandController?.pause();
    });
  }

  void _showFlutterKicksVideo(BuildContext context) async {
    if (_flutterKicksController != null && _flutterKicksController!.value.isInitialized) {
      await _flutterKicksController!.seekTo(Duration.zero);
      _flutterKicksController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _flutterKicksController != null && _flutterKicksController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_flutterKicksController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _flutterKicksController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _flutterKicksController?.pause();
    });
  }

  void _showPushUpsVideo(BuildContext context) async {
    if (_pushUpsController != null && _pushUpsController!.value.isInitialized) {
      await _pushUpsController!.seekTo(Duration.zero);
      _pushUpsController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _pushUpsController != null && _pushUpsController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_pushUpsController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _pushUpsController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _pushUpsController?.pause();
    });
  }

  void _showChestStretchVideo(BuildContext context) async {
    if (_chestStretchController != null && _chestStretchController!.value.isInitialized) {
      await _chestStretchController!.seekTo(Duration.zero);
      _chestStretchController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _chestStretchController != null && _chestStretchController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_chestStretchController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _chestStretchController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _chestStretchController?.pause();
    });
  }

  void _showShoulderStretchVideo(BuildContext context) async {
    if (_shoulderStretchController != null && _shoulderStretchController!.value.isInitialized) {
      await _shoulderStretchController!.seekTo(Duration.zero);
      _shoulderStretchController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _shoulderStretchController != null && _shoulderStretchController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_shoulderStretchController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _shoulderStretchController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _shoulderStretchController?.pause();
    });
  }

  void _showTricepsStretchVideo(BuildContext context) async {
    if (_tricepsStretchController != null && _tricepsStretchController!.value.isInitialized) {
      await _tricepsStretchController!.seekTo(Duration.zero);
      _tricepsStretchController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _tricepsStretchController != null && _tricepsStretchController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_tricepsStretchController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _tricepsStretchController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _tricepsStretchController?.pause();
    });
  }

  void _showAbdominalAndLowerBackStretchVideo(BuildContext context) async {
    if (_abdominalAndLowerBackStretchController != null && _abdominalAndLowerBackStretchController!.value.isInitialized) {
      await _abdominalAndLowerBackStretchController!.seekTo(Duration.zero);
      _abdominalAndLowerBackStretchController!.play();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bo tròn góc
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _abdominalAndLowerBackStretchController != null && _abdominalAndLowerBackStretchController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24), // Bo tròn góc video
                        child: VideoPlayer(_abdominalAndLowerBackStretchController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.pinkTheme, size: 32),
                    onPressed: () {
                      _abdominalAndLowerBackStretchController?.pause();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _abdominalAndLowerBackStretchController?.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
  print(widget.exercises.map((e) => e['title']).toList()); // Debug: print all exercise titles
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Workout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Return true to indicate skipped/completed
            },
            child: const Text('Skip', style: TextStyle(color: AppColors.pinkTheme)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1 Workout Day',
                          style: const TextStyle(color: AppColors.pinkTheme, fontSize: 16),
                        ),
                        Text(
                          widget.dayTitle,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.duration,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final ex = widget.exercises[index];
                  
                  // Jump Rope
                  if (ex['title'] == 'Jump rope') {
                    return InkWell(
                      onTap: () => _showJumpRopeVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/jump_rope.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    ); 
                  }
                  
                  // Dumbbell Bench Press
                  if (ex['title'] == 'Incline dumbbell bench press (30 degrees)') {
                    return InkWell(
                      onTap: () => _showDumbbellVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/dumbbell.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'TRX row') {
                    return InkWell(
                      onTap: () => _showTrxVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/TRX.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Bench triceps dips') {
                    return InkWell(
                      onTap: () => _showBenchTricepsDipsVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/bench_triceps_dips.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Biceps curl with resistance band') {
                    return InkWell(
                      onTap: () => _showBicepsCurlWithResistanceBandVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/biceps_curl_with_resistance_band.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Flutter kicks') {
                    return InkWell(
                      onTap: () => _showFlutterKicksVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/flutter_kicks.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Push-ups') {
                    return InkWell(
                      onTap: () => _showPushUpsVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/push_ups.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }
                  
                  if (ex['title'] == 'Chest Stretch') {
                    return InkWell(
                      onTap: () => _showChestStretchVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/chest_stretch.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Shoulder Stretch') {
                    return InkWell(
                      onTap: () => _showShoulderStretchVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/shoulder_stretch.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Triceps Stretch') {
                    return InkWell(
                      onTap: () => _showTricepsStretchVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/triceps_stretch.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                  if (ex['title'] == 'Abdominal and Lower Back Stretch') {
                    return InkWell(
                      onTap: () => _showAbdominalAndLowerBackStretchVideo(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/abdominal_lower_back_stretch.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['title_en'] ?? ex['title'] ?? '',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (ex['desc_en'] != null || ex['desc'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['desc_en'] ?? ex['desc']!,
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                if (ex['set'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      ex['set']!,
                                      style: const TextStyle(color: AppColors.pinkTheme, fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.pinkTheme),
                        ],
                      ),
                    );
                  }

                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on this page
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            // Handle "Scan QR" if needed
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account');
          }
        },
      ),
    );
  }
}
