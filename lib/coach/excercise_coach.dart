import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart'; // Move this to the top
import '../model/excercise.dart';
import '../api_service/exercise_service.dart';
import '../theme/app_colors.dart';
import 'layout_coach.dart';

class CoachExercisePage extends StatefulWidget {
  @override
  _CoachExercisePageState createState() => _CoachExercisePageState();
}

class _CoachExercisePageState extends State<CoachExercisePage> {
  List<Data> exercises = [];
  List<Data> filteredExercises = [];
  bool isLoading = true;
  String errorMessage = '';
  
  // Search and filter controllers
  TextEditingController _searchController = TextEditingController();
  String _selectedMuscleGroup = 'All';
  List<String> _muscleGroups = ['All'];
  String _selectedViewMode = 'grid'; // 'grid' or 'list'

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
    return LayoutCoach(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.fitness_center, color: AppColors.pinkTheme, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Exercise Library',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pinkTheme,
                    ),
                  ),
                ),
                // View mode toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedViewMode = 'grid';
                          });
                        },
                        icon: Icon(Icons.grid_view),
                        color: _selectedViewMode == 'grid' ? AppColors.pinkTheme : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedViewMode = 'list';
                          });
                        },
                        icon: Icon(Icons.view_list),
                        color: _selectedViewMode == 'list' ? AppColors.pinkTheme : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Search and Filter Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
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
                        hint: Text('Muscle Group'),
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
              ],
            ),
            
            SizedBox(height: 12),
            
            // Results info and clear filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${filteredExercises.length} of ${exercises.length} exercises',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_searchController.text.isNotEmpty || _selectedMuscleGroup != 'All')
                  TextButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _selectedMuscleGroup = 'All';
                      });
                      _filterExercises();
                    },
                    icon: Icon(Icons.clear_all, size: 16, color: AppColors.pinkTheme),
                    label: Text(
                      'Clear filters',
                      style: TextStyle(
                        color: AppColors.pinkTheme,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 16),

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.pinkTheme),
            SizedBox(height: 16),
            Text(
              'Loading exercises...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Failed to load exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadExercises,
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkTheme,
                  foregroundColor: Colors.white,
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
                  : Icons.fitness_center_outlined, 
              size: 80, 
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty || _selectedMuscleGroup != 'All'
                  ? 'No exercises found'
                  : 'No exercises available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty || _selectedMuscleGroup != 'All'
                  ? 'Try adjusting your search or filters'
                  : 'Exercises will appear here when available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isNotEmpty || _selectedMuscleGroup != 'All')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedMuscleGroup = 'All';
                    });
                    _filterExercises();
                  },
                  icon: Icon(Icons.clear_all),
                  label: Text('Clear all filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkTheme,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Return grid or list view based on selection
    return _selectedViewMode == 'grid' ? _buildGridView() : _buildListView();
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        return _buildExerciseCard(exercise);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        return _buildExerciseListItem(exercise);
      },
    );
  }

  Widget _buildExerciseCard(Data exercise) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showExerciseDetail(exercise),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: exercise.videoUrl != null && exercise.videoUrl!.isNotEmpty
                    ? Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.pinkTheme.withOpacity(0.1),
                                  AppColors.pinkTheme.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.pinkTheme.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
            ),
            // Exercise info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.exerciseName ?? 'Unknown Exercise',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pinkTheme,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.pinkTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        exercise.muscleGroup ?? 'General',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.pinkTheme,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (exercise.equipmentNeeded != null && exercise.equipmentNeeded!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 10,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                exercise.equipmentNeeded!,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseListItem(Data exercise) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showExerciseDetail(exercise),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Exercise icon/video indicator
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: exercise.videoUrl != null && exercise.videoUrl!.isNotEmpty
                      ? AppColors.pinkTheme.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  exercise.videoUrl != null && exercise.videoUrl!.isNotEmpty
                      ? Icons.play_circle_filled
                      : Icons.fitness_center,
                  color: exercise.videoUrl != null && exercise.videoUrl!.isNotEmpty
                      ? AppColors.pinkTheme
                      : Colors.grey[400],
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              // Exercise details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.exerciseName ?? 'Unknown Exercise',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pinkTheme,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.pinkTheme.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            exercise.muscleGroup ?? 'General',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.pinkTheme,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (exercise.equipmentNeeded != null && exercise.equipmentNeeded!.isNotEmpty) ...[
                          SizedBox(width: 8),
                          Icon(
                            Icons.fitness_center,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Expanded(
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
                      ],
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
  }

  void _showExerciseDetail(Data exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // Header with tabs
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.pinkTheme,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Title bar
                        Padding(
                          padding: EdgeInsets.all(16),
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
                        // Tab bar
                        TabBar(
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
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
                      ],
                    ),
                  ),
                  // Tab content
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
          // Basic info
          _buildDetailRow('Muscle Group', exercise.muscleGroup ?? 'N/A'),
          SizedBox(height: 12),
          _buildDetailRow('Equipment Needed', exercise.equipmentNeeded ?? 'None'),
          SizedBox(height: 12),
          
          // Description
          Text(
            'Description:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.pinkTheme,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              exercise.description ?? 'No description available',
              style: TextStyle(fontSize: 14),
            ),
          ),
          
          // Created/Updated info
          if (exercise.createdAt != null) ...[
            SizedBox(height: 16),
            _buildDetailRow('Created', exercise.createdAt!),
          ],
          if (exercise.updatedAt != null) ...[
            SizedBox(height: 8),
            _buildDetailRow('Last Updated', exercise.updatedAt!),
          ],
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
                  // Video Player Container
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
                        child: CoachVideoPlayerWidget(videoUrl: exercise.videoUrl!),
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
                      SizedBox(width: 12),
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
                CoachVideoPlayerWidget(videoUrl: videoUrl, isFullscreen: true),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.pinkTheme,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// Video Player Widget for Coach
class CoachVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isFullscreen;

  const CoachVideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  _CoachVideoPlayerWidgetState createState() => _CoachVideoPlayerWidgetState();
}

class _CoachVideoPlayerWidgetState extends State<CoachVideoPlayerWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller != null && _controller!.value.isInitialized) {
      if (state == AppLifecycleState.paused) {
        _controller!.pause();
      }
    }
  }

  Future<void> _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });

      String processedUrl = _processVideoUrl(widget.videoUrl);
      print('Coach attempting to play video: $processedUrl');
      
      Uri videoUri = Uri.parse(processedUrl);
      _controller = VideoPlayerController.networkUrl(videoUri);
      
      await _controller!.initialize();
      
      _controller!.addListener(_videoListener);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Coach video initialization error: $e');
      await _tryAlternativeInitialization();
    }
  }

  void _videoListener() {
    if (mounted && _controller != null) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  Future<void> _tryAlternativeInitialization() async {
    try {
      String originalUrl = widget.videoUrl;
      print('Coach trying original URL: $originalUrl');
      
      _controller?.dispose();
      _controller = VideoPlayerController.networkUrl(Uri.parse(originalUrl));
      
      await _controller!.initialize();
      _controller!.addListener(_videoListener);

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      print('Coach alternative initialization also failed: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Unable to load video. The video format may not be supported or the URL may be invalid.';
      });
    }
  }

  String _processVideoUrl(String url) {
    if (url.contains('drive.google.com')) {
      return _processGoogleDriveUrl(url);
    }
    return url;
  }

  String _processGoogleDriveUrl(String url) {
    if (url.contains('/file/d/')) {
      final regex = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(url);
      if (match != null) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return url;
  }

  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
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
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Video URL copied to clipboard'),
                              backgroundColor: AppColors.pinkTheme,
                            ),
                          );
                        }
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
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
            
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
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
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
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.black,
                                            child: CoachVideoPlayerWidget(
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