import React from 'react';
import {
  LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer
} from 'recharts';
import './MerchantAnalytics.css';

const MerchantAnalytics = () => {
  // Mock Data
  const weeklySalesData = [
    { week: 'Week 1', products: 120, amount: 15000 },
    { week: 'Week 2', products: 132, amount: 18000 },
    { week: 'Week 3', products: 101, amount: 12000 },
    { week: 'Week 4', products: 154, amount: 22000 },
    { week: 'Week 5', products: 190, amount: 28000 },
    { week: 'Week 6', products: 230, amount: 35000 },
  ];

  const productQuantityData = [
    { name: 'Rice', quantity: 400 },
    { name: 'Oil', quantity: 300 },
    { name: 'Sugar', quantity: 200 },
    { name: 'Salt', quantity: 278 },
    { name: 'Lentils', quantity: 189 },
  ];

  const topProductsData = [
    { name: 'Rice (Miniket)', sales: 50000 },
    { name: 'Soybean Oil', sales: 45000 },
    { name: 'Masoor Dal', sales: 30000 },
    { name: 'Sugar (Deshi)', sales: 25000 },
    { name: 'Ata', sales: 20000 },
  ];

  return (
    <div className="merchant-analytics-container">
      <h2>Sales Analytics</h2>
      
      <div className="analytics-grid">
        {/* Chart 1: Products Sold vs Weeks */}
        <div className="chart-card">
          <h3>Products Sold (Weekly)</h3>
          <div className="chart-wrapper">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={weeklySalesData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="week" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="products" stroke="#8884d8" activeDot={{ r: 8 }} name="Products Sold" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Chart 2: Total Amount Sold vs Weeks */}
        <div className="chart-card">
          <h3>Total Amount Sold (Weekly)</h3>
          <div className="chart-wrapper">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={weeklySalesData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="week" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="amount" stroke="#82ca9d" name="Amount (৳)" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Chart 3: Product Name vs Quantity Sold */}
        <div className="chart-card full-width">
          <h3>Product Quantity Sold</h3>
          <div className="chart-wrapper">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={productQuantityData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="quantity" fill="#8884d8" name="Quantity Sold" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Chart 4: Top Products Sold (By Value) */}
        <div className="chart-card full-width">
          <h3>Top Selling Products (By Value)</h3>
          <div className="chart-wrapper">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={topProductsData} layout="vertical">
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis type="number" />
                <YAxis dataKey="name" type="category" width={100} />
                <Tooltip />
                <Legend />
                <Bar dataKey="sales" fill="#ffc658" name="Total Sales (৳)" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MerchantAnalytics;
