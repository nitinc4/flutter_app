import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> apiData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApiData();
  }

  Future<void> fetchApiData() async {
    final response = await http.get(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'),
    );

    if (response.statusCode == 200) {
      setState(() {
        apiData = json.decode(response.body)['data'] ?? {};
        isLoading = false;
      });
    } else {
      print('Failed to load data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.menu, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search here',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBanner(apiData['banner_one']),
                  buildCategories(apiData['category']),
                  buildSectionTitle('Exclusive for You'),
                  buildProductGrid(apiData['products']),
                  buildSectionTitle('New Arrivals'),
                  buildProductGrid(apiData['new_arrivals']),
                  buildBanner(apiData['banner_two']),
                  buildSectionTitle('Top Selling Products'),
                  buildProductGrid(apiData['top_selling_products']),
                  buildBanner(apiData['banner_three']),
                  buildSectionTitle('Featured Laptops'),
                  buildProductGrid(apiData['featured_laptop']),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildBanner(List<dynamic>? banners) {
    if (banners == null || banners.isEmpty) return SizedBox.shrink();
    return Container(
      height: 180,
      child: PageView(
        children: banners.map((banner) {
          return Image.network(
            banner['banner'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => 
              Image.network('https://via.placeholder.com/400x180?text=Banner'),
          );
        }).toList(),
      ),
    );
  }

  Widget buildCategories(List<dynamic>? categories) {
    if (categories == null || categories.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
          return categoryItem(category['icon'], category['label']);
        }).toList(),
      ),
    );
  }

  Widget categoryItem(String iconUrl, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          backgroundImage: NetworkImage(iconUrl),
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildProductGrid(List<dynamic>? products) {
    if (products == null || products.isEmpty) return SizedBox.shrink();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        var product = products[index];
        return productCard(product);
      },
    );
  }

  Widget productCard(dynamic product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                product['icon'] ?? 'https://via.placeholder.com/150',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Image.network('https://via.placeholder.com/150'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['label'] ?? 'Product Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  product['offer'] != null ? '${product['offer']}% Off' : '',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
