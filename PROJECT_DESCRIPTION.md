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

### Database: `trading_journal`

The application uses MySQL database with three main tables. All tables include automatic timestamp management for `created_at` and `updated_at` fields.

---

### Table 1: `users`

Stores user account information and authentication data.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| `username` | VARCHAR(50) | UNIQUE, NOT NULL | User's username (3-50 characters) |
| `email` | VARCHAR(255) | UNIQUE, NOT NULL | User's email address (validated) |
| `password` | VARCHAR(255) | NOT NULL | BCrypt encrypted password (min 6 characters) |
| `created_at` | DATETIME | NOT NULL | Account creation timestamp (auto-set) |
| `updated_at` | DATETIME | NOT NULL | Last update timestamp (auto-updated) |

**Relationships:**
- One-to-Many with `trades` table (one user can have many trades)
- One-to-One with `subscriptions` table (one user has one subscription)

**Indexes:**
- Primary key on `id`
- Unique index on `username`
- Unique index on `email`

**Example Data:**
```sql
INSERT INTO users (username, email, password, created_at, updated_at) 
VALUES ('trader123', 'trader@example.com', '$2a$10$...', NOW(), NOW());
```

---

### Table 2: `trades`

Stores individual trade entries with P&L calculations.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique trade identifier |
| `user_id` | BIGINT | FOREIGN KEY, NOT NULL | Reference to `users.id` |
| `instrument` | VARCHAR(255) | NOT NULL | Trading instrument (e.g., "BANKNIFTY", "NIFTY", "RELIANCE") |
| `trade_type` | VARCHAR(10) | NOT NULL | Trade type: "BUY" or "SELL" |
| `entry_price` | DECIMAL(19,2) | NOT NULL, > 0 | Entry price of the trade |
| `exit_price` | DECIMAL(19,2) | NOT NULL, > 0 | Exit price of the trade |
| `quantity` | INT | NOT NULL, >= 1 | Number of lots/units traded |
| `lot_size` | INT | DEFAULT 1 | Lot size multiplier (default: 1) |
| `trade_date` | DATE | NOT NULL | Date when trade was executed |
| `notes` | TEXT | NULL | Optional notes about the trade |
| `profit_loss` | DECIMAL(19,2) | NULL | Calculated P&L (auto-calculated) |
| `created_at` | DATETIME | NOT NULL | Record creation timestamp (auto-set) |
| `updated_at` | DATETIME | NOT NULL | Last update timestamp (auto-updated) |

**Relationships:**
- Many-to-One with `users` table (many trades belong to one user)

**P&L Calculation Logic:**
- **For BUY trades:** `profit_loss = (exit_price - entry_price) × quantity × lot_size`
- **For SELL trades:** `profit_loss = (entry_price - exit_price) × quantity × lot_size`
- Calculated automatically on insert/update via `@PrePersist` and `@PreUpdate`

**Indexes:**
- Primary key on `id`
- Foreign key index on `user_id`
- Index on `trade_date` (for date range queries)
- Index on `user_id` + `trade_date` (composite, for analytics)

**Example Data:**
```sql
INSERT INTO trades (user_id, instrument, trade_type, entry_price, exit_price, 
                   quantity, lot_size, trade_date, profit_loss, created_at, updated_at) 
VALUES (1, 'BANKNIFTY', 'BUY', 45000.00, 45625.00, 1, 25, '2026-01-20', 15625.00, NOW(), NOW());
```

---

### Table 3: `subscriptions`

Stores user subscription plans and payment information.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique subscription identifier |
| `user_id` | BIGINT | FOREIGN KEY, UNIQUE, NOT NULL | Reference to `users.id` (one subscription per user) |
| `plan_type` | ENUM | NOT NULL, DEFAULT 'FREE' | Plan type: 'FREE', 'PRO_MONTHLY', 'PRO_YEARLY' |
| `razorpay_order_id` | VARCHAR(255) | NULL | Razorpay order ID for payment tracking |
| `razorpay_payment_id` | VARCHAR(255) | NULL | Razorpay payment ID |
| `razorpay_signature` | VARCHAR(255) | NULL | Razorpay payment signature (verification) |
| `subscription_period` | ENUM | NULL | Period: 'MONTHLY' or 'YEARLY' |
| `start_date` | DATETIME | NULL | Subscription start date (auto-set on creation) |
| `end_date` | DATETIME | NULL | Subscription end date (calculated based on plan) |
| `is_active` | BOOLEAN | DEFAULT FALSE | Whether subscription is currently active |
| `created_at` | DATETIME | NOT NULL | Record creation timestamp (auto-set) |
| `updated_at` | DATETIME | NOT NULL | Last update timestamp (auto-updated) |

**Relationships:**
- One-to-One with `users` table (one user has one subscription)

**Plan Types:**
- **FREE**: Default plan, limited features (10 trades max)
- **PRO_MONTHLY**: Premium plan, monthly billing, unlimited features
- **PRO_YEARLY**: Premium plan, yearly billing, unlimited features

**Indexes:**
- Primary key on `id`
- Unique foreign key index on `user_id`
- Index on `is_active` (for filtering active subscriptions)
- Index on `end_date` (for checking expired subscriptions)

**Example Data:**
```sql
INSERT INTO subscriptions (user_id, plan_type, razorpay_order_id, razorpay_payment_id, 
                          start_date, end_date, is_active, created_at, updated_at) 
VALUES (1, 'PRO_MONTHLY', 'order_123', 'pay_456', NOW(), DATE_ADD(NOW(), INTERVAL 1 MONTH), 
        TRUE, NOW(), NOW());
```

---

### Database Relationships Diagram

```
users (1) ──────< (many) trades
  │
  │ (1)
  │
  └─────── (1) subscriptions
```

**Relationship Details:**
- **Users → Trades**: One user can have multiple trades (One-to-Many)
- **Users → Subscriptions**: One user has exactly one subscription (One-to-One)

---

### Database Indexes for Performance

The following indexes are created for optimal query performance:

```sql
-- Users table indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- Trades table indexes
CREATE INDEX idx_trades_user_id ON trades(user_id);
CREATE INDEX idx_trades_trade_date ON trades(trade_date);
CREATE INDEX idx_trades_user_date ON trades(user_id, trade_date); -- Composite index

-- Subscriptions table indexes
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_is_active ON subscriptions(is_active);
CREATE INDEX idx_subscriptions_end_date ON subscriptions(end_date);
```

**Index Usage:**
- User authentication queries (email/username lookup)
- Trade filtering by user and date range
- Analytics queries (grouping by date)
- Subscription status checks

---

### Database Constraints

**Foreign Key Constraints:**
- `trades.user_id` → `users.id` (CASCADE on delete)
- `subscriptions.user_id` → `users.id` (CASCADE on delete)

**Check Constraints:**
- `trades.quantity` >= 1
- `trades.entry_price` > 0
- `trades.exit_price` > 0
- `users.password` length >= 6
- `users.username` length between 3-50

---

### Sample Queries

**Get all trades for a user:**
```sql
SELECT * FROM trades WHERE user_id = 1 ORDER BY trade_date DESC;
```

**Calculate total P&L:**
```sql
SELECT SUM(profit_loss) as total_pnl FROM trades WHERE user_id = 1;
```

**Get active subscriptions:**
```sql
SELECT * FROM subscriptions WHERE is_active = TRUE AND end_date > NOW();
```

**Get trades in date range:**
```sql
SELECT * FROM trades 
WHERE user_id = 1 
  AND trade_date BETWEEN '2026-01-01' AND '2026-01-31'
ORDER BY trade_date DESC;
```

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

