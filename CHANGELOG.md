## 0.1.0

Initial public release.

- `Tour.show` — display a spotlight tour with automatic "already seen" persistence via `shared_preferences`.
- `TourStep` — per-step title, body, optional spotlight padding/radius, and an `onBefore` async hook for tab/page navigation.
- `TourTheme` — fully themeable: accent color, scrim opacity, card styles, spotlight shape, and more.
- `Tour.reset` / `Tour.resetAll` — clear one or all tours' seen state.
- Auto-scroll via `Scrollable.ensureVisible` so list items are always in view before a step appears.
- Fade animation between steps.
- Tooltip positioned above or below the target depending on available space, with an arrow pointer.
