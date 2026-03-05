import React from 'react';
import './Dashboard.css';

const DashboardHome = () => {

    const renderLeaderboardItem = (rank, name, value, isCurrency = true) => {
        let rankClass = 'rank-other';
        if (rank === 1) rankClass = 'rank-1';
        if (rank === 2) rankClass = 'rank-2';
        if (rank === 3) rankClass = 'rank-3';

        return (
            <div className={`leaderboard-item ${rankClass}`} key={name}>
                <div className="rank-info">
                    <div className="rank-badge">{rank}</div>
                    <div className="item-name">{name}</div>
                </div>
                <div className="item-value">{isCurrency ? value : value}</div>
            </div>
        );
    };

    return (
        <div className="dashboard-content">
            <div className="cards">
                <div className="card">
                    <h4>Total Users</h4>
                    <p>12,540</p>
                </div>
                <div className="card">
                    <h4>Total Merchants</h4>
                    <p>620</p>
                </div>
                <div className="card">
                    <h4>Total Due Amount</h4>
                    <p>৳ 41.2M</p>
                </div>
                <div className="card">
                    <h4>Active Loans</h4>
                    <p>4,312</p>
                </div>
            </div>

            <div className="chart">
                <h4>Monthly Transaction Trend</h4>
                <div className="chart-container">
                    <div className="y-axis">
                        <span>1500</span>
                        <span>1200</span>
                        <span>900</span>
                        <span>600</span>
                        <span>300</span>
                        <span>0</span>
                    </div>
                    <div className="bars">
                        <div className="bar" style={{ height: '60%' }}><span>Jan</span></div>
                        <div className="bar" style={{ height: '45%' }}><span>Feb</span></div>
                        <div className="bar" style={{ height: '70%' }}><span>Mar</span></div>
                        <div className="bar" style={{ height: '80%' }}><span>Apr</span></div>
                        <div className="bar" style={{ height: '95%' }}><span>May</span></div>
                    </div>
                </div>
            </div>

            <div className="sections">

                <div className="section">
                    <h4>Top Users</h4>
                    <div className="leaderboard-list">
                        {renderLeaderboardItem(1, 'Rahim Uddin', '৳ 98,000')}
                        {renderLeaderboardItem(2, 'Salma Akter', '৳ 87,500')}
                        {renderLeaderboardItem(3, 'Hasan Ali', '৳ 76,200')}
                        {renderLeaderboardItem(4, 'Tarek Mahmud', '৳ 45,000')}
                    </div>
                </div>

                <div className="section">
                    <h4>Top Merchants</h4>
                    <div className="leaderboard-list">
                        {renderLeaderboardItem(1, 'Maa Pharmacy', '৳ 1.2M')}
                        {renderLeaderboardItem(2, 'Daily Needs Store', '৳ 940K')}
                        {renderLeaderboardItem(3, 'Healthy Life Mart', '৳ 820K')}
                    </div>
                </div>

                <div className="section">
                    <h4>Bank-wise Loan Received</h4>
                    <div className="leaderboard-list">
                        {renderLeaderboardItem(1, 'BRAC Bank', '৳ 18.5M')}
                        {renderLeaderboardItem(2, 'Dutch-Bangla', '৳ 13.2M')}
                        {renderLeaderboardItem(3, 'City Bank', '৳ 9.5M')}
                    </div>
                </div>

                <div className="section">
                    <h4>Top Products</h4>
                    <div className="leaderboard-list">
                        {renderLeaderboardItem(1, 'Milk Powder', '2.5K Units', false)}
                        {renderLeaderboardItem(2, 'Infant Formula', '1.8K Units', false)}
                        {renderLeaderboardItem(3, 'Insulin & Meds', '1.2K Units', false)}
                    </div>
                </div>

            </div>

            <footer style={{ marginTop: '40px', textAlign: 'center', fontSize: '13px', color: 'var(--muted)', paddingBottom: '20px' }}>
                &copy; 2025 All Rights Reserved
            </footer>
        </div>
    );
};

export default DashboardHome;
