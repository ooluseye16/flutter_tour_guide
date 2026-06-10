import 'package:flutter/material.dart';
import 'package:flutter_spotlight_tour/flutter_spotlight_tour.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotlight Tour Example',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

// ── Home screen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // One GlobalKey per widget you want to spotlight.
  final _fabKey = GlobalKey();
  final _searchKey = GlobalKey();
  final _tabBarKey = GlobalKey();
  final _settingsKey = GlobalKey();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Kick off the tour after the first frame so all keys are attached.
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTour());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _startTour() async {
    await Tour.show(
      context: context,
      id: 'example_home_v1',
      // Remove `force: true` in a real app — it's here so the tour always
      // plays in this demo even after being seen once.
      force: true,
      theme: const TourTheme(
        accentColor: Color(0xFF6750A4), // matches the purple seed color
        scrimOpacity: 0.70,
        spotlightRadius: 14,
        cardRadius: 18,
      ),
      steps: [
        // Step 1 — FAB (visible right away)
        TourStep(
          targetKey: _fabKey,
          title: 'Create something new',
          body: 'Tap the button to add a new item. It will appear in the list below.',
        ),

        // Step 2 — Search field
        TourStep(
          targetKey: _searchKey,
          title: 'Filter your list',
          body: 'Type here to instantly filter items by name.',
        ),

        // Step 3 — switch to the second tab first, then spotlight the tab bar
        TourStep(
          targetKey: _tabBarKey,
          title: 'Browse by category',
          body: 'Switch between All, Favorites, and Archived.',
          onBefore: () async {
            _tabController.animateTo(1);
            await Future.delayed(const Duration(milliseconds: 300));
          },
        ),

        // Step 4 — settings icon in AppBar
        TourStep(
          targetKey: _settingsKey,
          title: 'Settings',
          body: 'Adjust preferences and replay this tour any time from the settings screen.',
        ),
      ],
      onEnd: () async => debugPrint('Tour ended'),
      onSkip: () async => debugPrint('User skipped the tour'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotlight Tour Demo'),
        actions: [
          IconButton(
            key: _settingsKey,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          key: _tabBarKey,
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
            Tab(text: 'Archived'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              key: _searchKey,
              hintText: 'Search items…',
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _ItemList(label: 'All items'),
                _ItemList(label: 'Favorite items'),
                _ItemList(label: 'Archived items'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dummy list ────────────────────────────────────────────────────────────────

class _ItemList extends StatelessWidget {
  final String label;
  const _ItemList({required this.label});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.circle_outlined),
        title: Text('$label ${i + 1}'),
        subtitle: Text('Subtitle for item ${i + 1}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// ── Settings screen ───────────────────────────────────────────────────────────

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.replay),
            title: const Text('Replay tour'),
            subtitle: const Text('Show the onboarding tour again'),
            onTap: () async {
              // Force-reset so it plays even if already seen.
              await Tour.reset('example_home_v1');
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Reset all tours'),
            subtitle: const Text('Clear every tour\'s "seen" state'),
            onTap: () async {
              await Tour.resetAll();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All tours reset')),
              );
            },
          ),
        ],
      ),
    );
  }
}
