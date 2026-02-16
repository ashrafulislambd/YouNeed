import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import Login from './components/admin/Login';
import Dashboard from './components/admin/Dashboard';
import MerchantLogin from './components/merchant/MerchantLogin';
import MerchantLogout from './components/merchant/MerchantLogout';
import MerchantLayout from './components/merchant/MerchantLayout';
import MerchantDashboard from './components/merchant/MerchantDashboard';
import MerchantOrders from './components/merchant/MerchantOrders';
import MerchantProducts from './components/merchant/MerchantProducts';
import MerchantPrivateRoute from './components/merchant/MerchantPrivateRoute';
import MerchantAnalytics from './components/merchant/MerchantAnalytics';
import MerchantSettlement from './components/merchant/MerchantSettlement';
import MerchantPayments from './components/merchant/MerchantPayments';
import MerchantBankDetails from './components/merchant/MerchantBankDetails';
import './App.css';

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/dashboard" element={<Dashboard />} />

          {/* Merchant Routes */}
          <Route path="/merchant/login" element={<MerchantLogin />} />
          <Route path="/merchant/logout" element={<MerchantLogout />} />
          <Route path="/merchant" element={<MerchantPrivateRoute />}>
            <Route element={<MerchantLayout />}>
              <Route index element={<Navigate to="/merchant/dashboard" replace />} />
              <Route path="dashboard" element={<MerchantDashboard />} />
              <Route path="orders" element={<MerchantOrders />} />
              <Route path="products" element={<MerchantProducts />} />
              <Route path="analytics" element={<MerchantAnalytics />} />
              <Route path="settlement" element={<MerchantSettlement />} />
              <Route path="payments" element={<MerchantPayments />} />
              <Route path="bank-details" element={<MerchantBankDetails />} />
            </Route>
          </Route>

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;
