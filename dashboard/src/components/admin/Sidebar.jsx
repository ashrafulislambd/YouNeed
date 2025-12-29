import React from 'react';
import './Sidebar.css';

const Sidebar = ({ isOpen, onClose, currentView, setView }) => {

    const handleNavigation = (view) => {
        setView(view);
        onClose();
    };

    return (
        <>
            <div
                className={`sidebar-overlay ${isOpen ? 'visible' : ''}`}
                onClick={onClose}
            ></div>
            <div className={`sidebar ${isOpen ? 'open' : ''}`}>
                <div className="sidebar-header">
                    <div className="sidebar-title">Menu</div>
                    <button className="close-btn" onClick={onClose}>&times;</button>
                </div>
                <nav className="sidebar-nav">
                    <div
                        className={`nav-item ${currentView === 'home' ? 'active' : ''}`}
                        onClick={() => handleNavigation('home')}
                    >
                        Dashboard
                    </div>
                    <div
                        className={`nav-item ${currentView === 'validate' ? 'active' : ''}`}
                        onClick={() => handleNavigation('validate')}
                    >
                        Validate
                    </div>
                </nav>
            </div>
        </>
    );
};

export default Sidebar;
