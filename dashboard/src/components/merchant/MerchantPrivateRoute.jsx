import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';

const MerchantPrivateRoute = () => {
    const { isAuthenticated, userRole } = useAuth();

    if (!isAuthenticated || userRole !== 'merchant') {
        return <Navigate to="/" replace />;
    }

    return <Outlet />;
};

export default MerchantPrivateRoute;
