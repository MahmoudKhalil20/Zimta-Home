import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Zimta/classes/app_colors.dart';
import 'package:Zimta/tools/api.dart';

class Mahmudhome extends StatefulWidget {
  const Mahmudhome({Key? key}) : super(key: key);

  @override
  MahmudhomeState createState() => MahmudhomeState();
}

class MahmudhomeState extends State<Mahmudhome> {
  final TextEditingController searchController = TextEditingController();
  final PageController pageController = PageController();
  bool isLoading = false;
  dynamic bannerData;
  dynamic iconData;
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchBannerData();
    fetchIconData();
    startSlideshow();
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchBannerData() async {
    Map<String, String> data = {"view": "mobile"};
    setState(() {
      isLoading = true;
    });
    try {
      await Api.post('/motor/v1/index.php?route=common/widgets', jsonEncode(data), onSuccess: (response) async {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          bannerData = jsonData['data'][0];
        });
      }, onError: (response) {
        final Map<String, dynamic> jsonData = jsonDecode(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: AppColors.white,
            backgroundColor: const Color.fromARGB(255, 168, 59, 51),
            content: Text(jsonData['title']),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        );
      });
    } catch (e) {
      print('Error fetching banner data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchIconData() async {
    Map<String, String> data = {"view": "mobile"};
    setState(() {
      isLoading = true;
    });
    try {
      await Api.post('/motor/v1/index.php?route=common/widgets', jsonEncode(data), onSuccess: (response) async {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          iconData = jsonData['data'][1];
        });
      }, onError: (response) {
        final Map<String, dynamic> jsonData = jsonDecode(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            closeIconColor: AppColors.white,
            backgroundColor: const Color.fromARGB(255, 168, 59, 51),
            content: Text(jsonData['title']),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        );
      });
    } catch (e) {
      print('Error fetching icon data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startSlideshow() {
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        final itemLength = (bannerData['items']?.length ?? 1).toInt();
        int IL = itemLength;
        currentPage = (currentPage + 1) % IL;
        pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void navigateToCategoryPage(String categoryName) {
    // Navigate to a new page with the category details
    // Replace with your navigation logic
    print('Navigating to $categoryName category page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zymta'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (bannerData != null)
                        Container(
                          height: 200,
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: bannerData['items']?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = bannerData['items'][index];
                              return Image.network(
                                item['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Center(child: Text('Failed to load image', style: TextStyle(color: Colors.red)));
                                },
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 16),
                      if (iconData != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                              itemCount: iconData['items']?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = iconData['items'][index];
                                return GestureDetector(
                                  onTap: () => navigateToCategoryPage(item['name']),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            item['image'],
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Center(child: Text('Failed to load image', style: TextStyle(color: Colors.red)));
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        item['name'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle "See All" button action
                                  print('See All pressed');
                                },
                                child: Text(
                                  'See All',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
