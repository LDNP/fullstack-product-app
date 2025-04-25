import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';


const API_BASE = 'http://ec2-54-247-230-134.eu-west-1.compute.amazonaws.com:3000'; 

function App() {
  const [products, setProducts] = useState([]);
  const [editingId, setEditingId] = useState(null);
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [available, setAvailable] = useState(true);
  const [showAvailableOnly, setShowAvailableOnly] = useState(false);

  const fetchProducts = async () => {
    try {
      const res = await axios.get(`${API_BASE}/products`);
      setProducts(res.data);
    } catch (err) {
      console.error('Fetch failed', err);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

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
        await axios.patch(`${API_BASE}/products/${editingId}`, { product: productData });
      } else {
        await axios.post(`${API_BASE}/products`, { product: productData });
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

  const handleEdit = (product) => {
    setEditingId(product.id);
    setName(product.name);
    setDescription(product.description);
    setPrice(product.price);
    setAvailable(product.available);
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`${API_BASE}/products/${id}`);
      fetchProducts();
    } catch (err) {
      console.error('Delete failed', err);
    }
  };

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