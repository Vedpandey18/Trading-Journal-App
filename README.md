# Trading Journal

A modern, premium fintech-grade trading journal application built with Flutter (frontend) and Spring Boot (backend).

## 🚀 Features

- **Premium Dark Mode UI** - Glassmorphic design with dark gradient backgrounds
- **Real-time Analytics** - P&L curves, equity curves, daily/monthly charts
- **Trade Management** - Add, edit, delete trades with lot-based calculations
- **Responsive Design** - Works seamlessly on mobile, tablet, and desktop
- **Fast Performance** - Optimized for instant UI rendering and smooth scrolling
- **Subscription Plans** - Razorpay integration for premium features

## 📁 Project Structure

```
Trading/
├── frontend/          # Flutter web/mobile application
│   ├── lib/
│   │   ├── screens/   # UI screens
│   │   ├── widgets/   # Reusable widgets
│   │   ├── providers/ # State management
│   │   ├── services/  # API services
│   │   └── theme/     # Design system
│   └── pubspec.yaml
│
├── backend/           # Spring Boot REST API
│   ├── src/
│   │   └── main/
│   │       ├── java/  # Java source code
│   │       └── resources/ # Configuration files
│   └── pom.xml
│
└── README.md
```

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **fl_chart** - Advanced charting library
- **Dio** - HTTP client
- **Razorpay** - Payment gateway

### Backend
- **Spring Boot** - Java framework
- **MySQL** - Database
- **JWT** - Authentication
- **Razorpay** - Payment integration

## 📋 Prerequisites

- **Flutter SDK** (latest stable)
- **Java 17+**
- **MySQL Server**
- **Maven** (for backend)

## 🚀 Quick Start

### Backend Setup

1. **Configure Database**
   ```properties
   # Update backend/src/main/resources/application.properties
   spring.datasource.url=jdbc:mysql://localhost:3306/trading_journal
   spring.datasource.username=your_username
   spring.datasource.password=your_password
   ```

2. **Configure JWT & Razorpay**
   ```properties
   jwt.secret=your-secret-key
   razorpay.key.id=your-razorpay-key-id
   razorpay.key.secret=your-razorpay-key-secret
   ```

3. **Run Backend**
   ```bash
   cd backend
   ./mvnw spring-boot:run
   ```
   Backend runs on: `http://localhost:8081`

### Frontend Setup

1. **Install Dependencies**
   ```bash
   cd frontend
   flutter pub get
   ```

2. **Run Application**
   ```bash
   flutter run -d chrome
   ```

### Using Batch Scripts (Windows)

- **Start Both**: `START_BOTH.bat`
- **Backend Only**: `RUN_BACKEND.bat`
- **Frontend Only**: `RUN_FRONTEND.bat`

## 📱 Screenshots

- Premium dark mode dashboard
- Real-time P&L analytics
- Trade management interface
- Responsive design

## 🔧 Configuration

### API URL
Update `frontend/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8081/api';
```

### Razorpay Keys
Update `frontend/lib/services/razorpay_service.dart`:
```dart
static const String razorpayKeyId = 'your-razorpay-key-id';
```

## 📦 Build

### Frontend
```bash
# Web
flutter build web

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

### Backend
```bash
cd backend
./mvnw clean package
java -jar target/trading-journal-backend-1.0.0.jar
```

## 🗄️ Database Schema

- **Users** - User accounts and authentication
- **Trades** - Trade entries with P&L calculations
- **Subscriptions** - Subscription plans and payment details

## 🔒 Security

- JWT authentication
- BCrypt password encryption
- CORS configured for Flutter web
- SQL injection protection (JPA)

## 📄 License

This project is private and proprietary.

## 👥 Contributing

This is a private project. Contributions are not accepted at this time.

## 📞 Support

For issues or questions, please contact the project maintainer.
