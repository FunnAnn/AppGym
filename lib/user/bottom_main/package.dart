import 'package:flutter/material.dart';
import 'bottom.dart';
import '../../api_service/package_service.dart';
import '../../model/package.dart' as PackageModel;

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
      appBar: AppBar(
        title: Text('Membership Packages'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          itemCount: packages.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 3 / 4,
                          ),
                          itemBuilder: (context, index) {
                            final package = packages[index];
                            return PackageCard(package: package);
                          },
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
            // Handle "Scan QR" button tap
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (package.isPopular)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 8),
            Text(
              package.name,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              package.price,
              style: TextStyle(fontSize: 18, color: Colors.green[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Duration: ${package.duration}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'Features:',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            ...package.features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                )),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle package selection
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('You have selected the ${package.name} package')));
                },
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                ),
                child: Text('See Details'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

