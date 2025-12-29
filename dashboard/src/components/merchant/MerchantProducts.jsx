import React, { useState } from 'react';
import './MerchantProducts.css';

const MerchantProducts = () => {
    const [products, setProducts] = useState([
        {
            name: 'Aarong Dairy Milk 1L',
            category: 'Dairy & Eggs',
            desc: 'Fresh pasteurized milk, rich in calcium and vitamins.',
            price: '120',
            stock: 45,
            icon: 'fas fa-wine-bottle'
        },
        {
            name: 'Pran Soybean Oil 5L',
            category: 'Oil & Ghee',
            desc: 'Pure soybean oil, perfect for cooking and frying.',
            price: '720',
            stock: 22,
            icon: 'fas fa-oil-can'
        },
        {
            name: 'Fresh Chicken 2kg',
            category: 'Meat & Fish',
            desc: 'Fresh farm chicken, cleaned and ready to cook.',
            price: '520',
            stock: 18,
            icon: 'fas fa-drumstick-bite'
        },
        {
            name: 'Fresh Eggs (Dozen)',
            category: 'Dairy & Eggs',
            desc: 'Farm fresh eggs, 12 pieces per pack.',
            price: '140',
            stock: 0,
            icon: 'fas fa-egg'
        },
        {
            name: 'Miniket Rice 50kg',
            category: 'Grains & Pulses',
            desc: 'Premium quality Miniket rice, polished and clean.',
            price: '3200',
            stock: 5,
            icon: 'fas fa-seedling'
        },
        {
            name: 'Ispahani Mirzapore Tea 400g',
            category: 'Beverages',
            desc: 'Best quality tea leaves for a refreshing morning.',
            price: '240',
            stock: 35,
            icon: 'fas fa-mug-hot'
        },
        {
            name: 'Ruchi BBQ Chanachur 300g',
            category: 'Snacks',
            desc: 'Spicy and crunchy snack, perfect for tea time.',
            price: '65',
            stock: 100,
            icon: 'fas fa-cookie-bite'
        },
        {
            name: 'Radhuni Turmeric Powder 200g',
            category: 'Spices',
            desc: 'Pure turmeric powder for vibrant color and taste.',
            price: '120',
            stock: 45,
            icon: 'fas fa-mortar-pestle'
        }
    ]);

    const [isAdding, setIsAdding] = useState(false);
    const [newProduct, setNewProduct] = useState({
        name: '',
        category: '',
        price: '',
        stock: '',
        desc: ''
    });

    const handleInputChange = (e) => {
        const { id, value } = e.target;
        setNewProduct(prev => ({
            ...prev,
            [id]: value
        }));
    };

    const handleAddProduct = (e) => {
        e.preventDefault();
        setProducts([...products, {
            name: newProduct.name,
            category: newProduct.category,
            desc: newProduct.desc,
            price: newProduct.price,
            stock: parseInt(newProduct.stock),
            icon: 'fas fa-box'
        }]);
        setIsAdding(false);
        setNewProduct({ name: '', category: '', price: '', stock: '', desc: '' });
    };

    return (
        <div className="products-management">
            <div className="products-header">
                <h2>All Products</h2>
                <div style={{ display: 'flex', gap: '15px', alignItems: 'center' }}>
                    {!isAdding && (
                        <div className="products-filters">
                            <select>
                                <option>All Categories</option>
                                <option>Dairy & Eggs</option>
                                <option>Oil & Ghee</option>
                                <option>Meat & Fish</option>
                                <option>Vegetables</option>
                                <option>Beverages</option>
                                <option>Snacks</option>
                            </select>
                            <select>
                                <option>All Stock</option>
                                <option>In Stock</option>
                                <option>Out of Stock</option>
                            </select>
                            <input type="text" placeholder="Search products..." />
                        </div>
                    )}
                    <button className="add-product-btn" onClick={() => setIsAdding(!isAdding)}>
                        <i className={`fas ${isAdding ? 'fa-times' : 'fa-plus'}`}></i>
                        {isAdding ? 'Cancel' : 'Add Product'}
                    </button>
                </div>
            </div>

            {isAdding ? (
                <div className="add-product-section">
                    <h3>Add New Product</h3>
                    <form onSubmit={handleAddProduct}>
                        <div className="form-row">
                            <div className="form-group">
                                <label htmlFor="name">Product Name</label>
                                <input type="text" id="name" className="form-control" placeholder="Enter product name" value={newProduct.name} onChange={handleInputChange} required />
                            </div>
                            <div className="form-group">
                                <label htmlFor="category">Category</label>
                                <select id="category" className="form-control" value={newProduct.category} onChange={handleInputChange} required>
                                    <option value="">Select category</option>
                                    <option>Dairy & Eggs</option>
                                    <option>Oil & Ghee</option>
                                    <option>Meat & Fish</option>
                                    <option>Vegetables</option>
                                    <option>Beverages</option>
                                    <option>Snacks</option>
                                    <option>Spices</option>
                                    <option>Grains & Pulses</option>
                                </select>
                            </div>
                        </div>

                        <div className="form-row">
                            <div className="form-group">
                                <label htmlFor="price">Price (৳)</label>
                                <input type="number" id="price" className="form-control" placeholder="Enter price in Taka" value={newProduct.price} onChange={handleInputChange} required />
                            </div>
                            <div className="form-group">
                                <label htmlFor="stock">Stock Quantity</label>
                                <input type="number" id="stock" className="form-control" placeholder="Enter stock quantity" value={newProduct.stock} onChange={handleInputChange} required />
                            </div>
                        </div>

                        <div className="form-group">
                            <label htmlFor="desc">Description</label>
                            <textarea id="desc" className="form-control" placeholder="Enter product description" value={newProduct.desc} onChange={handleInputChange}></textarea>
                        </div>

                        <div className="form-actions">
                            <button type="submit" className="submit-btn">
                                <i className="fas fa-save"></i>
                                Save Product
                            </button>
                            <button type="button" className="cancel-btn" onClick={() => setIsAdding(false)}>
                                <i className="fas fa-times"></i>
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
            ) : (
                <div className="products-grid">
                    {products.map((prod, idx) => (
                        <div className="product-card" key={idx}>
                            <div className="product-image">
                                <i className={prod.icon}></i>
                            </div>
                            <div className="product-details">
                                <div className="product-name">{prod.name}</div>
                                <div className="product-category">{prod.category}</div>
                                <div className="product-description">{prod.desc}</div>
                                <div className="product-info">
                                    <div className="product-price">{prod.price}</div>
                                    <div className="product-stock">
                                        Stock: <span className={prod.stock > 0 ? "stock-in" : "stock-out"}>{prod.stock} units</span>
                                    </div>
                                </div>
                                <div className="product-actions">
                                    <button className="action-btn edit-btn">{prod.stock === 0 ? 'Restock' : 'Edit'}</button>
                                    <button className="action-btn delete-btn">Delete</button>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default MerchantProducts;
