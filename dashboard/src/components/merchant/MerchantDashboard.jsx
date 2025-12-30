import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import './MerchantDashboard.css';

const MerchantDashboard = () => {
    const [repaymentFilter, setRepaymentFilter] = useState('Last 4 Weeks');
    const [monthFilter, setMonthFilter] = useState('May 2023');

    return (
        <div className="merchant-dashboard-container">
            {/* Stats Overview */}
            <div className="stats-grid">
                <div className="stat-card">
                    <h3>Total Orders</h3>
                    <div className="stat-value"><span className="taka-symbol">৳</span>1,248</div>
                    <div className="stat-subtext"><span className="highlight">+12%</span> from last week</div>
                </div>

                <div className="stat-card">
                    <h3>Weekly Repayment</h3>
                    <div className="stat-value"><span className="taka-symbol">৳</span>3,24,000</div>
                    <div className="stat-subtext">Next bank payment: <strong style={{ color: 'var(--primary-dark)' }}>May 15, 2023</strong></div>
                </div>

                <div className="stat-card">
                    <h3>Active Customers</h3>
                    <div className="stat-value">324</div>
                    <div className="stat-subtext"><span className="highlight">+8 new</span> this week</div>
                </div>

                <div className="stat-card">
                    <h3>Products Listed</h3>
                    <div className="stat-value">87</div>
                    <div className="stat-subtext"><span className="highlight-red">-2 out of stock</span></div>
                </div>
            </div>

            {/* Product Status Cards */}
            <div className="product-status-section">
                <h2>Product Status</h2>
                <div className="product-status-grid">
                    <div className="product-status-card">
                        <h3>Requested Products</h3>
                        <div className="product-count">42</div>
                        <div className="stat-subtext">Last 7 days</div>
                    </div>

                    <div className="product-status-card">
                        <h3>Dispatched Products</h3>
                        <div className="product-count">38</div>
                        <div className="stat-subtext">This month</div>
                    </div>

                    <div className="product-status-card">
                        <h3>Returned Products</h3>
                        <div className="product-count">4</div>
                        <div className="stat-subtext">This month</div>
                    </div>

                    <div className="product-status-card">
                        <h3>Cancelled Products</h3>
                        <div className="product-count">2</div>
                        <div className="stat-subtext">This month</div>
                    </div>
                </div>
            </div>

            {/* Weekly Repayment Section */}
            <div className="repayment-section">
                <div className="section-header">
                    <h2>Weekly Bank Repayment</h2>
                    <div className="date-range">
                        <select value={repaymentFilter} onChange={(e) => setRepaymentFilter(e.target.value)}>
                            <option>Last 4 Weeks</option>
                            <option>Last 8 Weeks</option>
                            <option>Last 12 Weeks</option>
                        </select>
                        <select value={monthFilter} onChange={(e) => setMonthFilter(e.target.value)}>
                            <option>May 2023</option>
                            <option>April 2023</option>
                            <option>March 2023</option>
                        </select>
                    </div>
                </div>

                <div className="repayment-details">
                    <div>
                        <h3 style={{ marginBottom: '15px', color: 'var(--medium-text)', fontWeight: 600 }}>Repayment Trend</h3>
                        <div className="repayment-chart">
                            <div className="chart-bar" style={{ height: '85%' }}>
                                <div className="chart-bar-value">3,24,000</div>
                                <div className="chart-bar-label">This Week</div>
                            </div>
                            <div className="chart-bar" style={{ height: '75%' }}>
                                <div className="chart-bar-value">2,98,000</div>
                                <div className="chart-bar-label">Last Week</div>
                            </div>
                            <div className="chart-bar" style={{ height: '65%' }}>
                                <div className="chart-bar-value">2,87,000</div>
                                <div className="chart-bar-label">2 Weeks Ago</div>
                            </div>
                            <div className="chart-bar" style={{ height: '50%' }}>
                                <div className="chart-bar-value">2,21,000</div>
                                <div className="chart-bar-label">3 Weeks Ago</div>
                            </div>
                        </div>
                    </div>

                    <div className="repayment-summary">
                        <h3>Upcoming Settlement</h3>

                        <div className="summary-item">
                            <div>
                                <div style={{ fontWeight: 600, color: 'var(--dark-text)' }}>Scheduled Date</div>
                                <div style={{ fontSize: '14px', color: 'var(--medium-text)' }}>Week 20, 2023</div>
                            </div>
                            <div style={{ textAlign: 'right' }}>
                                <div style={{ fontWeight: 600, color: 'var(--dark-text)' }}>May 15, 2023</div>
                                <div style={{ fontSize: '14px', color: 'var(--medium-text)' }}>In 3 days</div>
                            </div>
                        </div>

                        <div className="summary-item">
                            <div>
                                <div style={{ fontWeight: 600, color: 'var(--dark-text)' }}>Amount to be Repaid</div>
                                <div style={{ fontSize: '14px', color: 'var(--medium-text)' }}>From bank to your account</div>
                            </div>
                            <div style={{ textAlign: 'right' }} className="summary-amount">
                                3,24,000
                            </div>
                        </div>

                        <div className="summary-item">
                            <div>
                                <div style={{ fontWeight: 600, color: 'var(--dark-text)' }}>Settlement Status</div>
                                <div style={{ fontSize: '14px', color: 'var(--medium-text)' }}>Processing by bank</div>
                            </div>
                            <div style={{ textAlign: 'right' }}>
                                <span className="status status-pending">Pending</span>
                            </div>
                        </div>

                        <button className="view-all-btn">
                            View Settlement Details
                        </button>
                    </div>
                </div>
            </div>

            {/* Recent Orders */}
            <div className="recent-orders-section">
                <div className="section-header">
                    <h2>Recent Orders</h2>
                    <Link to="/merchant/orders" className="view-all-btn">View All</Link>
                </div>

                <table className="orders-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Bank Repayment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style={{ fontWeight: 600, color: 'var(--primary-dark)' }}>#YN-7832</td>
                            <td>Md. Rahim Uddin</td>
                            <td>May 10, 2023</td>
                            <td style={{ fontWeight: 600 }}>৳ 1,245</td>
                            <td><span className="status status-completed">Completed</span></td>
                            <td><span style={{ color: 'var(--primary-color)', fontWeight: 600 }}>Scheduled</span></td>
                        </tr>
                        <tr>
                            <td style={{ fontWeight: 600, color: 'var(--primary-dark)' }}>#YN-7829</td>
                            <td>Fatema Begum</td>
                            <td>May 9, 2023</td>
                            <td style={{ fontWeight: 600 }}>৳ 899</td>
                            <td><span className="status status-dispatched">Dispatched</span></td>
                            <td><span style={{ color: 'var(--accent-color)', fontWeight: 600 }}>Pending</span></td>
                        </tr>
                        <tr>
                            <td style={{ fontWeight: 600, color: 'var(--primary-dark)' }}>#YN-7825</td>
                            <td>Kamal Hossain</td>
                            <td>May 8, 2023</td>
                            <td style={{ fontWeight: 600 }}>৳ 2,457</td>
                            <td><span className="status status-completed">Completed</span></td>
                            <td><span style={{ color: 'var(--primary-color)', fontWeight: 600 }}>Scheduled</span></td>
                        </tr>
                        <tr>
                            <td style={{ fontWeight: 600, color: 'var(--primary-dark)' }}>#YN-7818</td>
                            <td>Sharmin Akter</td>
                            <td>May 7, 2023</td>
                            <td style={{ fontWeight: 600 }}>৳ 673</td>
                            <td><span className="status status-pending">Pending</span></td>
                            <td><span style={{ color: 'var(--light-text)', fontWeight: 600 }}>Not Yet</span></td>
                        </tr>
                        <tr>
                            <td style={{ fontWeight: 600, color: 'var(--primary-dark)' }}>#YN-7810</td>
                            <td>Abdul Karim</td>
                            <td>May 5, 2023</td>
                            <td style={{ fontWeight: 600 }}>৳ 1,568</td>
                            <td><span className="status status-cancelled">Cancelled</span></td>
                            <td><span style={{ color: '#d32f2f', fontWeight: 600 }}>N/A</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default MerchantDashboard;
