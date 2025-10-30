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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  final ApiService api = ApiService();
  late Future<List<Movie>> movies;
  bool isLoggedIn = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    movies = api.fetchMovies();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // AppBar cố định
          _buildSliverAppBar(),
          // TabBar cố định (dính liền AppBar)
          _buildSliverTabBar(),
        ],
        body: _buildBody(),
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

  // Body: Banner + Danh sách phim theo tab + Footer ở cuối
  Widget _buildBody() {
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
          return _buildContentWithFallback();
        }

        if (snapshot.hasData) {
          return _buildContent(snapshot.data!);
        }

        return const Center(child: Text('Không có dữ liệu!'));
      },
    );
  }

  Widget _buildContent(List<Movie> movies) {
    final hotMovies = movies.where((m) => m.isHot).toList();
    final nowPlaying = movies.where((m) => m.category == 'now').toList();
    final comingSoon = movies.where((m) => m.category == 'coming').toList();
    final special = movies.where((m) => m.category == 'special').toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: MovieBannerSlider(movies: hotMovies)),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverFillRemaining(
          hasScrollBody: true,
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildHorizontalMovieList(nowPlaying),
              _buildHorizontalMovieList(comingSoon),
              _buildHorizontalMovieList(special)
            ],
          ),
        ),

        SliverToBoxAdapter(child: _buildFooter())
      ],
    );
  }

  Widget _buildContentWithFallback() {
    final fallback = _getFallbackMovies();
    final hotMovies = fallback.where((m) => m.isHot).toList();
    return _buildContent(fallback..addAll(hotMovies));
  }

  // Danh sách phim ngang (giống banner)
  Widget _buildHorizontalMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text('Không có phim'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.posterUrl,
                  height: 200,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                movie.genre.join(', '),
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
        );
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

// Delegate để TabBar dính
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate({required this.tabBar});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}