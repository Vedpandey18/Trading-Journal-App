# Trading Journal Frontend

Flutter web/mobile application with premium fintech UI.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK installed
- Backend running on `http://localhost:8081`

### Run Application
```bash
cd frontend
flutter pub get
flutter run -d chrome
```

## 📱 Features

- **Premium Dark Mode UI** - Glassmorphic design with dark gradient backgrounds
- **Responsive Design** - Works on mobile, tablet, and desktop
- **Real-time Analytics** - P&L curves, equity curves, monthly charts
- **Fast Loading** - Optimized for instant UI rendering
- **Trade Management** - Add, edit, delete trades with lot-based calculations

## 🏗️ Project Structure

```
lib/
├── main.dart / main_new.dart    # App entry points
├── screens/                      # UI screens
│   ├── auth/                    # Login/Register (premium UI)
│   ├── dashboard/               # Dashboard (premium UI)
│   ├── trades/                  # Trade list (premium UI)
│   ├── add_trade/               # Add trade (premium UI)
│   ├── analytics/               # Analytics (premium UI)
│   └── profile/                 # Profile & settings
├── providers/                   # State management
│   ├── auth_provider.dart
│   ├── trade_provider.dart
│   ├── theme_provider.dart
│   └── subscription_provider.dart
├── widgets/                     # Reusable widgets
│   ├── premium_kpi_card.dart
│   ├── advanced_charts.dart
│   └── loading_skeleton.dart
├── theme/                       # Design system
│   └── premium_theme.dart       # Dark mode theme
└── services/                    # API services
    ├── api_service.dart
    └── razorpay_service.dart
```

## 🎨 Design System

- **Dark Mode Only** - Premium dark gradient backgrounds
- **Glassmorphism** - Semi-transparent cards with blur effects
- **Responsive Breakpoints**:
  - Mobile: < 600px
  - Tablet: 600px - 1024px
  - Desktop: ≥ 1024px

## ⚡ Performance

- Instant UI rendering (<100ms)
- Cached chart data
- Parallel API calls
- Optimized rebuilds

## 🔧 Configuration

### API URL
Update `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8081/api';
```

### Razorpay
Update `lib/services/razorpay_service.dart`:
```dart
static const String razorpayKeyId = 'your-razorpay-key-id';
```

## 📦 Build

### Web
```bash
flutter build web
```

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```
