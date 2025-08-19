import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '/../api_service/workout_log_service.dart';
import '../../api_service/plan_exercise_service.dart';
import '../../model/plan_exercise.dart'; // Import the file where Data is defined
import '../bottom_main/bottom.dart'; // Thêm import này
import '../../theme/app_colors.dart';

class ExerciseVideoScreen extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final int planExerciseId;
  final List<Data> exercises; // Add the list of exercises
  final int currentIndex; // Add the current index

  const ExerciseVideoScreen({
    super.key,
    required this.videoUrl,
    this.title,
    required this.planExerciseId,
    required this.exercises, // Pass the list of exercises
    required this.currentIndex, // Pass the current index
  });

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  int reps = 0;
  int sets = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController logController = TextEditingController();

  int currentSet = 0; // số set đã tập
  int totalSet = 0;   // tổng số set lấy từ API

  int weight = 0;
  int customerId = 0;
  int planId = 0;
  int exerciseId = 0;

  int _bottomIndex = 0; // Thêm vào _ExerciseVideoScreenState

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _fetchPlanExercise();
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      String processedUrl = _processVideoUrl(widget.videoUrl);
      _controller = VideoPlayerController.networkUrl(Uri.parse(processedUrl));
      await _controller!.initialize();
      await _controller!.setLooping(true);

      // Add listener to restart playback when video finishes
      _controller!.addListener(() {
        if (_controller!.value.position == _controller!.value.duration) {
          _controller!.seekTo(Duration.zero);
          _controller!.play();
        }
      });

      setState(() {
        _isLoading = false;
      });
      _controller!.play();
    } catch (e) {
      try {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await _controller!.initialize();
        await _controller!.setLooping(true);

        // Add listener to restart playback when video finishes
        _controller!.addListener(() {
          if (_controller!.value.position == _controller!.value.duration) {
            _controller!.seekTo(Duration.zero);
            _controller!.play();
          }
        });

        setState(() {
          _isLoading = false;
        });
        _controller!.play();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Unable to play video. Invalid URL or format.';
        });
      }
    }
  }

  String _processVideoUrl(String url) {
    if (url.contains('drive.google.com')) {
      final regex = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(url);
      if (match != null) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return url;
  }

  Future<void> _fetchPlanExercise() async {
    try {
      final data = await PlanService.fetchPlanExerciseById(widget.planExerciseId);
      setState(() {
        reps = data.reps ?? 0;
        totalSet = data.sets ?? 0;
        currentSet = 0;
        weight = data.weight ?? 0;
        planId = data.trainingPlans?.planId ?? 0;
        exerciseId = data.exercise?.exerciseId ?? 0;
        customerId = data.customer?.customerId ?? 0;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'Exercise Video',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white, // Set text color to white
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.pinkTheme, // Solid pink theme for AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      body: Column(
        children: [
          // Workout Log Section (Above the video)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display current reps
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.teal,
                  child: Text(
                    logController.text.isNotEmpty
                        ? logController.text
                        : reps.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 16),

                // Input for reps
                Expanded(
                  child: TextField(
                    controller: logController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter reps',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Add Set Button
                ElevatedButton(
                  onPressed: currentSet < totalSet
                      ? () async {
                          if (logController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter the number of reps!')),
                            );
                            return;
                          }

                          setState(() {
                            if (currentSet < totalSet) currentSet += 1;
                          });

                          try {
                            String formattedDate =
                                DateTime.now().toString().split(' ')[0];

                            await WorkoutLogService.createWorkoutLog(
                              customerId: customerId,
                              planId: planId,
                              exerciseId: exerciseId,
                              workoutDate: formattedDate,
                              actualSets: 1,
                              actualReps: int.tryParse(logController.text) ?? reps,
                              actualWeight: weight,
                              notes: "",
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Workout log saved successfully!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to save workout log: $e')),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.pinkTheme,
                  ),
                  child: const Text(
                    'Add Set',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Video Player Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    : SizedBox(
                        height: 80, // Reduced height for the video frame
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12), // Optional rounded corners
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                      ),
          ),

          // Display current set progress (Moved below the video)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  '$currentSet/$totalSet Set',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: currentSet / totalSet,
                  backgroundColor: AppColors.pinkThemeLight,
                  color: AppColors.pinkTheme,
                ),
              ],
            ),
          ),

          // Next Exercise Button
          if (currentSet == totalSet && widget.currentIndex < widget.exercises.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  final nextExercise = widget.exercises[widget.currentIndex + 1];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseVideoScreen(
                        videoUrl: nextExercise.exercise?.videoUrl ?? '',
                        title: nextExercise.exercise?.name ?? 'Next Exercise',
                        planExerciseId: nextExercise.planExerciseId!,
                        exercises: widget.exercises, // Pass the list of exercises
                        currentIndex: widget.currentIndex + 1, // Increment the index
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.pinkTheme,
                ),
                child: const Text(
                  'Next Exercise',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (index) {
          setState(() {
            _bottomIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            showQRDialog(context);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account');
          }
        },
      ),
    );
  }

  Widget _circleInput({required String label, required int value, required Color color, required ValueChanged<int> onChanged}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final result = await _showInputDialog(context, label, value);
            if (result != null) onChanged(result);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }

  Future<int?> _showInputDialog(BuildContext context, String label, int initialValue) async {
    final controller = TextEditingController(text: initialValue.toString());
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nhập $label'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}