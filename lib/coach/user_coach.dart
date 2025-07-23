import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_coach.dart';
import '../api_service/coach_customer_service.dart';
import '../api_service/package_service.dart';
import '../api_service/auth_service.dart';
import '../api_service/health_service.dart';
import 'layout_coach.dart';
import '../theme/app_colors.dart';

class CoachCustomerPage extends StatefulWidget {
  const CoachCustomerPage({super.key});

  @override
  State<CoachCustomerPage> createState() => _CoachCustomerPageState();
}

class _CoachCustomerPageState extends State<CoachCustomerPage> {
  List<Data> _customers = [];
  List<Data> _filteredList = [];
  Map<int, String> _packageNames = {}; // Cache for package names
  bool _isLoading = true;
  String _nameFilter = '';
  String _genderFilter = 'All Gender';
  final TextEditingController _nameController = TextEditingController();

  final List<String> _genders = ['All Gender', 'Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return LayoutCoach(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Search by name',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: _onNameFilterChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _genderFilter,
                        items: _genders
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: _onGenderChanged,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredList.isEmpty
                      ? const Center(child: Text('No customers found.'))
                      : ListView.builder(
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            return _buildCustomerCard(_filteredList[index], index);
                          },
                        ),
                ),
              ],
            ),
    );
  }

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

      // Try to call the API first
      try {
        final userCoachResponse = await CoachCustomerService.getCoachCustomers();
        final customers = userCoachResponse.data ?? [];
        
        setState(() {
          _customers = customers;
          _filteredList = customers;
        });
        
        // Load package names for each customer asynchronously
        for (final customer in customers) {
          if (customer.userId != null) {
            PackageService.getPackageNameByCustomerId(customer.userId!).then((packageName) {
              if (mounted) {
                setState(() {
                  _packageNames[customer.userId!] = packageName;
                });
              }
            });
          }
        }
        
        setState(() {
          _isLoading = false;
        });
        
        if (mounted && (_customers.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No customers found for this coach'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
            );
        }
        return;
      } catch (apiError) {
        print('API call failed: $apiError');
      }

    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
        _customers = [];
        _filteredList = [];
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
      _filteredList = _customers.where((customer) {
        final nameMatch = _nameFilter.isEmpty ||
            customer.fullName?.toLowerCase().contains(_nameFilter.toLowerCase()) == true;
        final genderMatch = _genderFilter == 'All Gender' || 
                           (_genderFilter == 'Male' && customer.gender == true) ||
                           (_genderFilter == 'Female' && customer.gender == false);
        
        return nameMatch && genderMatch;
      }).toList();
    });
  }

  void _onNameFilterChanged(String value) {
    setState(() {
      _nameFilter = value;
    });
    _filterData();
  }

  void _onGenderChanged(String? gender) {
    setState(() {
      _genderFilter = gender ?? 'All Gender';
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

  String _getGenderText(bool? gender) {
    if (gender == null) return 'N/A';
    return gender ? 'Male' : 'Female';
  }

  Color _getGenderColor(bool? gender) {
    if (gender == null) return Colors.grey;
    return gender ? Colors.blue : Colors.pink;
  }

  String _getPackageDisplayText(String? packageName) {
    if (packageName == null || packageName == 'Loading...') {
      return 'Loading...';
    } else if (packageName == 'No Package') {
      return 'No Active Package';
    } else if (packageName == 'N/A') {
      return 'Error Loading';
    }
    return packageName;
  }

  Color _getPackageColor(String? packageName) {
    if (packageName == 'No Package' || packageName == 'No Active Package') {
      return Colors.orange;
    } else if (packageName == 'N/A' || packageName == 'Error Loading') {
      return Colors.red;
    } else if (packageName == 'Loading...') {
      return Colors.grey;
    }
    return AppColors.pinkTheme;
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: label == 'Package' ? _getPackageColor(value) : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (label == 'Package' && (value == 'No Active Package' || value == 'Error Loading'))
                    Icon(
                      value == 'No Active Package' ? Icons.info_outline : Icons.error_outline,
                      size: 16,
                      color: _getPackageColor(value),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(Data customer, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Top colored section with customer info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.pinkTheme,
                    AppColors.pinkTheme.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header row with number and menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '#${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: PopupMenuButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view_health',
                              child: Row(
                                children: [
                                  Icon(Icons.trending_up, size: 18, color: Colors.orange[600]),
                                  const SizedBox(width: 8),
                                  const Text('View Health'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'view_health':
                                _showHealthDetails(customer);
                                break;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Customer avatar and name
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          backgroundImage: customer.avatar != null 
                            ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${customer.avatar}')
                            : null,
                          child: customer.avatar == null 
                            ? Text(
                                customer.fullName?.substring(0, 1).toUpperCase() ?? '?',
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkTheme,
                                ),
                              )
                            : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.fullName ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer.email ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bottom white section with details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Information grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.phone,
                          'Phone',
                          customer.phoneNumber ?? 'N/A',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[200],
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.cake,
                          'Birthday',
                          _formatDate(customer.dateOfBirth),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          customer.gender == true ? Icons.male : Icons.female,
                          'Gender',
                          _getGenderText(customer.gender),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[200],
                      ),
                      Expanded(
                        child: _buildPackageInfo(customer),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.pinkTheme,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPackageInfo(Data customer) {
    final packageName = _getPackageDisplayText(_packageNames[customer.userId]);
    final packageColor = _getPackageColor(packageName);
    
    return GestureDetector(
      onTap: () => _showPackageDetails(customer),
      child: Column(
        children: [
          Icon(
            Icons.card_membership,
            size: 24,
            color: packageColor,
          ),
          const SizedBox(height: 8),
          Text(
            'Package',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            packageName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: packageColor,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(Data customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Customer Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.person, 'Name', customer.fullName ?? 'N/A'),
              _buildDetailRow(Icons.email, 'Email', customer.email ?? 'N/A'),
              _buildDetailRow(Icons.phone, 'Phone', customer.phoneNumber ?? 'N/A'),
              _buildDetailRow(Icons.cake, 'Date of Birth', _formatDate(customer.dateOfBirth)),
              _buildDetailRow(Icons.person, 'Gender', _getGenderText(customer.gender)),
              _buildDetailRow(Icons.badge, 'User ID', customer.userId?.toString() ?? 'N/A'),
              _buildDetailRow(Icons.card_membership, 'Package', _getPackageDisplayText(_packageNames[customer.userId])),
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

  void _sendMessage(Data customer) {
    // Implement send message functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Send message to ${customer.fullName}')),
    );
  }

  void _viewProgress(Data customer) {
    // Implement view progress functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View progress for ${customer.fullName}')),
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

  void _showPackageDetails(Data customer) async {
    final packageName = _packageNames[customer.userId];
    
    if (packageName == null || packageName == 'Loading...' || packageName == 'No Package' || packageName == 'N/A') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Package Information'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer: ${customer.fullName ?? 'N/A'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                packageName == 'No Package' 
                  ? 'This customer does not have an active package.'
                  : packageName == 'Loading...'
                    ? 'Package information is still loading...'
                    : 'Unable to load package information.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    // Try to get detailed package information
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get membership details for the customer
      final headers = await AuthService.getHeaders();
      if (headers != null) {
        final response = await http.get(
          Uri.parse('https://splendid-wallaby-ethical.ngrok-free.app/memberships/get-membership-card-by-user-id/${customer.userId}'),
          headers: headers,
        );

        Navigator.of(context).pop(); // Close loading dialog

        if (response.statusCode == 200) {
          final membershipData = json.decode(response.body);
          _showDetailedPackageDialog(customer, membershipData['data']);
        } else {
          _showSimplePackageDialog(customer, packageName);
        }
      } else {
        Navigator.of(context).pop(); // Close loading dialog
        _showSimplePackageDialog(customer, packageName);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showSimplePackageDialog(customer, packageName);
    }
  }

  void _showDetailedPackageDialog(Data customer, Map<String, dynamic> membershipData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.card_membership, color: AppColors.pinkTheme),
            const SizedBox(width: 8),
            const Text('Package Details'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Customer info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pinkTheme.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.pinkTheme,
                      backgroundImage: customer.avatar != null 
                        ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${customer.avatar}')
                        : null,
                      child: customer.avatar == null 
                        ? Text(
                            customer.fullName?.substring(0, 1).toUpperCase() ?? '?',
                            style: const TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.fullName ?? 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            customer.email ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Package details
              const Text(
                'Package Information:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              
              _buildDetailRow(Icons.card_membership, 'Package Name', _packageNames[customer.userId] ?? 'N/A'),
              _buildDetailRow(Icons.credit_card, 'Card ID', membershipData['card_id']?.toString() ?? 'N/A'),
              _buildDetailRow(Icons.calendar_today, 'Start Date', _formatDate(membershipData['start_date'])),
              _buildDetailRow(Icons.calendar_month, 'End Date', _formatDate(membershipData['end_date'])),
              _buildDetailRow(
                Icons.info_outline, 
                'Status', 
                membershipData['status']?.toString().toUpperCase() ?? 'N/A'
              ),
              
              const SizedBox(height: 12),
              
              // Status indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(membershipData['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(membershipData['status']).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(membershipData['status']),
                      color: _getStatusColor(membershipData['status']),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(membershipData['status']),
                      style: TextStyle(
                        color: _getStatusColor(membershipData['status']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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

  void _showSimplePackageDialog(Data customer, String packageName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.card_membership, color: AppColors.pinkTheme),
            const SizedBox(width: 8),
            const Text('Package Details'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer: ${customer.fullName ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${customer.email ?? 'N/A'}'),
            const SizedBox(height: 16),
            Text(
              'Package: $packageName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getPackageColor(packageName),
              ),
            ),
          ],
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

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'EXPIRED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return Icons.check_circle;
      case 'EXPIRED':
        return Icons.cancel;
      case 'PENDING':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return 'Active';
      case 'EXPIRED':
        return 'Expired';
      case 'PENDING':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  void _showHealthDetails(Data customer) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final healthData = await HealthService.getHealthByUserId(customer.userId!);

      Navigator.of(context).pop(); // Close loading dialog

      if (healthData != null) {
        _showBeautifulHealthDialog(customer, healthData);
      } else {
        _showNoHealthDataDialog(customer);
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showHealthErrorDialog(customer, e.toString());
    }
  }

  void _showBeautifulHealthDialog(Data customer, Map<String, dynamic> healthData) {
    final weight = healthData['weight']?.toString() ?? 'N/A';
    final height = healthData['height']?.toString() ?? 'N/A';
    final age = healthData['age']?.toString() ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with animated icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red[400]!,
                          Colors.pink[400]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Health',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Customer profile card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.pinkTheme.withOpacity(0.1),
                          Colors.purple[50]!.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.pinkTheme.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pinkTheme.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.pinkTheme,
                                AppColors.pinkTheme.withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.pinkTheme.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: customer.avatar != null 
                                ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${customer.avatar}')
                                : null,
                              child: customer.avatar == null 
                                ? Text(
                                    customer.fullName?.substring(0, 1).toUpperCase() ?? '?',
                                    style: const TextStyle(
                                      fontSize: 24, 
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.pinkTheme,
                                    ),
                                  )
                                : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.fullName ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  customer.email ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Health metrics in a more beautiful layout
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedHealthCard(
                          Icons.monitor_weight_outlined,
                          'Weight',
                          weight != 'N/A' ? '$weight kg' : 'N/A',
                          [Colors.blue[400]!, Colors.cyan[300]!],
                          null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEnhancedHealthCard(
                          Icons.height,
                          'Height',
                          height != 'N/A' ? '$height cm' : 'N/A',
                          [Colors.green[400]!, Colors.teal[300]!],
                          null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedHealthCard(
                          Icons.cake_outlined,
                          'Age',
                          age != 'N/A' ? '$age years' : 'N/A',
                          [Colors.orange[400]!, Colors.amber[300]!],
                          null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (weight != 'N/A' && height != 'N/A')
                        Expanded(
                          child: _buildEnhancedBMICard(double.tryParse(weight), double.tryParse(height)),
                        )
                      else
                        Expanded(
                          child: _buildEnhancedHealthCard(
                            Icons.analytics_outlined,
                            'BMI',
                            'N/A',
                            [Colors.grey[400]!, Colors.grey[300]!],
                            null,
                          ),
                        ),
                    ],
                  ),
                  
                  if (weight != 'N/A' && height != 'N/A') ...[
                    const SizedBox(height: 20),
                    _buildHealthInsights(double.tryParse(weight), double.tryParse(height)),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Enhanced close button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.pinkTheme,
                          AppColors.pinkTheme.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pinkTheme.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHealthCard(IconData icon, String label, String value, List<Color> gradientColors, IconData? secondaryIcon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withOpacity(0.1),
            gradientColors[1].withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gradientColors[0].withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon, 
              size: 28, 
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: gradientColors[0],
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (secondaryIcon != null) ...[
            const SizedBox(height: 4),
            Icon(
              secondaryIcon,
              size: 16,
              color: gradientColors[0].withOpacity(0.6),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedBMICard(double? weight, double? height) {
    if (weight == null || height == null) return const SizedBox.shrink();
    
    final bmi = weight / ((height / 100) * (height / 100));
    final bmiColors = _getBMIGradientColors(bmi);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bmiColors[0].withOpacity(0.1),
            bmiColors[1].withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bmiColors[0].withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: bmiColors[0].withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bmiColors,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: bmiColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.analytics_outlined, 
              size: 28, 
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'BMI',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: bmiColors[0],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInsights(double? weight, double? height) {
    if (weight == null || height == null) return const SizedBox.shrink();
    
    final bmi = weight / ((height / 100) * (height / 100));
    final bmiColors = _getBMIGradientColors(bmi);
    
    String insight = '';
    String recommendation = '';
    
    if (bmi < 18.5) {
      insight = 'BMI indicates underweight';
      recommendation = 'Consider a balanced diet with increased calories';
    } else if (bmi < 24.9) {
      insight = 'BMI is in the healthy range';
      recommendation = 'Maintain current lifestyle with regular exercise';
    } else if (bmi < 29.9) {
      insight = 'BMI indicates overweight';
      recommendation = 'Focus on cardio exercises and balanced nutrition';
    } else {
      insight = 'BMI indicates obesity';
      recommendation = 'Consult with a healthcare professional';
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bmiColors[0].withOpacity(0.08),
            bmiColors[1].withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bmiColors[0].withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: bmiColors,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Health Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            insight,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: bmiColors[0],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recommendation,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getBMIGradientColors(double bmi) {
    if (bmi < 18.5) return [Colors.blue[400]!, Colors.lightBlue[300]!];
    if (bmi < 24.9) return [Colors.green[400]!, Colors.lightGreen[300]!];
    if (bmi < 29.9) return [Colors.orange[400]!, Colors.amber[300]!];
    return [Colors.red[400]!, Colors.deepOrange[300]!];
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal';
    if (bmi < 29.9) return 'Overweight';
    return 'Obesity';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  void _showNoHealthDataDialog(Data customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('No Health Data'),
        content: Text('No health data found for ${customer.fullName}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHealthErrorDialog(Data customer, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Error'),
        content: Text('Failed to load health data for ${customer.fullName}: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}