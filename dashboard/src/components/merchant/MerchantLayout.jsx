import React from 'react';
import { Outlet, NavLink, useNavigate, Link, useLocation } from 'react-router-dom';
import './MerchantLayout.css';

const MerchantLayout = () => {
    const navigate = useNavigate();
    const location = useLocation(); // Need to import useLocation
    const [isSidebarOpen, setIsSidebarOpen] = React.useState(window.innerWidth > 768);

    const toggleSidebar = () => {
        setIsSidebarOpen(!isSidebarOpen);
    };

    const getPageTitle = (pathname) => {
        if (pathname.includes('/orders')) return 'Orders Management';
        if (pathname.includes('/products')) return 'Product Inventory';
        if (pathname.includes('/analytics')) return 'Sales Analytics';
        if (pathname.includes('/settlement')) return 'Weekly Settlement';
        if (pathname.includes('/payments')) return 'Payment History';
        if (pathname.includes('/bank-details')) return 'Bank Details';
        return 'Merchant Dashboard';
    };

    return (
        <div className="merchant-body">
            {/* Sidebar Navigation */}
            <div className={`merchant-sidebar ${!isSidebarOpen ? 'closed' : ''}`}>
                <div className="merchant-logo">
                    <button className="hamburger-sidebar-btn" onClick={toggleSidebar}>
                        ☰
                    </button>
                    <h2>You<span>Need</span></h2>
                </div>

                <div className="merchant-nav-section">
                    <h4>General</h4>
                    <ul className="merchant-nav-links">
                        <li>
                            <NavLink to="/merchant/dashboard" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-home"></i>
                                <span>Dashboard</span>
                            </NavLink>
                        </li>
                        <li>
                            <NavLink to="/merchant/orders" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-shopping-cart"></i>
                                <span>Orders</span>
                            </NavLink>
                        </li>
                        <li>
                            <NavLink to="/merchant/products" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-box-open"></i>
                                <span>Products</span>
                            </NavLink>
                        </li>
                        <li>
                            <NavLink to="/merchant/analytics" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-chart-line"></i>
                                <span>Analytics</span>
                            </NavLink>
                        </li>
                    </ul>
                </div>

                <div className="merchant-separator"></div>

                <div className="merchant-nav-section">
                    <h4>Bank Repayment</h4>
                    <ul className="merchant-nav-links">
                        <li>
                            <NavLink to="/merchant/settlement" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-university"></i>
                                <span>Weekly Settlement</span>
                            </NavLink>
                        </li>
                        <li>
                            <NavLink to="/merchant/payments" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-file-invoice-dollar"></i>
                                <span>Payment History</span>
                            </NavLink>
                        </li>
                        <li>
                            <NavLink to="/merchant/bank-details" className={({ isActive }) => isActive ? "active" : ""}>
                                <i className="fas fa-cog"></i>
                                <span>Bank Details</span>
                            </NavLink>
                        </li>
                    </ul>
                </div>

                <div className="merchant-separator"></div>

                {/* Merchant Info in Sidebar */}
                <div className="merchant-info">
                    <h4>Merchant Information</h4>
                    <div className="merchant-details">
                        <p><strong>Ahmed Mart</strong></p>
                        <p>Dhaka, Bangladesh</p>
                        <p className="store-id">Store ID: #YN-7842</p>
                        <p>Contact: 01712-345678</p>
                    </div>
                </div>
            </div>

            {/* Main Content */}
            <div className={`merchant-main-content ${!isSidebarOpen ? 'expanded' : ''}`}>
                <div className="merchant-header-bar">
                    <div className="header-left">
                        {/* Show hamburger here ONLY if sidebar is closed, otherwise it's in the sidebar */}
                        {!isSidebarOpen && (
                            <button className="hamburger-btn" onClick={toggleSidebar}>
                                ☰
                            </button>
                        )}
                        <h1 className="page-title">{getPageTitle(location.pathname)}</h1>
                    </div>

                    <div className="header-actions-container">
                        <div className="user-info-box">
                            <div className="user-avatar-initials">AH</div>
                            <div className="user-text-details">
                                <p className="user-name">Welcome, <strong>Ahmed Hossain</strong></p>
                            </div>
                        </div>
                        <Link to="/merchant/logout" className="logout-btn-subtle">
                            <i className="fas fa-sign-out-alt"></i>
                            Logout
                        </Link>
                    </div>
                </div>
                <div className="merchant-content-wrapper">
                    <Outlet />
                </div>
            </div>
        </div>
    );
};

export default MerchantLayout;
