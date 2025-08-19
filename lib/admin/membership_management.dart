import 'package:flutter/material.dart';
import '../api_service/membership_service.dart';
import '../model/membership.dart' as MembershipModel;
import 'admin_layout.dart';
import '../theme/app_colors.dart';

class MembershipManagementPage extends StatefulWidget {
  const MembershipManagementPage({super.key});

  @override
  State<MembershipManagementPage> createState() => _MembershipManagementPageState();
}

class _MembershipManagementPageState extends State<MembershipManagementPage> {
  List<MembershipModel.Data> _memberships = [];
  List<MembershipModel.Data> _filteredList = [];
  bool _isLoading = true;
  String _customerFilter = '';
  String _statusFilter = 'All Status';
  final TextEditingController _customerController = TextEditingController();

  final List<String> _statuses = ['All Status', 'ACTIVE', 'EXPIRED', 'PENDING'];

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

      final membershipCards = await MembershipService.getAllMembershipCards();
      final memberships = membershipCards.map((card) => MembershipModel.Data.fromJson(card)).toList();

      setState(() {
        _memberships = memberships;
        _filteredList = memberships;
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
      _filteredList = _memberships.where((membership) {
        final customerMatch = _customerFilter.isEmpty ||
            membership.customers?.users?.fullName?.toLowerCase().contains(_customerFilter.toLowerCase()) == true;
        final statusMatch = _statusFilter == 'All Status' || 
                           membership.status?.toUpperCase() == _statusFilter.toUpperCase();
        
        return customerMatch && statusMatch;
      }).toList();
    });
  }

  void _onCustomerFilterChanged(String value) {
    setState(() {
      _customerFilter = value;
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
      case 'EXPIRED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMembershipCard(MembershipModel.Data membership, int index) {
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(membership.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    membership.status?.toUpperCase() ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Customer Information
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.pinkTheme,
                  backgroundImage: membership.customers?.users?.avatar != null 
                    ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${membership.customers!.users!.avatar}')
                    : null,
                  child: membership.customers?.users?.avatar == null 
                    ? Text(
                        membership.customers?.users?.fullName?.substring(0, 1).toUpperCase() ?? '?',
                        style: const TextStyle(
                          fontSize: 18, 
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
                        membership.customers?.users?.fullName ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        membership.customers?.users?.email ?? 'N/A',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view_customer',
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 16),
                          SizedBox(width: 8),
                          Text('View Customer'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'view_package',
                      child: Row(
                        children: [
                          Icon(Icons.card_membership, size: 16),
                          SizedBox(width: 8),
                          Text('View Package'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'view_customer':
                        _showCustomerDetails(membership);
                        break;
                      case 'view_package':
                        _showPackageDetails(membership);
                        break;
                      case 'edit':
                        // Implement edit functionality
                        break;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Membership Information Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.card_membership, 'Package', membership.packages?.packageName ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_today, 'Start Date', _formatDate(membership.startDate)),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_month, 'End Date', _formatDate(membership.endDate)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.attach_money, 'Price', _formatPrice(membership.packages?.price)),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.access_time, 'Duration', '${membership.packages?.durationDays ?? 0} days'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.phone, 'Phone', membership.customers?.users?.phoneNumber ?? 'N/A'),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(int? price) {
    if (price == null) return 'N/A';
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} đ';
  }

  void _showCustomerDetails(MembershipModel.Data membership) {
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
              _buildDetailRow(Icons.person, 'Name', membership.customers?.users?.fullName ?? 'N/A'),
              _buildDetailRow(Icons.email, 'Email', membership.customers?.users?.email ?? 'N/A'),
              _buildDetailRow(Icons.phone, 'Phone', membership.customers?.users?.phoneNumber ?? 'N/A'),
              _buildDetailRow(Icons.cake, 'Date of Birth', _formatDate(membership.customers?.users?.dateOfBirth)),
              _buildDetailRow(Icons.badge, 'Role', membership.customers?.users?.role ?? 'N/A'),
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

  void _showPackageDetails(MembershipModel.Data membership) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Package Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.card_membership, 'Package Name', membership.packages?.packageName ?? 'N/A'),
              _buildDetailRow(Icons.attach_money, 'Price', _formatPrice(membership.packages?.price)),
              _buildDetailRow(Icons.access_time, 'Duration', '${membership.packages?.durationDays ?? 0} days'),
              _buildDetailRow(Icons.description, 'Description', membership.packages?.description ?? 'No description'),
              const SizedBox(height: 16),
              const Text('Membership Period:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.calendar_today, 'Start Date', _formatDate(membership.startDate)),
              _buildDetailRow(Icons.calendar_month, 'End Date', _formatDate(membership.endDate)),
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
                          Icon(Icons.card_membership, color: AppColors.pinkTheme, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'Membership list',
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
                          controller: _customerController,
                          decoration: InputDecoration(
                            hintText: 'Search by customer name...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _customerFilter.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _customerController.clear();
                                      _onCustomerFilterChanged('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onChanged: _onCustomerFilterChanged,
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
                'Showing ${_filteredList.length} of ${_memberships.length} results',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Membership List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.card_membership_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No memberships found',
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
                              return _buildMembershipCard(_filteredList[index], index);
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
    _customerController.dispose();
    super.dispose();
  }
}
