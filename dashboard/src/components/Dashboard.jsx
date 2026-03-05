import React, { useState, useEffect } from 'react';
import { useNavigate, Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './Dashboard.css';
import LogoutConfirmation from './LogoutConfirmation';
import DashboardHome from './DashboardHome';
import Sidebar from './Sidebar';
import ValidatePrescription from './ValidatePrescription';

const Dashboard = () => {
    const navigate = useNavigate();
    const { isAuthenticated, logout } = useAuth();
    const [darkMode, setDarkMode] = useState(false);
    const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);
    const [isSidebarOpen, setSidebarOpen] = useState(false);
    const [currentView, setCurrentView] = useState('home');

    if (!isAuthenticated) {
        return <Navigate to="/" replace />;
    }

    useEffect(() => {
        if (darkMode) {
            document.body.classList.add('dark');
        } else {
            document.body.classList.remove('dark');
        }
    }, [darkMode]);

    const toggleMode = () => {
        setDarkMode(!darkMode);
    };

    const handleLogoutClick = () => {
        setShowLogoutConfirm(true);
    };

    const handleConfirmLogout = () => {
        logout();
        setShowLogoutConfirm(false);
        navigate('/', { replace: true });
    };

    const handleCancelLogout = () => {
        setShowLogoutConfirm(false);
    };

    const toggleSidebar = () => {
        setSidebarOpen(!isSidebarOpen);
    };

    return (
        <>
            <header className="dashboard-header">
                <div className="menu" onClick={toggleSidebar}>☰</div>
                <h3 style={{ margin: 0 }}>Admin Dashboard</h3>
                <div className="header-right">
                    <div className="toggle" onClick={toggleMode}>
                        {darkMode ? '☀️' : '🌙'}
                    </div>
                    <button className="logout-btn-header" onClick={handleLogoutClick}>Logout</button>
                </div>
            </header>

            <Sidebar
                isOpen={isSidebarOpen}
                onClose={() => setSidebarOpen(false)}
                currentView={currentView}
                setView={setCurrentView}
            />

            <div className="dashboard-main">
                {currentView === 'home' && <DashboardHome />}
                {currentView === 'validate' && <ValidatePrescription />}
            </div>

            {showLogoutConfirm && (
                <LogoutConfirmation
                    onConfirm={handleConfirmLogout}
                    onCancel={handleCancelLogout}
                />
            )}
        </>
    );
};

export default Dashboard;