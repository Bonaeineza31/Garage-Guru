# GarageGuru - Vehicle Repair Services App

A Flutter mobile application that connects vehicle owners with nearby repair shops and mechanics. This is the **frontend-only** implementation with all UI screens fully functional and interactive.

## 📱 Features Implemented (Frontend)

### ✅ Completed Screens
1. **Home Screen**
   - Interactive map view
   - Quick action buttons (Emergency Repair, Schedule Repair, Repair Updates)
   - Quick Services section (Oil Change, Tire Service, Battery, Add Vehicle)
   - Nearby Garages list with ratings
   - Upcoming Maintenance alerts

2. **Emergency Repair Screen**
   - Location input with "use current location" option
   - Issue description field
   - Emergency contact information
   - Form validation
   - Request submission with confirmation dialog

3. **Request Repair Screen**
   - Repair type selection
   - Date and time pickers
   - Location input
   - Vehicle selection dropdown
   - Issue description
   - Complete form validation

4. **Tire Service Screen**
   - Service options display (Replacement, Rotation, Alignment, Pressure)
   - Service type selection
   - Garage selection
   - Date/time booking
   - Vehicle selection

5. **Battery Service Screen**
   - Battery service options (Replacement, Testing, Charging System, Jump Start)
   - Complete booking form
   - Garage and vehicle selection
   - Form validation

6. **Navigation Screens** (Placeholders for backend)
   - Map Screen
   - Garages Screen
   - Repairs Screen
   - Profile Screen

### 🎨 UI/UX Features
- ✅ Exact color scheme matching the design
- ✅ Consistent bottom navigation across screens
- ✅ Interactive buttons and form elements
- ✅ Form validation with error messages
- ✅ Success dialogs after form submissions
- ✅ Responsive layout for different screen sizes
- ✅ Custom theme matching brand colors

## 🏗️ Project Structure

```
garageguru_app/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/
│   │   └── theme/
│   │       └── app_theme.dart             # Theme configuration & colors
│   └── presentation/
│       ├── screens/
│       │   ├── home_screen.dart           # Main home screen
│       │   ├── emergency_repair_screen.dart
│       │   ├── request_repair_screen.dart
│       │   ├── tire_service_screen.dart
│       │   ├── battery_service_screen.dart
│       │   ├── map_screen.dart
│       │   ├── garages_screen.dart
│       │   ├── repairs_screen.dart
│       │   └── profile_screen.dart
│       └── widgets/
│           └── app_bottom_navigation.dart # Reusable bottom nav
└── pubspec.yaml                           # Dependencies
```

### 📂 Folder Organization
Following Flutter Clean Architecture principles:

- **`core/`** - Contains app-wide configurations (theme, constants)
- **`presentation/`** - UI layer with screens and widgets
  - **`screens/`** - Full page screens
  - **`widgets/`** - Reusable UI components

When adding backend (Phase 2), you'll add:
- **`data/`** - Repositories, data sources, models
- **`domain/`** - Business logic, entities, use cases
- **`config/`** - Firebase and API configurations

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- A physical Android/iOS device or emulator

### Installation Steps

1. **Clone or download this project**
   ```bash
   cd garageguru_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific device
   flutter run -d <device_id>
   
   # To see available devices
   flutter devices
   ```

4. **Build the app**
   ```bash
   # Android APK
   flutter build apk
   
   # iOS (requires macOS)
   flutter build ios
   ```

## 🎨 Design System

### Colors
- **Primary Blue**: `#0EA5E9` - Main buttons and accents
- **Emergency Orange**: `#FF6B35` - Emergency repair actions
- **Schedule Blue**: `#0284C7` - Schedule repair button
- **Repair Green**: `#10B981` - Repair updates button
- **Background**: `#F8FAFC` - App background
- **Text Primary**: `#0F172A` - Main text
- **Text Secondary**: `#64748B` - Secondary text

### Typography
- Display: Bold, 24-32px
- Headlines: Semi-bold, 18-20px
- Body: Regular, 14-16px
- Labels: Medium, 14px

## ✨ Interactive Features

All buttons and forms are functional:
- ✅ Navigation between screens
- ✅ Date and time pickers
- ✅ Dropdown selections
- ✅ Form validation
- ✅ Success/error messages
- ✅ Interactive maps (placeholder)
- ✅ Bottom navigation

## 🔜 Next Steps (Backend Integration)

For the complete implementation, you'll need to add:

1. **Firebase Setup**
   - Authentication (Email/Password, Google Sign-In)
   - Firestore for data storage
   - Firebase Storage for images

2. **State Management**
   - BLoC pattern implementation
   - Event/State architecture
   - Repository pattern

3. **API Integration**
   - Google Maps API for real map
   - Location services
   - Push notifications

4. **Data Models**
   - User model
   - Vehicle model
   - Repair request model
   - Garage model

## 📝 Code Quality

- ✅ Clean, readable code with comments
- ✅ Proper file organization
- ✅ Reusable widgets
- ✅ Consistent naming conventions
- ✅ No hardcoded values (using theme constants)
- ✅ Proper error handling

## 🎯 Testing Checklist

Before submitting, test:
- [ ] All screens load without errors
- [ ] Bottom navigation works on all screens
- [ ] All buttons are clickable and responsive
- [ ] Forms validate correctly
- [ ] Date/time pickers work
- [ ] Dropdowns show options
- [ ] Success dialogs appear after form submission
- [ ] Back navigation works properly
- [ ] App runs on physical device (not just emulator)

## 👥 Team Collaboration

This is set up for easy team collaboration:
- Each screen is in its own file
- Widgets are reusable
- Theme is centralized
- Easy to add new screens
- Clear folder structure

## 📱 Running on Physical Device

**Android:**
1. Enable Developer Options on your phone
2. Enable USB Debugging
3. Connect phone via USB
4. Run `flutter run`

**iOS:**
1. Connect iPhone via USB
2. Trust the computer on your device
3. Run `flutter run`

## 🐛 Troubleshooting

**"Flutter not found"**
```bash
flutter doctor
```

**Dependencies error**
```bash
flutter clean
flutter pub get
```

**Build issues**
```bash
flutter clean
flutter pub get
flutter run
```

## 📄 License

This project is for academic purposes as part of the Mobile Application Development course.

---

**Note**: This is the frontend-only version. Backend integration with Firebase, authentication, and database will be added in Phase 2 of the project.