# Trading Journal Backend

Spring Boot REST API with MySQL database.

## 🚀 Quick Start

### Prerequisites
- Java 17+
- MySQL Server running
- Maven installed

### Configuration

1. **Database Setup**
   - Create database: `trading_journal`
   - Update `src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/trading_journal
   spring.datasource.username=root
   spring.datasource.password=your_password
   ```

2. **JWT Secret**
   ```properties
   jwt.secret=your-secret-key-change-this-in-production
   ```

3. **Razorpay Keys**
   ```properties
   razorpay.key.id=your-razorpay-key-id
   razorpay.key.secret=your-razorpay-key-secret
   ```

### Run Application
```bash
cd backend
./mvnw spring-boot:run
```

Backend runs on: `http://localhost:8081`

## 📡 API Endpoints

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

## 🗄️ Database Schema

### Users
- id, username, email, password, created_at, updated_at

### Trades
- id, user_id, instrument, trade_type, entry_price, exit_price
- quantity, lot_size, trade_date, notes, profit_loss
- created_at, updated_at

### Subscriptions
- id, user_id, plan_type, razorpay_order_id, razorpay_payment_id
- razorpay_signature, start_date, end_date, is_active
- created_at, updated_at

## 🔒 Security

- JWT authentication
- BCrypt password encryption
- CORS configured for Flutter web
- SQL injection protection (JPA)

## 🚀 Production

Use environment variables:
- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`
- `JWT_SECRET`
- `RAZORPAY_KEY_ID`
- `RAZORPAY_KEY_SECRET`
