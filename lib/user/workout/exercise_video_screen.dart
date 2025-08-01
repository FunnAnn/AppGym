import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '/../api_service/workout_log_service.dart';
import '../../api_service/plan_exercise_service.dart';
import '../bottom_main/bottom.dart'; // Thêm import này

class ExerciseVideoScreen extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final int planExerciseId; // <-- thêm dòng này

  const ExerciseVideoScreen({
    super.key,
    required this.videoUrl,
    this.title,
    required this.planExerciseId, // <-- thêm dòng này
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
      setState(() {
        _isLoading = false;
      });
      _controller!.play();
    } catch (e) {
      try {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await _controller!.initialize();
        await _controller!.setLooping(true);
        setState(() {
          _isLoading = false;
        });
        _controller!.play();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Không thể phát video. Đường dẫn hoặc định dạng không hợp lệ.';
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(widget.title ?? 'Exercise Video', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeVideo,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Video player
                      if (_controller != null && _controller!.value.isInitialized)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(child: Text('Không có video')),
                        ),
                      const SizedBox(height: 32),
                      // Workout Log Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                        margin: const EdgeInsets.only(bottom: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.09),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Workout Log',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Rep circle
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.teal, width: 4),
                                    color: Colors.teal.withOpacity(0.09),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal.withOpacity(0.08),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    reps.toString(),
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // Rep input
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: TextField(
                                      controller: logController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Rep',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 22),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                // Add set button
                                Material(
                                  color: Colors.transparent,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: currentSet < totalSet ? Colors.pink : Colors.grey[300],
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        if (currentSet < totalSet)
                                          BoxShadow(
                                            color: Colors.pink.withOpacity(0.18),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.white, size: 36),
                                      onPressed: currentSet < totalSet
                                          ? () async {
                                              if (logController.text.trim().isEmpty) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Vui lòng nhập số rep trước!')),
                                                );
                                                return;
                                              }
                                              setState(() {
                                                if (currentSet < totalSet) currentSet += 1;
                                              });
                                              try {
                                                await WorkoutLogService.createWorkoutLog(
                                                  customerId: customerId,
                                                  planId: planId,
                                                  exerciseId: exerciseId,
                                                  workoutDate: DateTime.now().toIso8601String().substring(0, 10),
                                                  actualSets: 1,
                                                  actualReps: int.tryParse(logController.text) ?? reps,
                                                  actualWeight: weight,
                                                  notes: "",
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Đã lưu workout log!')),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Lưu workout log thất bại!')),
                                                );
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ),
                                // Set counter
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    children: [
                                      Text(
                                        '$currentSet/$totalSet',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.pink),
                                      ),
                                      const Text(
                                        'Set',
                                        style: TextStyle(fontSize: 16, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (weight != 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 28),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.fitness_center, color: Colors.teal, size: 26),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Weight: $weight kg',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
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