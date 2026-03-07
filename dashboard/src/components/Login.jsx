import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './Login.css';

const Login = () => {
    const navigate = useNavigate();
    const { login } = useAuth();

    const [role, setRole] = useState('admin'); // 'admin' or 'merchant'
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');

    const handleLogin = (e) => {
        e.preventDefault();

        if (role === 'admin') {
            if (username === 'admin' && password === 'admin') {
                login('admin');
                navigate('/dashboard', { replace: true });
            } else {
                alert('Invalid credentials! Please use correct admin username and access key.');
            }
        } else if (role === 'merchant') {
            if (username === 'admin' && password === 'admin') {
                login('merchant');
                navigate('/merchant/dashboard', { replace: true });
            } else {
                alert('Invalid credentials! Default is admin/admin');
            }
        }
    };

    const isAdmin = role === 'admin';

    return (
        <div className="login-wrapper">
            <div className="login-container">
                <div className={`info-side ${isAdmin ? 'admin-theme' : 'merchant-theme'}`}>
                    <h1>YouNeed</h1>
                    <p>{isAdmin ? 'Admin Control Center' : 'Merchant Portal'}</p>
                    <small style={{ marginTop: 'auto', opacity: 0.8 }}>
                        {isAdmin ? 'Secure encrypted login for authorized personnel only.' : 'Manage your store, products, and orders securely.'}
                    </small>
                </div>
                <div className="form-side">

                    <div className="role-toggle-container">
                        <button
                            className={`role-toggle-btn ${isAdmin ? 'active admin-role' : ''}`}
                            onClick={() => { setRole('admin'); setUsername(''); setPassword(''); }}
                            type="button"
                        >
                            Admin
                        </button>
                        <button
                            className={`role-toggle-btn ${!isAdmin ? 'active merchant-role' : ''}`}
                            onClick={() => { setRole('merchant'); setUsername(''); setPassword(''); }}
                            type="button"
                        >
                            Merchant
                        </button>
                    </div>

                    <h2 className={isAdmin ? 'admin-theme-text' : 'merchant-theme-text'}>
                        {isAdmin ? 'Admin Login' : 'Merchant Login'}
                    </h2>

                    <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column' }}>
                        <input
                            type="text"
                            className={`login-input ${isAdmin ? 'admin-theme-focus' : 'merchant-theme-focus'}`}
                            placeholder={isAdmin ? "Admin Username" : "Username / Email"}
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            required
                        />
                        <input
                            type="password"
                            className={`login-input ${isAdmin ? 'admin-theme-focus' : 'merchant-theme-focus'}`}
                            placeholder={isAdmin ? "Access Key" : "Password"}
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                        <button type="submit" className={`submit-btn ${isAdmin ? 'admin-theme-btn' : 'merchant-theme-btn'}`}>
                            {isAdmin ? 'Enter Dashboard' : 'Login'}
                        </button>
                    </form>
                </div>
            </div>
            <footer className="login-footer">
                &copy; 2025 All Rights Reserved
            </footer>
        </div>
    );
};

export default Login;
