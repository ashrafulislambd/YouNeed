import React, { createContext, useState, useContext } from 'react';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [userRole, setUserRole] = useState(null); // 'admin' or 'merchant'

    const login = (role = 'admin') => {
        setIsAuthenticated(true);
        setUserRole(role);
    };

    const logout = () => {
        setIsAuthenticated(false);
        setUserRole(null);
    };

    return (
        <AuthContext.Provider value={{ isAuthenticated, userRole, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);