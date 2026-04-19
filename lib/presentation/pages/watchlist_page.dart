import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';

class WatchlistPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WatchlistMoviesPage(),
            WatchlistTvsPage(),
          ],
        ),
      ),
    );
  }
}
