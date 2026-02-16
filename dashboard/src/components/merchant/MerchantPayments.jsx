import React, { useState } from 'react';
import './MerchantPayments.css';

const MerchantPayments = () => {
    const [activeTab, setActiveTab] = useState('all');

    // Mock Data
    const transactions = [
        { id: 'TRX-9821', date: 'May 10, 2023', type: 'Order Payment', reference: '#YN-7832', amount: 1245, status: 'Completed', direction: 'in' },
        { id: 'TRX-9820', date: 'May 08, 2023', type: 'Order Payment', reference: '#YN-7825', amount: 2457, status: 'Completed', direction: 'in' },
        { id: 'SET-001', date: 'May 08, 2023', type: 'Weekly Settlement', reference: 'Week 19', amount: 298000, status: 'Processed', direction: 'out' },
        { id: 'TRX-9819', date: 'May 07, 2023', type: 'Order Payment', reference: '#YN-7818', amount: 673, status: 'Pending', direction: 'in' },
        { id: 'TRX-9818', date: 'May 05, 2023', type: 'Order Refund', reference: '#YN-7810', amount: 1568, status: 'Completed', direction: 'out' },
        { id: 'SET-002', date: 'May 01, 2023', type: 'Weekly Settlement', reference: 'Week 18', amount: 287000, status: 'Processed', direction: 'out' },
    ];

    const filteredTransactions = activeTab === 'all'
        ? transactions
        : activeTab === 'in'
            ? transactions.filter(t => t.direction === 'in')
            : transactions.filter(t => t.direction === 'out');

    return (
        <div className="merchant-payments-container">
            <h2>Payment History</h2>

            <div className="payments-controls">
                <div className="tabs">
                    <button
                        className={`tab-btn ${activeTab === 'all' ? 'active' : ''}`}
                        onClick={() => setActiveTab('all')}
                    >
                        All Transactions
                    </button>
                    <button
                        className={`tab-btn ${activeTab === 'in' ? 'active' : ''}`}
                        onClick={() => setActiveTab('in')}
                    >
                        Incoming (Orders)
                    </button>
                    <button
                        className={`tab-btn ${activeTab === 'out' ? 'active' : ''}`}
                        onClick={() => setActiveTab('out')}
                    >
                        Outgoing (Settlements/Refunds)
                    </button>
                </div>
                <div className="filters">
                    <input type="date" className="date-filter" />
                    <button className="export-btn">Export CSV</button>
                </div>
            </div>

            <div className="payments-list">
                <table className="payments-table">
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Reference</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredTransactions.map(trx => (
                            <tr key={trx.id}>
                                <td className="trx-id">{trx.id}</td>
                                <td>{trx.date}</td>
                                <td>{trx.type}</td>
                                <td>{trx.reference}</td>
                                <td className={`amount ${trx.direction}`}>
                                    {trx.direction === 'in' ? '+' : '-'} ৳ {trx.amount.toLocaleString()}
                                </td>
                                <td>
                                    <span className={`status-dot ${trx.status.toLowerCase()}`}></span>
                                    {trx.status}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default MerchantPayments;
