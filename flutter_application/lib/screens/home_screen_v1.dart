import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_banner_slider.dart';
import '../widgets/movie_list_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  late Future<List<Movie>> movies;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    movies = api.fetchMovies();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('🎬 Hot Movies')),
  //     body: FutureBuilder<List<Movie>>(
  //       future: movies,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         if (snapshot.hasError) {
  //           // Show dialog and fallback data
  //           WidgetsBinding.instance.addPostFrameCallback((_){
  //             showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                 title: const Text('Lỗi kết nối'),
  //                 content: const Text(
  //                     'Không thể kết nối đến máy chủ. Dữ liệu hiển thị là tạm thời.'),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: const Text('OK'),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           });
            
  //           // Show default
  //           // Hiển thị dữ liệu mặc định
  //           final fallbackMovies = [
  //             Movie(
  //               id: 201,
  //               title: "Galaxy Heroes: Awakening",
  //               originalTitle: "Galaxy Heroes: Awakening",
  //               slug: "galaxy-heroes-awakening",
  //               duration: 130,
  //               genre: ["Action", "Sci-Fi"],
  //               rating: "C13",
  //               posterUrl: "assets/images/default.jpg",
  //               bannerUrl: "assets/images/default.jpg",
  //               synopsis:
  //                   "A small crew must save a dying star system in an epic space saga.",
  //               category: "dang-chieu",
  //               isHot: true,
  //               releaseDate: "2025-10-10",
  //               theaters: [
  //                 Theater(
  //                   theaterId: "HCM_PLC",
  //                   theaterName: "CGV Parkson Plaza",
  //                   showtimes: [
  //                     Showtime(time: "10:30", format: "2D", price: 90000),
  //                     Showtime(time: "13:40", format: "2D", price: 110000),
  //                     Showtime(time: "19:00", format: "IMAX", price: 220000),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ];
  //           return MovieBannerSlider(movies: fallbackMovies);
  //         }
  //         if (snapshot.hasData) {
  //           final movies = snapshot.data!;
  //           final hotMovies = movies.where((m) => m.isHot).toList();
  //           return Column(
  //             children: [
  //               MovieBannerSlider(movies: hotMovies),
  //               const SizedBox(height: 10),
  //               Expanded(
  //                 child: DefaultTabController(
  //                   length: 3, 
  //                   child: Column(
  //                     children: [
  //                       const TabBar(
  //                         tabs: [
  //                           Tab(text: "Đang chiếu"),
  //                           Tab(text: "Sắp chiếu"),
  //                           Tab(text: "Đặc biệt"),
  //                         ],
  //                       ),
  //                       Expanded(
  //                         child: TabBarView(
  //                           children: [
  //                             MovieListTab(movies: movies, category: "now"),
  //                             MovieListTab(movies: movies, category: "coming"),
  //                             MovieListTab(movies: movies, category: "special"),
  //                           ]
  //                       ))
  //                     ],
  //                   )),
  //               )
  //             ],
  //           );
  //         } else {
  //           return Center(child: Text("Không có dữ liệu!"));
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar cố định
          _buildSliverAppBar(),
          // Nội dung chính
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Nội dung chính (banner, tabs)
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      100, // 100 là chiều cao ước tính của footer
                  child: _buildMainContent(),
                ),
                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(){
    return SliverAppBar(
      pinned: true, // Cố định AppBar trên đầu
      title: const Text('🎬 Hot Movies'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              movies = api.fetchMovies(); // Làm mới dữ liệu
            });
          },
          tooltip: 'Làm mới',
        ),
        // Nút toggle cho login/logout
        PopupMenuButton<String>(
          icon: Icon(isLoggedIn ? Icons.person : Icons.menu),
          onSelected: (value) {
            if (value == 'login') {
              // TODO: Thêm logic đăng nhập
              setState(() {
                isLoggedIn = true;
              });
            } else if (value == 'logout') {
              // TODO: Thêm logic đăng xuất
              setState(() {
                isLoggedIn = false;
              });
            } else if (value == 'profile') {
              // TODO: Thêm logic chuyển đến trang profile
            }
          },
          itemBuilder: (context) => [
            if (!isLoggedIn)
              const PopupMenuItem(
                value: 'login',
                child: Text('Đăng nhập'),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Text('Giới thiệu'),
              ),
            if (isLoggedIn)
              const PopupMenuItem(
                value: 'profile',
                child: Text('Hồ sơ'),
              ),
            if (isLoggedIn)
              const PopupMenuItem(
                value: 'logout',
                child: Text('Đăng xuất'),
              ),
          ],
          tooltip: 'Menu',
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return FutureBuilder<List<Movie>>(
      future: movies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorDialog(context);
          });
          return MovieBannerSlider(movies: _getFallbackMovies());
        }

        if (snapshot.hasData) {
          final movies = snapshot.data!;
          final hotMovies = movies.where((m) => m.isHot).toList();
          return Column(
            children: [
              MovieBannerSlider(movies: hotMovies),
              const SizedBox(height: 10),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: const [
                          Tab(text: 'Đang chiếu'),
                          Tab(text: 'Sắp chiếu'),
                          Tab(text: 'Đặc biệt'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            MovieListTab(movies: movies, category: 'now'),
                            MovieListTab(movies: movies, category: 'coming'),
                            MovieListTab(movies: movies, category: 'special'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('Không có dữ liệu!'));
      },
    );
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi kết nối'),
        content: const Text('Không thể kết nối đến máy chủ. Dữ liệu hiển thị là tạm thời.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Default data
  List<Movie> _getFallbackMovies() {
    return [
      Movie(
        id: 201,
        title: 'Galaxy Heroes: Awakening',
        originalTitle: 'Galaxy Heroes: Awakening',
        slug: 'galaxy-heroes-awakening',
        duration: 130,
        genre: ['Action', 'Sci-Fi'],
        rating: 'C13',
        posterUrl: 'assets/images/default.jpg',
        bannerUrl: 'assets/images/default.jpg',
        synopsis: 'A small crew must save a dying star system in an epic space saga.',
        category: 'dang-chieu',
        isHot: true,
        releaseDate: '2025-10-10',
        theaters: [
          Theater(
            theaterId: 'HCM_PLC',
            theaterName: 'CGV Parkson Plaza',
            showtimes: [
              Showtime(time: '10:30', format: '2D', price: 90000),
              Showtime(time: '13:40', format: '2D', price: 110000),
              Showtime(time: '19:00', format: 'IMAX', price: 220000),
            ],
          ),
        ],
      ),
    ];
  }

  // Footer
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: Colors.grey[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Hot Movies App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Liên hệ: support@hotmovies.app | Hotline: 1900 1234',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.white, size: 24),
                onPressed: () {
                  // TODO: link Facebook
                },
                tooltip: 'Facebook',
              ),
              IconButton(
                icon: const Icon(Icons.email, color: Colors.white, size: 24),
                onPressed: () {
                  // TODO: email
                },
                tooltip: 'Email',
              ),
              IconButton(
                icon: const Icon(Icons.web, color: Colors.white, size: 24),
                onPressed: () {
                  // TODO:  website
                },
                tooltip: 'Website',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Hot Movies. All rights reserved.',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }
}
