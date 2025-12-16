import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './Login.css';

const Login = () => {
    const navigate = useNavigate();
    const { login } = useAuth();
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');

    const handleLogin = (e) => {
        e.preventDefault();

        if (username === 'admin' && password === 'admin123') {
            login();
            navigate('/dashboard', { replace: true });
        } else {
            alert('Invalid credentials! Please use correct admin username and access key.');
        }
    };

    return (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', width: '100%', height: '100vh', justifyContent: 'center' }}>
            <div className="login-container">
                <div className="info-side">
                    <h1>YouNeed</h1>
                    <p>Admin Control Center</p>
                    <small style={{ marginTop: 'auto', opacity: 0.8 }}>Secure encrypted login for authorized personnel only.</small>
                </div>
                <div className="form-side">
                    <h2>Admin Login</h2>
                    <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column' }}>
                        <input
                            type="text"
                            className="login-input"
                            placeholder="Admin Username"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                        />
                        <input
                            type="password"
                            className="login-input"
                            placeholder="Access Key"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                        />
                        <button type="submit" className="admin-btn">Enter Dashboard</button>
                    </form>
                </div>
            </div>
            <footer style={{ marginTop: '20px', fontSize: '13px', color: '#6b7280' }}>
                &copy; 2025 All Rights Reserved
            </footer>
        </div>
    );
};

export default Login;
