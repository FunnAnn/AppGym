import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'admin_layout.dart';
import '../model/excercise.dart';
import '../api_service/exercise_service.dart';
import '../theme/app_colors.dart';

class ExerciseManagementPage extends StatefulWidget {
  @override
  _ExerciseManagementPageState createState() => _ExerciseManagementPageState();
}

class _ExerciseManagementPageState extends State<ExerciseManagementPage> {
  List<Data> exercises = [];
  List<Data> filteredExercises = [];
  bool isLoading = true;
  String errorMessage = '';
  
  // Search and filter controllers
  TextEditingController _searchController = TextEditingController();
  String _selectedMuscleGroup = 'All';
  List<String> _muscleGroups = ['All'];

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterExercises();
  }

  void _filterExercises() {
    List<Data> tempList = exercises;
    
    // Filter by search text
    if (_searchController.text.isNotEmpty) {
      tempList = tempList.where((exercise) {
        return exercise.exerciseName?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false;
      }).toList();
    }
    
    // Filter by muscle group
    if (_selectedMuscleGroup != 'All') {
      tempList = tempList.where((exercise) {
        return exercise.muscleGroup?.toLowerCase() == _selectedMuscleGroup.toLowerCase();
      }).toList();
    }
    
    setState(() {
      filteredExercises = tempList;
    });
  }

  void _extractMuscleGroups() {
    Set<String> muscleGroupSet = {'All'};
    for (var exercise in exercises) {
      if (exercise.muscleGroup != null && exercise.muscleGroup!.isNotEmpty) {
        muscleGroupSet.add(exercise.muscleGroup!);
      }
    }
    _muscleGroups = muscleGroupSet.toList();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final exerciseResponse = await ExerciseService.getAllExercises();

      setState(() {
        exercises = exerciseResponse.data ?? [];
        filteredExercises = exercises;
        isLoading = false;
      });
      
      _extractMuscleGroups();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercise Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pinkTheme,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search exercises by name...',
                        prefixIcon: Icon(Icons.search, color: AppColors.pinkTheme),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Muscle Group Filter
                  Row(
                    children: [
                      Text(
                        'Filter by Muscle Group:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMuscleGroup,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: AppColors.pinkTheme),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMuscleGroup = newValue!;
                                });
                                _filterExercises();
                              },
                              items: _muscleGroups.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: value == 'All' ? AppColors.pinkTheme : Colors.black87,
                                      fontWeight: value == 'All' ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Refresh button (smaller)
                      IconButton(
                        onPressed: _loadExercises,
                        icon: Icon(Icons.refresh, color: AppColors.pinkTheme),
                        tooltip: 'Refresh',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          padding: EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                  
                  // Results info
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${filteredExercises.length} of ${exercises.length} exercises',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (_searchController.text.isNotEmpty || _selectedMuscleGroup != 'All')
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _selectedMuscleGroup = 'All';
                            });
                            _filterExercises();
                          },
                          child: Text(
                            'Clear filters',
                            style: TextStyle(
                              color: AppColors.pinkTheme,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.pinkTheme),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error: $errorMessage',
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadExercises,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkTheme,
                  foregroundColor: Colors.white,
                ),
                child: Text('Retry'),
              ),
              if (errorMessage.contains('Authentication') ||
                  errorMessage.contains('401'))
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Go to Login'),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (filteredExercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isNotEmpty || _selectedMuscleGroup != 'All'
                  ? Icons.search_off
                  : Icons.fitness_center, 
              size: 64, 
              color: Colors.grey
            ),
            SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty || _selectedMuscleGroup != 'All'
                  ? 'No exercises found matching your filters'
                  : 'No exercises found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            if (_searchController.text.isNotEmpty || _selectedMuscleGroup != 'All')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedMuscleGroup = 'All';
                    });
                    _filterExercises();
                  },
                  child: Text(
                    'Clear all filters',
                    style: TextStyle(color: AppColors.pinkTheme),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Exercise list - now using filteredExercises instead of exercises
    return ListView.builder(
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _showExerciseDetail(exercise),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // ID Circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.pinkTheme.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        exercise.exerciseId?.toString() ?? '0',
                        style: TextStyle(
                          color: AppColors.pinkTheme,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Exercise Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Highlight search text in exercise name
                        RichText(
                          text: _buildHighlightedText(
                            exercise.exerciseName ?? 'Unknown Exercise',
                            _searchController.text,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.pinkTheme.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            exercise.muscleGroup ?? 'No muscle group',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.pinkTheme,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (exercise.equipmentNeeded != null &&
                            exercise.equipmentNeeded!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    exercise.equipmentNeeded!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExerciseDetail(Data exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pinkTheme,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            exercise.exerciseName ?? 'Exercise Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: TabBar(
                      labelColor: AppColors.pinkTheme,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.pinkTheme,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.info_outline),
                          text: 'Details',
                        ),
                        Tab(
                          icon: Icon(Icons.play_circle_outline),
                          text: 'Video',
                        ),
                      ],
                    ),
                  ),
                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildDetailTab(exercise),
                        _buildVideoTab(exercise),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailTab(Data exercise) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Exercise ID', exercise.exerciseId?.toString() ?? 'N/A'),
          SizedBox(height: 16),
          _buildDetailItem('Exercise Name', exercise.exerciseName ?? 'N/A'),
          SizedBox(height: 16),
          _buildDetailItem('Muscle Group', exercise.muscleGroup ?? 'N/A'),
          SizedBox(height: 16),
          _buildDetailItem('Equipment Needed', exercise.equipmentNeeded ?? 'N/A'),
          SizedBox(height: 16),
          _buildDetailItem('Description', exercise.description ?? 'N/A',
              isLongText: true),
          SizedBox(height: 16),
          _buildDetailItem('Created At', exercise.createdAt ?? 'N/A'),
          SizedBox(height: 16),
          _buildDetailItem('Updated At', exercise.updatedAt ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildVideoTab(Data exercise) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise Video',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.pinkTheme,
            ),
          ),
          SizedBox(height: 16),
          if (exercise.videoUrl != null && exercise.videoUrl!.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player Container - Always try to play video
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: VideoPlayerWidget(videoUrl: exercise.videoUrl!),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Video URL:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      exercise.videoUrl!,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openVideoFullscreen(exercise.videoUrl!),
                          icon: Icon(Icons.fullscreen),
                          label: Text('Fullscreen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pinkTheme,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: exercise.videoUrl!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Video URL copied to clipboard'),
                                backgroundColor: AppColors.pinkTheme,
                              ),
                            );
                          },
                          icon: Icon(Icons.copy),
                          label: Text('Copy URL'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No video available for this exercise',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Open video in fullscreen dialog
  void _openVideoFullscreen(String videoUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                VideoPlayerWidget(videoUrl: videoUrl, isFullscreen: true),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value,
      {bool isLongText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ':',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.pinkTheme,
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            maxLines: isLongText ? null : 1,
            overflow: isLongText ? null : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper method to highlight search text
  TextSpan _buildHighlightedText(String text, String searchText) {
    if (searchText.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.pinkTheme,
        ),
      );
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerSearch = searchText.toLowerCase();
    
    int start = 0;
    int index = lowerText.indexOf(lowerSearch);
    
    while (index >= 0) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.pinkTheme,
          ),
        ));
      }
      
      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + searchText.length),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          backgroundColor: AppColors.pinkTheme,
        ),
      ));
      
      start = index + searchText.length;
      index = lowerText.indexOf(lowerSearch, start);
    }
    
    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.pinkTheme,
        ),
      ));
    }
    
    return TextSpan(children: spans);
  }
}

// Enhanced Video Player Widget with better URL handling
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isFullscreen;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });

      // Process the video URL to make it playable
      String processedUrl = _processVideoUrl(widget.videoUrl);
      print('Attempting to play video: $processedUrl');
      
      Uri videoUri = Uri.parse(processedUrl);
      _controller = VideoPlayerController.networkUrl(videoUri);
      
      // Set video player options for better compatibility
      await _controller!.initialize();
      
      _controller!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller!.value.isPlaying;
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Video initialization error: $e');
      // Try alternative URL processing
      await _tryAlternativeInitialization();
    }
  }

  Future<void> _tryAlternativeInitialization() async {
    try {
      // Try with original URL if processing failed
      String originalUrl = widget.videoUrl;
      print('Trying original URL: $originalUrl');
      
      _controller?.dispose();
      _controller = VideoPlayerController.networkUrl(Uri.parse(originalUrl));
      
      await _controller!.initialize();
      
      _controller!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller!.value.isPlaying;
          });
        }
      });

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      print('Alternative initialization also failed: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Unable to load video. The video format may not be supported or the URL may be invalid.';
      });
    }
  }

  String _processVideoUrl(String url) {
    // Handle different types of video URLs
    if (url.contains('drive.google.com')) {
      return _processGoogleDriveUrl(url);
    } else if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return _processYouTubeUrl(url);
    } else if (url.contains('vimeo.com')) {
      return _processVimeoUrl(url);
    } else {
      // For direct video URLs, return as is
      return url;
    }
  }

  String _processGoogleDriveUrl(String url) {
    // Convert Google Drive sharing URL to direct video stream
    if (url.contains('/file/d/')) {
      final regex = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(url);
      if (match != null) {
        final fileId = match.group(1);
        // Use direct video stream URL
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    } else if (url.contains('id=')) {
      // Already a direct URL
      return url;
    }
    return url;
  }

  String _processYouTubeUrl(String url) {
    // Note: YouTube requires special handling and may not work with video_player
    // You might need youtube_player_flutter package for YouTube videos
    return url;
  }

  String _processVimeoUrl(String url) {
    // Vimeo also requires special handling
    return url;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isInitialized) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    // Auto-hide controls after 3 seconds
    if (_showControls && _isPlaying) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.pinkTheme),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 64),
                SizedBox(height: 16),
                Text(
                  'Video Load Failed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });
                        _initializeVideo();
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkTheme,
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: widget.videoUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Video URL copied to clipboard'),
                            backgroundColor: AppColors.pinkTheme,
                          ),
                        );
                      },
                      icon: Icon(Icons.copy),
                      label: Text('Copy URL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.pinkTheme),
              SizedBox(height: 16),
              Text(
                'Initializing video player...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
            
            // Controls Overlay
            if (_showControls)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black45,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black45,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Top controls
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Exercise Video',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (widget.isFullscreen)
                            IconButton(
                              icon: Icon(Icons.fullscreen_exit, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                        ],
                      ),
                    ),
                    
                    // Center play/pause button
                    Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: widget.isFullscreen ? 80 : 60,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                        ),
                      ),
                    ),
                    
                    // Bottom controls (progress bar)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          // Progress Slider
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.pinkTheme,
                              inactiveTrackColor: Colors.white30,
                              thumbColor: AppColors.pinkTheme,
                              overlayColor: AppColors.pinkTheme.withOpacity(0.2),
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: _controller!.value.position.inMilliseconds.toDouble(),
                              min: 0,
                              max: _controller!.value.duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                _controller!.seekTo(Duration(milliseconds: value.toInt()));
                              },
                            ),
                          ),
                          
                          // Time Display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_controller!.value.position),
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                  if (!widget.isFullscreen)
                                    IconButton(
                                      icon: Icon(Icons.fullscreen, color: Colors.white, size: 24),
                                      onPressed: () {
                                        // Open fullscreen
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.black,
                                            child: VideoPlayerWidget(
                                              videoUrl: widget.videoUrl,
                                              isFullscreen: true,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                              Text(
                                _formatDuration(_controller!.value.duration),
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
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
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}