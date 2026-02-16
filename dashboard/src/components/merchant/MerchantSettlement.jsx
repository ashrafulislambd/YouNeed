import React from 'react';
import './MerchantSettlement.css';

const MerchantSettlement = () => {
    // Mock Data
    const currentSettlement = {
        status: 'Processing',
        amount: 324000,
        date: 'May 15, 2023',
        week: 'Week 20, 2023',
        bankAccount: 'Islami Bank - **** 1234'
    };

    const settlementHistory = [
        { id: 'SET-001', date: 'May 8, 2023', amount: 298000, status: 'Paid', week: 'Week 19' },
        { id: 'SET-002', date: 'May 1, 2023', amount: 287000, status: 'Paid', week: 'Week 18' },
        { id: 'SET-003', date: 'Apr 24, 2023', amount: 221000, status: 'Paid', week: 'Week 17' },
        { id: 'SET-004', date: 'Apr 17, 2023', amount: 310000, status: 'Paid', week: 'Week 16' }
    ];

    return (
        <div className="merchant-settlement-container">
            <h2>Weekly Settlement</h2>

            {/* Current Settlement Status */}
            <div className="settlement-card highlight-card">
                <div className="card-header">
                    <h3>Current Week Settlement</h3>
                    <span className={`status-badge ${currentSettlement.status.toLowerCase()}`}>{currentSettlement.status}</span>
                </div>
                <div className="settlement-details-grid">
                    <div className="detail-item">
                        <label>Amount to be Repaid</label>
                        <div className="value">৳ {currentSettlement.amount.toLocaleString()}</div>
                    </div>
                    <div className="detail-item">
                        <label>Scheduled Date</label>
                        <div className="value">{currentSettlement.date}</div>
                        <div className="sub-value">Upcoming</div>
                    </div>
                    <div className="detail-item">
                        <label>Settlement Period</label>
                        <div className="value">{currentSettlement.week}</div>
                    </div>
                    <div className="detail-item">
                        <label>Bank Account</label>
                        <div className="value">{currentSettlement.bankAccount}</div>
                    </div>
                </div>
            </div>

            {/* Upcoming Schedule */}
            <div className="settlement-card">
                <h3>Upcoming Schedule</h3>
                <div className="schedule-timeline">
                    <div className="timeline-item active">
                        <div className="formatted-date">May 12</div>
                        <div className="event">Calculation Finalized</div>
                    </div>
                    <div className="timeline-item active">
                        <div className="formatted-date">May 13</div>
                        <div className="event">Invoice Generated</div>
                    </div>
                    <div className="timeline-item">
                        <div className="formatted-date">May 15</div>
                        <div className="event">Bank Transfer Initiated</div>
                    </div>
                    <div className="timeline-item">
                        <div className="formatted-date">May 16</div>
                        <div className="event">Expected Credit</div>
                    </div>
                </div>
            </div>

            {/* Settlement History */}
            <div className="settlement-card">
                <h3>Settlement History</h3>
                <table className="settlement-table">
                    <thead>
                        <tr>
                            <th>Settlement ID</th>
                            <th>Date</th>
                            <th>Week</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {settlementHistory.map(item => (
                            <tr key={item.id}>
                                <td>{item.id}</td>
                                <td>{item.date}</td>
                                <td>{item.week}</td>
                                <td className="amount">৳ {item.amount.toLocaleString()}</td>
                                <td><span className={`status-badge ${item.status.toLowerCase()}`}>{item.status}</span></td>
                                <td><button className="download-btn">Invoice</button></td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default MerchantSettlement;
