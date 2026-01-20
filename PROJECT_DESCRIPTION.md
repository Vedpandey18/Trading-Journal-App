# Trading Journal - Project Description

## 📋 Project Overview

**Trading Journal** is a modern, premium fintech-grade trading journal application designed to help traders track, analyze, and improve their trading performance. The application features a beautiful dark-mode UI with advanced analytics, real-time P&L tracking, and comprehensive trade management capabilities.

## 🏗️ Project Structure

```
Trading/
│
├── frontend/                          # Flutter Web/Mobile Application
│   ├── lib/
│   │   ├── main.dart                 # Original entry point
│   │   ├── main_new.dart             # Premium UI entry point (main)
│   │   │
│   │   ├── screens/                  # UI Screens
│   │   │   ├── auth/                 # Authentication screens
│   │   │   │   ├── premium_login_screen.dart
│   │   │   │   └── premium_register_screen.dart
│   │   │   │
│   │   │   ├── dashboard/            # Dashboard screens
│   │   │   │   └── premium_dashboard_screen.dart
│   │   │   │
│   │   │   ├── trades/               # Trade list screens
│   │   │   │   └── premium_trades_list_screen.dart
│   │   │   │
│   │   │   ├── add_trade/            # Add trade screens
│   │   │   │   └── premium_add_trade_screen.dart
│   │   │   │
│   │   │   ├── analytics/            # Analytics screens
│   │   │   │   └── premium_analytics_screen.dart
│   │   │   │
│   │   │   ├── subscription/         # Subscription screens
│   │   │   │   └── subscription_plans_screen.dart
│   │   │   │
│   │   │   ├── profile/              # Profile screens
│   │   │   │   └── profile_screen.dart
│   │   │   │
│   │   │   └── splash_screen.dart    # Splash screen
│   │   │
│   │   ├── widgets/                  # Reusable Widgets
│   │   │   ├── premium_kpi_card.dart        # KPI cards
│   │   │   ├── premium_trade_card.dart      # Trade cards
│   │   │   ├── advanced_charts.dart          # Chart widgets
│   │   │   └── loading_skeleton.dart         # Loading states
│   │   │
│   │   ├── providers/                # State Management (Provider)
│   │   │   ├── auth_provider.dart           # Authentication state
│   │   │   ├── trade_provider.dart          # Trade data state
│   │   │   ├── theme_provider.dart          # Theme state
│   │   │   └── subscription_provider.dart    # Subscription state
│   │   │
│   │   ├── services/                 # API & External Services
│   │   │   ├── api_service.dart            # Backend API client
│   │   │   ├── razorpay_service.dart       # Payment gateway
│   │   │   └── subscription_service.dart    # Subscription API
│   │   │
│   │   ├── theme/                    # Design System
│   │   │   └── premium_theme.dart          # Dark mode theme
│   │   │
│   │   └── models/                   # Data Models
│   │       ├── trade_model.dart
│   │       └── subscription_model.dart
│   │
│   ├── web/                          # Web-specific files
│   │   ├── index.html
│   │   └── manifest.json
│   │
│   ├── pubspec.yaml                  # Flutter dependencies
│   └── README.md                     # Frontend documentation
│
├── backend/                          # Spring Boot REST API
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/tradingjournal/
│   │       │       ├── TradingJournalApplication.java  # Main class
│   │       │       │
│   │       │       ├── controller/   # REST Controllers
│   │       │       │   ├── AuthController.java
│   │       │       │   ├── TradeController.java
│   │       │       │   ├── AnalyticsController.java
│   │       │       │   ├── SubscriptionController.java
│   │       │       │   └── HealthController.java
│   │       │       │
│   │       │       ├── service/      # Business Logic
│   │       │       │   ├── AuthService.java
│   │       │       │   ├── TradeService.java
│   │       │       │   ├── AnalyticsService.java
│   │       │       │   └── SubscriptionService.java
│   │       │       │
│   │       │       ├── repository/   # Data Access Layer
│   │       │       │   ├── UserRepository.java
│   │       │       │   ├── TradeRepository.java
│   │       │       │   └── SubscriptionRepository.java
│   │       │       │
│   │       │       ├── entity/       # Database Entities
│   │       │       │   ├── User.java
│   │       │       │   ├── Trade.java
│   │       │       │   └── Subscription.java
│   │       │       │
│   │       │       ├── dto/          # Data Transfer Objects
│   │       │       │   ├── TradeRequest.java
│   │       │       │   ├── TradeResponse.java
│   │       │       │   └── ...
│   │       │       │
│   │       │       ├── config/       # Configuration
│   │       │       │   ├── SecurityConfig.java
│   │       │       │   └── DataInitializer.java
│   │       │       │
│   │       │       ├── security/     # Security Components
│   │       │       │   ├── JwtAuthenticationFilter.java
│   │       │       │   └── CustomUserDetailsService.java
│   │       │       │
│   │       │       └── util/         # Utilities
│   │       │           └── JwtUtil.java
│   │       │
│   │       └── resources/
│   │           ├── application.properties  # Configuration
│   │           └── db_indexes.sql           # Database indexes
│   │
│   ├── pom.xml                       # Maven dependencies
│   └── README.md                     # Backend documentation
│
├── START_BOTH.bat                    # Start both frontend & backend
├── RUN_BACKEND.bat                   # Start backend only
├── RUN_FRONTEND.bat                  # Start frontend only
│
├── README.md                         # Main project README
├── PROJECT_DESCRIPTION.md            # This file
└── .gitignore                        # Git ignore rules
```

## 🚀 Running the Application

### Prerequisites

#### For Backend:
- **Java 17+** installed
- **MySQL Server** running
- **Maven** installed (or use Maven wrapper)

#### For Frontend:
- **Flutter SDK** (latest stable version)
- **Chrome Browser** (for web development)

### Step 1: Database Setup

1. **Create MySQL Database:**
   ```sql
   CREATE DATABASE trading_journal;
   ```

2. **Update Backend Configuration:**
   Edit `backend/src/main/resources/application.properties`:
   ```properties
   # Database Configuration
   spring.datasource.url=jdbc:mysql://localhost:3306/trading_journal
   spring.datasource.username=root
   spring.datasource.password=your_password
   
   # JWT Secret (use a strong random string)
   jwt.secret=your-secret-key-change-this-in-production
   
   # Razorpay Keys (for payments)
   razorpay.key.id=your-razorpay-key-id
   razorpay.key.secret=your-razorpay-key-secret
   ```

### Step 2: Running the Backend

#### Option A: Using Batch Script (Windows)
```bash
# Double-click or run:
RUN_BACKEND.bat
```

#### Option B: Using Command Line
```bash
cd backend
./mvnw spring-boot:run
# Or if Maven is installed globally:
mvn spring-boot:run
```

**Backend will start on:** `http://localhost:8081`

**Verify Backend is Running:**
- Open browser: `http://localhost:8081/api/health`
- Should return: `{"status":"UP"}`

### Step 3: Running the Frontend

#### Option A: Using Batch Script (Windows)
```bash
# Double-click or run:
RUN_FRONTEND.bat
```

#### Option B: Using Command Line
```bash
cd frontend
flutter pub get          # Install dependencies (first time only)
flutter run -d chrome    # Run in Chrome browser
```

**Frontend will start on:** `http://localhost:<random-port>` (usually 50000+)

### Step 4: Running Both Together

#### Option A: Using Batch Script (Windows)
```bash
# Double-click or run:
START_BOTH.bat
```
This will open two command windows - one for backend, one for frontend.

#### Option B: Using Separate Terminals
1. **Terminal 1 - Backend:**
   ```bash
   cd backend
   ./mvnw spring-boot:run
   ```

2. **Terminal 2 - Frontend:**
   ```bash
   cd frontend
   flutter run -d chrome
   ```

## 🔧 Configuration Details

### Backend Configuration (`application.properties`)

```properties
# Server Port
server.port=8081

# Database
spring.datasource.url=jdbc:mysql://localhost:3306/trading_journal
spring.datasource.username=root
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false

# JWT
jwt.secret=your-secret-key-minimum-256-bits
jwt.expiration=86400000

# Razorpay
razorpay.key.id=your-key-id
razorpay.key.secret=your-key-secret

# CORS (for Flutter web)
cors.allowed-origins=http://localhost:*
```

### Frontend Configuration

**API URL** (`frontend/lib/services/api_service.dart`):
```dart
static const String baseUrl = 'http://localhost:8081/api';
```

**Razorpay Key** (`frontend/lib/services/razorpay_service.dart`):
```dart
static const String razorpayKeyId = 'your-razorpay-key-id';
```

## 📱 Application Features

### Core Features:
- ✅ **User Authentication** - Login/Register with JWT
- ✅ **Trade Management** - Add, edit, delete trades
- ✅ **Real-time Analytics** - P&L curves, equity curves, charts
- ✅ **Daily/Monthly Reports** - Bar charts and statistics
- ✅ **Win/Loss Analysis** - Pie charts and performance metrics
- ✅ **Subscription Plans** - Razorpay payment integration
- ✅ **Dark Mode UI** - Premium glassmorphic design
- ✅ **Responsive Design** - Mobile, tablet, desktop support

### Premium UI Features:
- Dark gradient backgrounds
- Glassmorphic card effects
- Smooth animations
- Advanced charting (fl_chart)
- Real-time data updates
- Optimized performance

## 🗄️ Database Schema

### Users Table
- `id` (Primary Key)
- `username` (Unique)
- `email` (Unique)
- `password` (BCrypt encrypted)
- `created_at`, `updated_at`

### Trades Table
- `id` (Primary Key)
- `user_id` (Foreign Key)
- `instrument` (e.g., "BANKNIFTY", "NIFTY")
- `trade_type` (BUY/SELL)
- `entry_price`, `exit_price`
- `quantity`, `lot_size`
- `profit_loss` (calculated)
- `trade_date`, `notes`
- `created_at`, `updated_at`

### Subscriptions Table
- `id` (Primary Key)
- `user_id` (Foreign Key, Unique)
- `plan_type` (FREE/PRO_MONTHLY/PRO_YEARLY)
- `razorpay_order_id`, `razorpay_payment_id`
- `start_date`, `end_date`
- `is_active`
- `created_at`, `updated_at`

## 🔐 Security Features

- **JWT Authentication** - Secure token-based auth
- **BCrypt Password Encryption** - Secure password storage
- **CORS Configuration** - Cross-origin request handling
- **SQL Injection Protection** - JPA/Hibernate protection
- **Input Validation** - Request validation

## 📊 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Trades (Requires Auth)
- `GET /api/trades` - Get all trades
- `POST /api/trades` - Add new trade
- `PUT /api/trades/{id}` - Update trade
- `DELETE /api/trades/{id}` - Delete trade
- `GET /api/trades/analytics` - Get analytics

### Subscription (Requires Auth)
- `GET /api/subscription/plans` - Get available plans
- `GET /api/subscription/status` - Get user subscription
- `POST /api/subscription/cancel` - Cancel subscription

### Health Check
- `GET /api/health` - Backend status

## 🛠️ Development Tools

### Backend:
- **Spring Boot 3.5.9**
- **Spring Data JPA**
- **Spring Security**
- **MySQL Connector**
- **JWT Library**

### Frontend:
- **Flutter SDK**
- **Provider** (State Management)
- **fl_chart** (Charts)
- **Dio** (HTTP Client)
- **Razorpay** (Payments)

## 📝 Troubleshooting

### Backend Issues:
- **Port 8081 already in use:** Change port in `application.properties`
- **Database connection failed:** Check MySQL is running and credentials are correct
- **JWT errors:** Ensure `jwt.secret` is set in `application.properties`

### Frontend Issues:
- **API connection failed:** Ensure backend is running on port 8081
- **CORS errors:** Check backend CORS configuration
- **Build errors:** Run `flutter clean` then `flutter pub get`

## 📄 License

This project is private and proprietary.

## 👥 Support

For issues or questions, refer to:
- `frontend/README.md` - Frontend documentation
- `backend/README.md` - Backend documentation
- `README.md` - Main project documentation

---

**Last Updated:** January 2026
**Version:** 1.0.0
