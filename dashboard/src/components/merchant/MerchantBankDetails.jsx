import React, { useState } from 'react';
import './MerchantBankDetails.css';

const MerchantBankDetails = () => {
    const [isEditing, setIsEditing] = useState(false);

    // Mock Data
    const [bankDetails, setBankDetails] = useState({
        accountName: 'Ahmed Mart Enterprise',
        bankName: 'Islami Bank Bangladesh Ltd.',
        branchName: 'Mirpur 10 Branch',
        accountNumber: '20502130100234567',
        routingNumber: '123456789',
        accountType: 'Current'
    });

    const handleEditToggle = () => {
        if (isEditing) {
            // Save logic would go here
            console.log("Saving details:", bankDetails);
        }
        setIsEditing(!isEditing);
    };

    const handleChange = (e) => {
        setBankDetails({
            ...bankDetails,
            [e.target.name]: e.target.value
        });
    };

    return (
        <div className="merchant-bank-container">
            <div className="bank-header">
                <h2>Bank Details</h2>
                <button
                    className={`edit-btn ${isEditing ? 'save' : ''}`}
                    onClick={handleEditToggle}
                >
                    {isEditing ? 'Save Changes' : 'Edit Details'}
                </button>
            </div>

            <div className="bank-card">
                <div className="bank-logo-placeholder">
                    <i className="fas fa-university"></i>
                </div>

                <div className="bank-form-grid">
                    <div className="form-group">
                        <label>Account Name</label>
                        <input
                            type="text"
                            name="accountName"
                            value={bankDetails.accountName}
                            disabled={!isEditing}
                            onChange={handleChange}
                        />
                    </div>

                    <div className="form-group">
                        <label>Bank Name</label>
                        <select
                            name="bankName"
                            value={bankDetails.bankName}
                            disabled={!isEditing}
                            onChange={handleChange}
                        >
                            <option>Islami Bank Bangladesh Ltd.</option>
                            <option>Dutch Bangla Bank Ltd.</option>
                            <option>BRAC Bank Ltd.</option>
                            <option>City Bank Ltd.</option>
                        </select>
                    </div>

                    <div className="form-group">
                        <label>Branch Name</label>
                        <input
                            type="text"
                            name="branchName"
                            value={bankDetails.branchName}
                            disabled={!isEditing}
                            onChange={handleChange}
                        />
                    </div>

                    <div className="form-group">
                        <label>Account Number</label>
                        <input
                            type="text"
                            name="accountNumber"
                            value={bankDetails.accountNumber}
                            disabled={!isEditing}
                            onChange={handleChange}
                        />
                    </div>

                    <div className="form-group">
                        <label>Routing Number</label>
                        <input
                            type="text"
                            name="routingNumber"
                            value={bankDetails.routingNumber}
                            disabled={!isEditing}
                            onChange={handleChange}
                        />
                    </div>

                    <div className="form-group">
                        <label>Account Type</label>
                        <select
                            name="accountType"
                            value={bankDetails.accountType}
                            disabled={!isEditing}
                            onChange={handleChange}
                        >
                            <option>Current</option>
                            <option>Savings</option>
                        </select>
                    </div>
                </div>

                <div className="verification-status active">
                    <i className="fas fa-check-circle"></i>
                    <span>Bank Account Verified</span>
                </div>
            </div>
        </div>
    );
};

export default MerchantBankDetails;
