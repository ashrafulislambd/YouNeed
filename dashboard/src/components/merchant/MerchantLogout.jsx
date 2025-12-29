import React from 'react';
import { useNavigate } from 'react-router-dom';
import './MerchantLogout.css';

const MerchantLogout = () => {
    const navigate = useNavigate();

    const handleLogout = () => {
        // Perform logout logic (clear tokens etc)
        navigate('/merchant/login');
    };

    const handleCancel = () => {
        navigate(-1);
    };

    return (
        <div className="merchant-logout-overlay">
            <div className="merchant-logout-modal">
                <div className="logout-icon">
                    <i className="fas fa-sign-out-alt"></i>
                </div>
                <h2>Sign Out</h2>
                <p>Are you sure you want to sign out of the Merchant Portal?</p>
                <div className="logout-actions">
                    <button className="cancel-logout-btn" onClick={handleCancel}>
                        Cancel
                    </button>
                    <button className="confirm-logout-btn" onClick={handleLogout}>
                        Sign Out
                    </button>
                </div>
            </div>
        </div>
    );
};

export default MerchantLogout;
