/// A lightweight, themeable Flutter tour guide with spotlight cutouts,
/// auto-scroll, tab/page navigation, and per-screen persistence.
///
/// ## Basic usage
///
/// ```dart
/// final _myKey = GlobalKey();
///
/// // In initState, after first frame:
/// WidgetsBinding.instance.addPostFrameCallback((_) {
///   Tour.show(
///     context: context,
///     id: 'home_screen',
///     steps: [
///       TourStep(
///         targetKey: _myKey,
///         title: 'Welcome',
///         body: 'This is the main action button.',
///       ),
///     ],
///   );
/// });
///
/// // In build:
/// FloatingActionButton(key: _myKey, ...)
/// ```
///
/// ## Theming
///
/// ```dart
/// Tour.show(
///   context: context,
///   id: 'onboarding',
///   theme: TourTheme(accentColor: Colors.blue),
///   steps: [...],
/// );
/// ```
///
/// ## Restart tours
///
/// ```dart
/// // Reset one tour
/// await Tour.reset('home_screen');
///
/// // Reset all tours (e.g. from a settings page)
/// await Tour.resetAll();
/// ```
library;

export 'src/tour.dart';
export 'src/tour_step.dart';
export 'src/tour_theme.dart';
