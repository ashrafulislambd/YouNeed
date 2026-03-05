import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import './MerchantOrders.css';

const MerchantOrders = () => {
    // Mock data for initial state
    const [orders, setOrders] = useState([
        {
            id: '#YN-7832',
            customer: {
                name: 'Md. Rahim Uddin',
                phone: '01711-223344',
                email: 'rahim@gmail.com',
                address: 'House# 45, Road# 7, Mirpur, Dhaka'
            },
            products: [
                { name: 'Aarong Dairy Milk 1L', qty: 'x2', price: '240' },
                { name: 'Pran Soybean Oil 5L', qty: 'x1', price: '720' },
                { name: 'Fresh Eggs (Dozen)', qty: 'x1', price: '140' },
                { name: 'Noodles Packet', qty: 'x3', price: '145' }
            ],
            timestamp: { time: '10:45 AM', date: 'May 10, 2023', status: 'Order placed' },
            amount: '1,245',
            status: 'Completed',
            bank: { status: 'Scheduled', date: 'May 15, 2023', type: 'scheduled' }
        },
        {
            id: '#YN-7830',
            customer: { name: 'Karimul Hassan', phone: '01911-887766', email: 'karim@hotmail.com', address: 'Plot 5, Road 2, Gulshan 1, Dhaka' },
            products: [
                { name: 'Miniket Rice 10kg', qty: 'x1', price: '650' },
                { name: 'Ruchi BBQ Chanachur', qty: 'x2', price: '120' }
            ],
            timestamp: { time: '11:20 AM', date: 'May 10, 2023', status: 'Processing' },
            amount: '770',
            status: 'Pending',
            bank: { status: 'Not Yet', date: '-', type: 'notyet' }
        },
        {
            id: '#YN-7829',
            customer: { name: 'Fatema Begum', phone: '01822-334455', email: 'fatema@yahoo.com', address: 'Flat# B3, House# 12, Dhanmondi, Dhaka' },
            products: [
                { name: 'Teer Sugar 2kg', qty: 'x2', price: '180' },
                { name: 'Milk Vita Powder 500g', qty: 'x1', price: '320' },
                { name: 'Ispahani Tea 200g', qty: 'x1', price: '130' }
            ],
            timestamp: { time: '02:15 PM', date: 'May 9, 2023', status: 'Dispatched: 03:30 PM' },
            amount: '899',
            status: 'Dispatched',
            bank: { status: 'Pending', date: 'After delivery', type: 'pending' }
        },
        {
            id: '#YN-7828',
            customer: { name: 'Sajid Ahmed', phone: '01677-445566', email: 'sajid@gmail.com', address: 'House 10, Road 4, Banani' },
            products: [
                { name: 'Rupchanda Oil 5L', qty: 'x1', price: '750' },
                { name: 'Salt 1kg', qty: 'x1', price: '35' }
            ],
            timestamp: { time: '04:10 PM', date: 'May 9, 2023', status: 'Completed' },
            amount: '785',
            status: 'Completed',
            bank: { status: 'Scheduled', date: 'May 15, 2023', type: 'scheduled' }
        },
        {
            id: '#YN-7825',
            customer: { name: 'Anisur Rahman', phone: '01555-554433', email: 'anis@imail.com', address: 'Sector 7, House 22, Uttara' },
            products: [
                { name: 'Beef 2kg', qty: 'x1', price: '1400' },
                { name: 'Polao Rice 2kg', qty: 'x1', price: '240' },
                { name: 'Spices Mix', qty: 'x3', price: '150' }
            ],
            timestamp: { time: '09:30 AM', date: 'May 8, 2023', status: 'Completed' },
            amount: '1,790',
            status: 'Completed',
            bank: { status: 'Scheduled', date: 'May 15, 2023', type: 'scheduled' }
        }
    ]);

    const filteredOrders = orders; // Place for filter logic if needed

    return (
        <div className="orders-management">
            <div className="orders-header">
                <h2>All Orders</h2>
                <div className="orders-filters">
                    <select>
                        <option>All Status</option>
                        <option>Pending</option>
                        <option>Dispatched</option>
                        <option>Completed</option>
                        <option>Cancelled</option>
                    </select>
                    <select>
                        <option>Last 30 Days</option>
                        <option>Last Week</option>
                        <option>Last Month</option>
                        <option>Last 3 Months</option>
                    </select>
                    <input type="text" placeholder="Search Order ID or Customer" />
                </div>
            </div>

            <div className="orders-table-container">
                <table className="orders-detail-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer Information</th>
                            <th>Order Details</th>
                            <th>Timestamp</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Bank Repayment</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredOrders.map((order, index) => (
                            <tr key={index}>
                                <td>
                                    <div className="order-id">{order.id}</div>
                                </td>
                                <td>
                                    <div className="customer-info">
                                        <div className="customer-name">{order.customer.name}</div>
                                        <div className="customer-contact">Phone: {order.customer.phone}</div>
                                        <div className="customer-contact">Email: {order.customer.email}</div>
                                        <div className="customer-address">{order.customer.address}</div>
                                    </div>
                                </td>
                                <td>
                                    <div className="order-details">
                                        {order.products.map((prod, idx) => (
                                            <div className="product-item" key={idx}>
                                                <span className="product-name">{prod.name}</span>
                                                <span className="product-qty">{prod.qty}</span>
                                                <span className="product-price">{prod.price}</span>
                                            </div>
                                        ))}
                                    </div>
                                </td>
                                <td>
                                    <div className="timestamp">
                                        <div className="time">{order.timestamp.time}</div>
                                        <div className="date">{order.timestamp.date}</div>
                                        <div style={{ fontSize: '12px', color: 'var(--light-text)', marginTop: '5px' }}>{order.timestamp.status}</div>
                                    </div>
                                </td>
                                <td>
                                    <div className="order-amount">{order.amount}</div>
                                </td>
                                <td>
                                    <span className={`status status-${order.status.toLowerCase()}`}>{order.status}</span>
                                </td>
                                <td>
                                    <div className={`bank-repayment bank-${order.bank.type}`}>{order.bank.status}</div>
                                    <div style={{ fontSize: '12px', color: 'var(--medium-text)', marginTop: '3px' }}>{order.bank.date}</div>
                                </td>
                                <td>
                                    <button className="action-btn">View</button>
                                    <button className="action-btn">Invoice</button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            <div className="pagination">
                <button className="page-btn"><i className="fas fa-chevron-left"></i></button>
                <button className="page-btn active">1</button>
                <button className="page-btn">2</button>
                <button className="page-btn">3</button>
                <button className="page-btn">4</button>
                <button className="page-btn">5</button>
                <button className="page-btn"><i className="fas fa-chevron-right"></i></button>
            </div>
        </div>
    );
};

export default MerchantOrders;
