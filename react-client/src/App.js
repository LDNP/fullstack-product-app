import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  // Form + state management
  const [products, setProducts] = useState([]);
  const [editingId, setEditingId] = useState(null);
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [available, setAvailable] = useState(true);
  const [showAvailableOnly, setShowAvailableOnly] = useState(false);

  // Load products from backend
  const fetchProducts = async () => {
    try {
      const res = await axios.get('http://localhost:3000/products');
      setProducts(res.data);
    } catch (err) {
      console.error('Fetch failed', err);
    }
  };

  // Initial fetch
  useEffect(() => {
    fetchProducts();
  }, []);

  // Save or update product
  const handleSubmit = async (e) => {
    e.preventDefault();

    const productData = {
      name,
      description,
      price: parseFloat(price),
      available,
    };

    try {
      if (editingId) {
        await axios.patch(`http://localhost:3000/products/${editingId}`, { product: productData });
      } else {
        await axios.post('http://localhost:3000/products', { product: productData });
      }

      fetchProducts();
      setName('');
      setDescription('');
      setPrice('');
      setAvailable(true);
      setEditingId(null);
    } catch (err) {
      console.error('Save error:', err);
    }
  };

  // Fill form for edit
  const handleEdit = (product) => {
    setEditingId(product.id);
    setName(product.name);
    setDescription(product.description);
    setPrice(product.price);
    setAvailable(product.available);
  };

  // Delete product
  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:3000/products/${id}`);
      fetchProducts();
    } catch (err) {
      console.error('Delete failed', err);
    }
  };

  // Filter list
  const filteredProducts = showAvailableOnly
    ? products.filter((p) => p.available)
    : products;

  return (
    <div className="container">
      <h1>Product Manager</h1>

      <form onSubmit={handleSubmit} className="product-form">
        <h2>{editingId ? 'Edit Product' : 'Add Product'}</h2>
        <input
          type="text"
          placeholder="Product Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <textarea
          placeholder="Description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          required
        />
        <input
          type="number"
          step="0.01"
          min="0"
          placeholder="Price (e.g. 9.99)"
          value={price}
          onChange={(e) => setPrice(e.target.value)}
          required
        />
        <label>
          <input
            type="checkbox"
            checked={available}
            onChange={(e) => setAvailable(e.target.checked)}
          />{' '}
          Available
        </label>
        <button type="submit">{editingId ? 'Update' : 'Save'} Product</button>
      </form>

      <div className="product-list">
        <h2>Product List</h2>
        <label>
          <input
            type="checkbox"
            checked={showAvailableOnly}
            onChange={() => setShowAvailableOnly(!showAvailableOnly)}
          />{' '}
          Show only available
        </label>

        {filteredProducts.length === 0 ? (
          <p>No products to show.</p>
        ) : (
          <ul>
            {filteredProducts.map((product) => (
              <li key={product.id} className="product-card">
                <strong>{product.name}</strong> - ${parseFloat(product.price).toFixed(2)}
                <p>{product.description}</p>
                <p>Available: {product.available ? 'Yes' : 'No'}</p>
                <button className="edit" onClick={() => handleEdit(product)}>
                  Edit
                </button>
                <button className="delete" onClick={() => handleDelete(product.id)}>
                  Delete
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

export default App;