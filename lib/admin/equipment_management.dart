import 'package:flutter/material.dart';
import '../api_service/equipment_service.dart';
import '../model/equipment.dart' as EquipmentModel;
import 'admin_layout.dart';
import '../theme/app_colors.dart';

class EquipmentManagementPage extends StatefulWidget {
  const EquipmentManagementPage({super.key});

  @override
  State<EquipmentManagementPage> createState() => _EquipmentManagementPageState();
}

class _EquipmentManagementPageState extends State<EquipmentManagementPage> {
  List<EquipmentModel.Data> _equipments = [];
  List<EquipmentModel.Data> _filteredList = [];
  bool _isLoading = true;
  String _equipmentFilter = '';
  String _statusFilter = 'All Status';
  final TextEditingController _equipmentController = TextEditingController();

  final List<String> _statuses = ['All Status', 'ACTIVE', 'MAINTENANCE', 'BROKEN'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final equipmentService = EquipmentService();
      final equipments = await equipmentService.getAllEquipments();

      setState(() {
        _equipments = equipments;
        _filteredList = equipments;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterData() {
    setState(() {
      _filteredList = _equipments.where((equipment) {
        final equipmentMatch = _equipmentFilter.isEmpty ||
            equipment.equipmentName?.toLowerCase().contains(_equipmentFilter.toLowerCase()) == true;
        final statusMatch = _statusFilter == 'All Status' || 
                           equipment.status?.toUpperCase() == _statusFilter.toUpperCase();
        
        return equipmentMatch && statusMatch;
      }).toList();
    });
  }

  void _onEquipmentFilterChanged(String value) {
    setState(() {
      _equipmentFilter = value;
    });
    _filterData();
  }

  void _onStatusChanged(String? status) {
    setState(() {
      _statusFilter = status ?? 'All Status';
    });
    _filterData();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'MAINTENANCE':
        return Colors.orange;
      case 'BROKEN':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEquipmentCard(EquipmentModel.Data equipment, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với số thứ tự và status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.pinkTheme,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(equipment.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        equipment.status?.toUpperCase() ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 16),
                              SizedBox(width: 8),
                              Text('View Details'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'view') {
                          _showEquipmentDetails(equipment);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Equipment Name và Icon
            Row(
              children: [
                Icon(Icons.fitness_center, color: AppColors.pinkTheme, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    equipment.equipmentName ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Equipment Information Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.description, 'Description', equipment.description ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.location_on, 'Location', equipment.location ?? 'N/A'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.build, 'Last Maintenance', _formatDate(equipment.lastMaintenanceDate)),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_today, 'Created At', _formatDate(equipment.createdAt)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEquipmentDetails(EquipmentModel.Data equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.fitness_center, color: AppColors.pinkTheme, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                equipment.equipmentName ?? 'Equipment Details',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.label, 'Equipment Name', equipment.equipmentName ?? 'N/A'),
              _buildDetailRow(Icons.description, 'Description', equipment.description ?? 'N/A'),
              _buildDetailRow(Icons.location_on, 'Location', equipment.location ?? 'N/A'),
              _buildDetailRow(Icons.info, 'Status', equipment.status ?? 'N/A'),
              _buildDetailRow(Icons.build, 'Last Maintenance Date', _formatDate(equipment.lastMaintenanceDate)),
              _buildDetailRow(Icons.calendar_today, 'Created At', _formatDate(equipment.createdAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(EquipmentModel.Data equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${equipment.equipmentName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final equipmentService = EquipmentService();
                await equipmentService.deleteEquipment(equipment.equipmentId!);
                _loadData(); // Reload data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Equipment deleted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting equipment: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.fitness_center_outlined, color: AppColors.pinkTheme, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'Equipment list',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.pinkTheme,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _equipmentController,
                          decoration: InputDecoration(
                            hintText: 'Filter Equipment Name...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _equipmentFilter.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _equipmentController.clear();
                                      _onEquipmentFilterChanged('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onChanged: _onEquipmentFilterChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 140,
                        child: DropdownButtonFormField<String>(
                          value: _statusFilter,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: _statuses.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status, style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: _onStatusChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Results Count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Text(
                'Showing ${_filteredList.length} of ${_equipments.length} results',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Equipment List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No equipment found',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              return _buildEquipmentCard(_filteredList[index], index);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _equipmentController.dispose();
    super.dispose();
  }
}
