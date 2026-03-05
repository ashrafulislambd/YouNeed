import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import './MerchantLogin.css';

const MerchantLogin = () => {
    const [credentials, setCredentials] = useState({
        username: 'admin',
        password: 'admin'
    });
    const navigate = useNavigate();
    const { login } = useAuth();

    const handleChange = (e) => {
        setCredentials({
            ...credentials,
            [e.target.name]: e.target.value
        });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (credentials.username === 'admin' && credentials.password === 'admin') {
            // Mock login - in real app, validate credentials
            console.log('Merchant login:', credentials);
            login('merchant');
            navigate('/merchant/dashboard', { replace: true });
        } else {
            alert('Invalid credentials! Default is admin/admin');
        }
    };

    return (
        <div className="merchant-login-container">
            <div className="merchant-login-card">
                <div className="merchant-login-logo">
                    <h2>You<span>Need</span></h2>
                    <p>Merchant Portal</p>
                </div>
                <form onSubmit={handleSubmit}>
                    <div className="input-group">
                        <label>Username / Email</label>
                        <input
                            type="text"
                            name="username"
                            value={credentials.username}
                            onChange={handleChange}
                            required
                        />
                    </div>
                    <div className="input-group">
                        <label>Password</label>
                        <input
                            type="password"
                            name="password"
                            value={credentials.password}
                            onChange={handleChange}
                            required
                        />
                    </div>
                    <button type="submit" className="merchant-login-btn">Login</button>
                    <div className="merchant-forgot-password">
                        <a href="#">Forgot Password?</a>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default MerchantLogin;
