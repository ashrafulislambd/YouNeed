import React from 'react';

const ValidatePrescription = () => {
    return (
        <div className="validate-container" style={{ padding: '20px' }}>
            <h2>Validate Prescription</h2>
            <div className="card" style={{ marginTop: '20px', padding: '40px', textAlign: 'center', color: 'var(--muted)' }}>
                <p>Select a prescription to validate.</p>
            </div>
        </div>
    );
};

export default ValidatePrescription;
