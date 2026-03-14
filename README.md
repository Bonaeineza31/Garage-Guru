# GarageGuru

> A premium Flutter mobile application for finding and booking trusted garage services. A two-sided marketplace connecting **customers** with **garage owners** — featuring a polished UI with gradient accents, smooth animations, and a cohesive deep navy & vibrant orange design system.

---

## Features

### Customer Experience
- **Smart Home Feed** — Browse garages with a frosted-glass search bar, horizontal category chips, nearby map cards, and top-rated listings
- **Interactive Map** — Discover garages on a map with animated markers and swipeable preview cards
- **Garage Detail** — Collapsing cover image with gradient overlay, tabbed layout (About, Services, Reviews), one-tap call/chat/book actions
- **3-Step Booking Wizard** — Select services → Pick date & time → Enter vehicle details, with a glowing step indicator
- **Secure Payment** — Multiple payment methods (card, PayPal, cash), gradient pay button, animated success screen with confetti-style confirmation
- **Booking History** — Upcoming & completed tabs with color-coded status badges, pull-to-view detail sheets
- **Profile & Settings** — Gradient profile header with stats, organized menu with notification badges

### Garage Owner Experience
- **Live Dashboard** — Stat cards with trend indicators, today's appointment timeline, recent customer reviews
- **Booking Management** — 4-tab workflow (Pending → Confirmed → In Progress → Completed) with accept/decline/complete actions
- **Service Management** — Full CRUD with bottom sheet form, category picker, toggle active/inactive
- **Garage Profile** — Cover photo management, contact info, working hours editor, gallery with add-photo button

### Design System
- **Color Palette** — Deep navy (#1E3A5F) primary with vibrant orange (#FF6B35) accent, success greens, and warm star gold
- **Gradient Effects** — Hero gradients on headers, primary gradient on CTAs, accent gradients on selected states
- **Typography** — Poppins font family across 4 weights with precise letter-spacing
- **Consistent Radii** — From `sm` (8px) to `pill` (100px) border radius tokens
- **Shadow System** — Layered card, elevated, and button shadows for depth

---

## Project Structure

```
lib/
├── main.dart                          # App entry point with system UI configuration
├── core/
│   └── theme/
│       ├── app_theme.dart             # Design tokens: colors, gradients, typography, spacing, shadows
│       └── theme_data.dart            # Material 3 ThemeData configuration
├── models/
│   ├── user_model.dart                # User with role, profile, contact info
│   ├── garage_model.dart              # Garage with hours, location, specializations
│   ├── service_model.dart             # Service with pricing, duration, category
│   ├── booking_model.dart             # Booking with status workflow, vehicle info
│   ├── review_model.dart              # Review with ratings, images, owner replies
│   └── models.dart                    # Barrel export
├── data/
│   └── mock_data.dart                 # Development data: 4 garages, 8 services, 4 reviews, 3 bookings
├── widgets/
│   ├── gg_button.dart                 # Primary button with gradient support + chip button
│   ├── gg_text_field.dart             # Styled text field + frosted-glass search bar
│   ├── garage_card.dart               # Full, compact, and map card variants
│   ├── service_card.dart              # Selectable service card with category icons + tag
│   ├── booking_card.dart              # Status-aware booking card with service breakdown
│   ├── review_card.dart               # Review card with avatar, rating pill + rating summary
│   ├── common_widgets.dart            # AppBar, SectionHeader, EmptyState, UserAvatar, InfoRow, StatCard
│   └── widgets.dart                   # Barrel export
└── screens/
    ├── auth/
    │   ├── login_screen.dart          # Animated login with gradient logo, social sign-in
    │   └── register_screen.dart       # Role-based registration (customer / garage owner)
    ├── customer/
    │   ├── customer_shell.dart        # Bottom nav: Home, Map, Bookings, Profile
    │   ├── home_screen.dart           # Gradient header, categories, nearby + top rated
    │   ├── map_screen.dart            # Map with markers, search overlay, card carousel
    │   ├── garage_detail_screen.dart  # Collapsing header, 3 tabs, bottom action bar
    │   ├── booking_screen.dart        # 3-step wizard with progress indicator
    │   ├── payment_screen.dart        # Order summary, method selection, success state
    │   ├── bookings_list_screen.dart  # Upcoming/history tabs with detail sheets
    │   └── profile_screen.dart        # Gradient header, stats row, settings menu
    └── owner/
        ├── owner_shell.dart           # Bottom nav: Dashboard, Bookings, Services, Profile
        ├── owner_dashboard_screen.dart# Stats grid, appointments, recent reviews
        ├── owner_bookings_screen.dart # 4-status tab management
        ├── manage_services_screen.dart# Service CRUD with bottom sheet form
        └── garage_profile_screen.dart # Cover image, contact, hours, gallery
```

---

## Getting Started

### Prerequisites
- Flutter SDK 3.2 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd Garage-Guru

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Demo Accounts
The app uses mock data for demonstration. Sign in with any email/password to explore:
- **Customer flow** — Register as "Customer" to browse garages, book services, and manage bookings
- **Owner flow** — Register as "Garage Owner" to access the dashboard, manage bookings and services

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.2+ / Dart |
| Design | Material Design 3, custom design tokens |
| State | Provider (architecture-ready) |
| Maps | Google Maps Flutter, Geolocator, Geocoding |
| UI Components | cached_network_image, flutter_rating_bar, shimmer, smooth_page_indicator |
| Utilities | intl (date formatting), image_picker, table_calendar, url_launcher |
| Typography | Poppins (Google Fonts) |

---

## Design Tokens

### Color Palette
| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#1E3A5F` | Headers, nav, buttons |
| Primary Dark | `#0F2440` | Gradient endpoints |
| Primary Medium | `#2B5C8A` | Gradient midpoints |
| Accent | `#FF6B35` | CTAs, highlights, links |
| Success | `#10B981` | Confirmations, open status |
| Warning | `#F59E0B` | Pending states |
| Error | `#EF4444` | Errors, cancel, closed status |
| Star Filled | `#FBBF24` | Ratings |

### Gradients
- **Primary** — Deep navy to medium blue (buttons, selected states)
- **Accent** — Orange to coral (highlights)
- **Hero** — Dark navy to medium blue (screen headers)
- **Success** — Emerald to teal (confirmation states)

---

## Architecture

The app follows a **feature-first** folder structure with clear separation:

- **Models** — Immutable data classes with computed properties (e.g., `formattedPrice`, `statusLabel`, `timeAgo`)
- **Widgets** — Reusable, stateless UI components that accept models and callbacks
- **Screens** — Stateful screens that compose widgets and handle navigation
- **Theme** — Centralized design tokens consumed by all widgets and screens

Navigation uses Flutter's built-in `Navigator` with `MaterialPageRoute`. The customer and owner experiences are separated by shell widgets (`CustomerShell`, `OwnerShell`) with `IndexedStack` for tab persistence.

---

## License

This project is developed as part of an academic research and design initiative.