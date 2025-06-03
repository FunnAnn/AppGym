import 'package:flutter/material.dart';
import 'bottom.dart';

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
}

class PackagesOverviewPage extends StatelessWidget {
  final List<Package> packages = [
    Package(
      name: 'Basic',
      price: '₫700,000 / tháng',
      duration: '1 tháng',
      features: ['Truy cập giờ hành chính', 'Không lớp nhóm', 'Không PT'],
    ),
    Package(
      name: 'Standard',
      price: '₫1,000,000 / tháng',
      duration: '1 tháng',
      features: ['Truy cập 24/7', 'Lớp nhóm đa dạng', 'Tư vấn dinh dưỡng'],
      isPopular: true,
    ),
    Package(
      name: 'Premium',
      price: '₫2,500,000 / 3 tháng',
      duration: '3 tháng',
      features: ['Truy cập 24/7', 'Lớp nhóm đa dạng', 'Huấn luyện viên cá nhân'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gói Thành Viên'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: packages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).size.width > 600 ? 3 : 1, // responsive
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
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3, // "Workout Calendar" tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            // Handle "Scan QR" button tap
            // Example: showDialog(context: context, builder: (_) => ...);
          } else if (index == 3) {
            // Không cần làm gì hết
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
                    'Phổ biến',
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
              'Thời gian: ${package.duration}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'Tính năng:',
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
                  // Xử lý khi chọn gói
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Bạn đã chọn gói ${package.name}')));
                },
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                ),
                child: Text('Chọn gói'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

