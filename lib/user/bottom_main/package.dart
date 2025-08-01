import 'package:flutter/material.dart';
import 'bottom.dart';
import '../../api_service/package_service.dart';
import '../../model/package.dart' as PackageModel;
import '../../theme/app_colors.dart';

class Package {
  final String name;
  final String price;
  final String duration;
  final List<String> features;
  final bool isPopular;

  Package({
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    this.isPopular = false,
  });

  // Factory constructor to create from API
  factory Package.fromApi(PackageModel.Data packageData) {
    return Package(
      name: packageData.packageName ?? 'Unknown Package',
      price: packageData.price != null ? '${packageData.price?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} đ' : 'N/A',
      duration: packageData.durationDays != null ? '${packageData.durationDays} days' : 'N/A',
      features: packageData.description != null ? packageData.description!.split('\n').where((line) => line.trim().isNotEmpty).toList() : ['No features available'],
      isPopular: false, // You can set logic for isPopular if needed
    );
  }
}

class PackagesOverviewPage extends StatefulWidget {
  @override
  State<PackagesOverviewPage> createState() => _PackagesOverviewPageState();
}

class _PackagesOverviewPageState extends State<PackagesOverviewPage> {
  List<Package> packages = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    setState(() { isLoading = true; error = null; });
    try {
      final packageService = PackageService();
      final apiList = await packageService.getAllPackages();
      packages = apiList.map<Package>((packageData) => Package.fromApi(packageData)).toList();
    } catch (e) {
      error = e.toString();
      print('Error fetching packages: $e');
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), 
        title: Text(
          'MEMBERSHIP PACKAGES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.pinkTheme,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.pinkTheme))
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text('Error loading packages', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text(error!, style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchPackages,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : packages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No packages available', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchPackages,
                      color: AppColors.pinkTheme,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Your Perfect Plan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.pinkTheme,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Select the membership that fits your fitness goals',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 24),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: packages.length,
                              separatorBuilder: (context, index) => SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final package = packages[index];
                                return PackageCard(package: package);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            showQRDialog(context);
          } else if (index == 3) {
            // Do nothing
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account');
          }
        },
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  final Package package;

  const PackageCard({Key? key, required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: package.isPopular 
            ? [AppColors.pinkTheme, Color(0xFFFF6B9D)]
            : [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Popular badge
          if (package.isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  '🔥 POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package name
                Text(
                  package.name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: package.isPopular ? Colors.white : AppColors.pinkTheme,
                  ),
                ),
                SizedBox(height: 8),
                
                // Price and duration row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      package.price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: package.isPopular ? Colors.white : Colors.green[700],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: package.isPopular 
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.pinkTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        package.duration,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: package.isPopular ? Colors.white : AppColors.pinkTheme,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Features section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: package.isPopular 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Package Includes:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: package.isPopular ? Colors.white : AppColors.pinkTheme,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(height: 8),
                      ...package.features.take(5).map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 20,
                              color: package.isPopular ? Colors.white : AppColors.pinkTheme,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: package.isPopular ? Colors.white.withOpacity(0.9) : Colors.grey[700],
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

