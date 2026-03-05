import React from 'react';
import './LogoutConfirmation.css';

const LogoutConfirmation = ({ onConfirm, onCancel, darkMode, toggleDarkMode }) => {
    return (
        <div className="logout-overlay">
            <div className="logout-box">
                <h2>Logout Confirmation</h2>
                <p>You are about to logout from YouNeed.</p>

                <div className="logout-actions">
                    <button className="logout-btn-confirm" onClick={onConfirm}>Logout</button>
                    <button className="logout-btn-cancel" onClick={onCancel}>Cancel</button>
                </div>
            </div>
        </div>
    );
};

export default LogoutConfirmation;
