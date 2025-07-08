import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/features/matches/presentation/bloc/matches_bloc.dart';
import 'package:ilike/features/matches/presentation/bloc/matches_event.dart';
import 'package:ilike/features/matches/presentation/bloc/matches_state.dart';
import 'package:ilike/features/matches/domain/entities/match_entity.dart';
import 'package:ilike/features/matches/domain/entities/potential_match_entity.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _matchesScrollController = ScrollController();
  final ScrollController _likesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load initial data
    context.read<MatchesBloc>().add(LoadMatchesEvent());
    context.read<MatchesBloc>().add(LoadLikesEvent());

    // Setup scroll listeners for pagination
    _matchesScrollController.addListener(_onMatchesScroll);
    _likesScrollController.addListener(_onLikesScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _matchesScrollController.dispose();
    _likesScrollController.dispose();
    super.dispose();
  }

  void _onMatchesScroll() {
    if (_matchesScrollController.position.pixels ==
        _matchesScrollController.position.maxScrollExtent) {
      context.read<MatchesBloc>().add(LoadMoreMatchesEvent());
    }
  }

  void _onLikesScroll() {
    if (_likesScrollController.position.pixels ==
        _likesScrollController.position.maxScrollExtent) {
      context.read<MatchesBloc>().add(LoadMoreLikesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: 'Matches'), Tab(text: 'Likes')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Matches Tab
                BlocBuilder<MatchesBloc, MatchesState>(
                  builder: (context, state) {
                    if (state.isMatchesLoading && state.matches.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.matches.isEmpty) {
                      return const Center(
                        child: Text('No matches yet. Keep exploring!'),
                      );
                    }

                    return ListView.builder(
                      controller: _matchesScrollController,
                      itemCount:
                          state.matches.length +
                          (state.isMatchesLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.matches.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final match = state.matches[index];
                        return MatchCard(match: match);
                      },
                    );
                  },
                ),

                // Likes Tab
                BlocBuilder<MatchesBloc, MatchesState>(
                  builder: (context, state) {
                    if (state.isLikesLoading && state.likes.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.likes.isEmpty) {
                      return const Center(
                        child: Text('No likes yet. Keep exploring!'),
                      );
                    }

                    return ListView.builder(
                      controller: _likesScrollController,
                      itemCount:
                          state.likes.length + (state.isLikesLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.likes.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final like = state.likes[index];
                        return LikeCard(like: like);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final MatchEntity match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              match.photoUrls.isNotEmpty
                  ? NetworkImage(match.photoUrls.first)
                  : null,
          child: match.photoUrls.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(match.name),
        subtitle: Text(match.lastMessage ?? 'Start chatting!'),
        trailing:
            match.unreadCount > 0
                ? CircleAvatar(
                  radius: 12,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${match.unreadCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
                : null,
        onTap: () {
          // Navigate to chat screen
          // Navigator.pushNamed(context, '/chat', arguments: match);
        },
      ),
    );
  }
}

class LikeCard extends StatelessWidget {
  final PotentialMatchEntity like;

  const LikeCard({super.key, required this.like});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              like.photoUrls.isNotEmpty
                  ? NetworkImage(like.photoUrls.first)
                  : null,
          child: like.photoUrls.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(like.name),
        subtitle: Text('${like.age} • ${like.location}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.read<MatchesBloc>().add(
                  DislikeUserEvent(userId: like.id),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                context.read<MatchesBloc>().add(LikeUserEvent(userId: like.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
