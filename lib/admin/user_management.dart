import 'package:flutter/material.dart';
import '../api_service/user_service.dart';
import '../model/user.dart' as UserModel;
import 'admin_layout.dart';
import '../theme/app_colors.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<UserModel.Data> _users = [];
  List<UserModel.Data> _filteredUsers = [];
  bool _isLoading = true;
  String _selectedRole = 'All Roles';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _roles = ['All Roles', 'OWNER', 'ADMIN', 'COACH', 'CUSTOMER'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userService = UserService();
      final users = await userService.getAllUsers();
      
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading users: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterUsers() {
    setState(() {
      // No role-based filtering - show all users
      _filteredUsers = _users.where((user) {
        final matchesRole = _selectedRole == 'All Roles' || 
                           user.role?.toUpperCase() == _selectedRole.toUpperCase();
        final matchesSearch = _searchQuery.isEmpty ||
                             user.fullName?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
                             user.email?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
        
        return matchesRole && matchesSearch;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterUsers();
  }

  void _onRoleChanged(String? role) {
    setState(() {
      _selectedRole = role ?? 'All Roles';
    });
    _filterUsers();
  }

  Color _getRoleColor(String? role) {
    switch (role?.toUpperCase()) {
      case 'OWNER':
        return Colors.red;
      case 'ADMIN':
        return AppColors.pinkTheme;
      case 'COACH':
        return Colors.orange;
      case 'CUSTOMER':
        return Colors.green;
      default:
        return Colors.grey;
    }
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

  void _showUserDetails(UserModel.Data user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: user.avatar != null 
                ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${user.avatar}')
                : null,
              backgroundColor: AppColors.pinkTheme,
              child: user.avatar == null 
                ? Text(
                    user.fullName?.substring(0, 1).toUpperCase() ?? '?',
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.fullName ?? 'N/A',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.role?.toUpperCase() ?? 'N/A',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // Limit height to 60% of screen
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Basic Information and Coach Information tabs
              if (user.role?.toUpperCase() == 'COACH') ...[
                DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        labelColor: AppColors.pinkTheme,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.pinkTheme,
                        tabs: const [
                          Tab(text: 'Basic Information'),
                          Tab(text: 'Coach Information'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4, // Responsive height
                        child: TabBarView(
                          children: [
                            _buildBasicInfo(user),
                            _buildCoachInfo(user),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Flexible(
                  child: SingleChildScrollView(
                    child: _buildBasicInfo(user),
                  ),
                ),
              ],
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

  Widget _buildBasicInfo(UserModel.Data user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.email, 'Email', user.email ?? 'N/A'),
        _buildDetailRow(Icons.phone, 'Phone Number', user.phoneNumber ?? 'N/A'),
        _buildDetailRow(Icons.cake, 'Date of Birth', _formatDate(user.dateOfBirth)),
        _buildDetailRow(
          user.gender == true ? Icons.male : Icons.female,
          'Gender',
          user.gender == true ? 'Male' : user.gender == false ? 'Female' : 'N/A',
        ),
      ],
    );
  }

  Widget _buildCoachInfo(UserModel.Data user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.star, 'Specialization', 'Not specified'),
          _buildDetailRow(Icons.info, 'Bio', 'No bio available'),
          _buildDetailRow(Icons.star_rate, 'Average Rating', 'No ratings yet'),
          const SizedBox(height: 16),
          Text(
            'Customers (${user.coachCustomers?.length ?? 0})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (user.coachCustomers != null && user.coachCustomers!.isNotEmpty) ...[
            Container(
              height: 200, // Fixed height for customer list
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: user.coachCustomers!.length,
                itemBuilder: (context, index) {
                  final customerRelation = user.coachCustomers![index];
                  final customerUser = _getCustomerById(customerRelation.customerId);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundImage: customerUser?.avatar != null 
                          ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${customerUser!.avatar}')
                          : null,
                        backgroundColor: Colors.green,
                        child: customerUser?.avatar == null 
                          ? Text(
                              customerUser?.fullName?.substring(0, 1).toUpperCase() ?? 
                              customerRelation.customerId?.toString().substring(0, 1) ?? '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )
                          : null,
                      ),
                      title: Text(
                        customerUser?.fullName ?? 'Customer ${customerRelation.customerId}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      subtitle: Text(
                        customerUser?.email ?? 'No email available',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      trailing: Text(
                        customerUser?.gender == true ? 'M' : 
                        customerUser?.gender == false ? 'F' : 'M',
                        style: TextStyle(
                          color: Colors.grey[500], 
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            Container(
              height: 100,
              child: Center(
                child: Text(
                  'No customers assigned',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  UserModel.Data? _getCustomerById(int? customerId) {
    if (customerId == null) return null;
    try {
      return _users.firstWhere(
        (user) => user.userId == customerId,
      );
    } catch (e) {
      return null;
    }
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
            // Search and Filter Section
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
                  // Add title for the page
                  Row(
                    children: [
                      Icon(Icons.people, color: AppColors.pinkTheme, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'User Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pinkTheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.pinkTheme),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 16),
                  // Role Filter
                  Row(
                    children: [
                      const Text(
                        'Role: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: _roles.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: _onRoleChanged,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${_filteredUsers.length} of ${_users.length} users',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),

            // User List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredUsers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No users found',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                              if (_searchQuery.isNotEmpty || _selectedRole != 'All Roles') ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filter',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                ),
                              ],
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadUsers,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredUsers.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () => _showUserDetails(user),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Avatar
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: user.avatar != null 
                                            ? NetworkImage('https://splendid-wallaby-ethical.ngrok-free.app/public/images/${user.avatar}')
                                            : null,
                                          backgroundColor: AppColors.pinkTheme,
                                          child: user.avatar == null 
                                            ? Text(
                                                user.fullName?.substring(0, 1).toUpperCase() ?? '?',
                                                style: const TextStyle(
                                                  fontSize: 18, 
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : null,
                                        ),
                                        const SizedBox(width: 16),
                                      
                                        // User Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.fullName ?? 'N/A',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                user.email ?? 'N/A',
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                user.phoneNumber ?? 'N/A',
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      
                                        // Role Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getRoleColor(user.role),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            user.role?.toUpperCase() ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}