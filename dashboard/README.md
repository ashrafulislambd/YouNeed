# YouNeed - Admin Dashboard

This is the Admin Dashboard for the YouNeed application, built with React and Vite. It provides an interface for administrators to view system statistics and validate doctor prescriptions.

## Features

### 🔐 Admin Authentication
- Secure login page with hardcoded credentials for demonstration:
  - **Username**: `admin`
  - **Password**: `admin123`
- Logout functionality with a confirmation modal.
- Protected routes ensuring only authenticated users can access the dashboard.

### 📊 Dashboard Statistics
- **Overview Cards**: Displays total users, merchants, active loans, and due amounts.
- **Transaction Trend**: Visualizes monthly transaction data with a custom bar chart.
- **Leaderboards**: Functionality to view top users, merchants, and products.
- **Dark Mode**: Toggle between light and dark themes for better usability.

### ✅ Prescription Validation
- **Sidebar Navigation**: easy navigation between the main Dashboard and the Validation section.
- **Validator Page**: A dedicated interface for authorized validators to review and approve prescriptions (UI implemented, logic pending).

## Project Structure

```
src/
├── components/
│   ├── Login.jsx            # Authentication entry point
│   ├── Dashboard.jsx        # Main shell layout with Stats and Sidebar
│   ├── DashboardHome.jsx    # Dashboard statistics view
│   ├── ValidatePrescription.jsx # New validation feature page
│   ├── Sidebar.jsx          # Navigation sidebar
│   └── ...
├── context/
│   └── AuthContext.jsx      # Authentication state management
└── ...
```

## How to Run

1.  **Install Dependencies**:
    ```bash
    npm install
    ```

2.  **Start Development Server**:
    ```bash
    npm run dev
    ```

3.  **Build for Production**:
    ```bash
    npm run build
    ```
