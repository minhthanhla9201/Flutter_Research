import 'package:flutter/material.dart';
import 'package:flutter_application/config/app_routes.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../models/movie.dart';
import '../services/api_movie_service.dart';
import '../widgets/movie_banner_slider.dart';
import '../widgets/horizontal_movie_list.dart';
import '../widgets/app_footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ApiMovieService movieApi = ApiMovieService();
  late Future<List<Movie>> movies;
  late TabController _tabController;
  late ScrollController _scrollController;

  List<Movie> hotMovies = [];
  List<Movie> nowPlaying = [];
  List<Movie> comingSoon = [];
  List<Movie> special = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _refreshData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      movies = movieApi.fetchMovies();
    });
  }

  void _onMenuSelected(String value, AuthProvider auth) {
    switch (value) {
      case 'login':
        Navigator.pushNamed(context, AppRoutes.login);
        break;
      case 'logout':
        auth.logout();
        break;
      case 'profile':
        if (auth.user != null){
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Chào ${auth.user?['name']}')));
        }
        break;
      case 'my-ticket':
        Navigator.pushNamed(context, AppRoutes.myTickets);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<List<Movie>>(
              key: ValueKey(movies),
              future: movies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showErrorDialog(context);
                  });
                  final fallback = _getFallbackMovies();
                  return _buildContentWithFallback(fallback, auth);
                }

                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  hotMovies = data.where((m) => m.isHot).toList();
                  nowPlaying = data.where((m) => m.category == 'now').toList();
                  comingSoon = data
                      .where((m) => m.category == 'coming')
                      .toList();
                  special = data.where((m) => m.category == 'special').toList();

                  return _buildMainContent(auth);
                }

                return const Center(child: Text('Không có dữ liệu!'));
              },
            ),
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(AuthProvider auth) {
    return SliverAppBar(
      pinned: true, // Cố định AppBar trên đầu
      title: const Text('🎬 Hot Movies'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
          tooltip: 'Làm mới',
        ),
        // Nút toggle cho login/logout
        PopupMenuButton<String>(
          icon: Icon(auth.isLoggedIn ? Icons.person : Icons.menu),
          onSelected: (value) => _onMenuSelected(value, auth),
          itemBuilder: (context) => [
            if (!auth.isLoggedIn)
              const PopupMenuItem(value: 'login', child: Text('Đăng nhập')),
            const PopupMenuItem(value: 'about', child: Text('Giới thiệu')),
            if (auth.isLoggedIn)
              PopupMenuItem(
                value: 'profile',
                child: Text('Xin chào, ${auth.user?['name'] ?? 'User'}'),
              ),
            if (auth.isLoggedIn)
              PopupMenuItem(
                value: 'my-ticket',
                child: Text('Vé đã đặt'),
              ),
            if (auth.isLoggedIn)
              const PopupMenuItem(value: 'logout', child: Text('Đăng xuất')),
          ],
          tooltip: 'Menu',
        ),
      ],
    );
  }

  // TabBar pined below AppBar
  SliverPersistentHeader _buildSliverTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        tabBar: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Đang chiếu'),
            Tab(text: 'Sắp chiếu'),
            Tab(text: 'Đặc biệt'),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(AuthProvider auth) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildSliverAppBar(auth),
        SliverToBoxAdapter(child: MovieBannerSlider(movies: hotMovies)),
        _buildSliverTabBar(),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(
          child: Container(
            height: 320,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHorizontalList(nowPlaying),
                _buildHorizontalList(comingSoon),
                _buildHorizontalList(special),
              ],
            ),
          ),
        ),

        // FOOTER
        const SliverToBoxAdapter(child: AppFooter()),

        // Only show scroll if height > height of screen
        SliverFillViewport(
          viewportFraction: 1.0,
          delegate: SliverChildListDelegate([const SizedBox.shrink()]),
        ),
      ],
    );
  }

  Widget _buildHorizontalList(List<Movie> movies) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(10),
      child: HorizontalMovieList(movies: movies),
    );
  }

  Widget _buildContentWithFallback(List<Movie> fallback, AuthProvider auth) {
    hotMovies = fallback.where((m) => m.isHot).toList();
    nowPlaying = fallback.where((m) => m.category == 'now').toList();
    comingSoon = fallback.where((m) => m.category == 'coming').toList();
    special = fallback.where((m) => m.category == 'special').toList();
    return _buildMainContent(auth);
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi kết nối'),
        content: const Text(
          'Không thể kết nối đến máy chủ. Dữ liệu hiển thị là tạm thời.',
        ),
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
        synopsis:
            'A small crew must save a dying star system in an epic space saga.',
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
}

// Delegate để TabBar dính
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
