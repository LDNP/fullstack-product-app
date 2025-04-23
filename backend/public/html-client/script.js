const API_URL = '/products';
const list = document.getElementById('product-list');
const form = document.getElementById('product-form');
const filterCheckbox = document.getElementById('filter-available');

function loadProducts() {
  fetch(API_URL)
    .then(res => {
      if (!res.ok) throw new Error(`Error: ${res.status}`);
      return res.json();
    })
    .then(products => {
      console.log("Fetched products:", products); // Optional: for debugging

      list.innerHTML = '';

      const filtered = filterCheckbox.checked
        ? products.filter(p => p.available)
        : products;

      if (!Array.isArray(filtered)) {
        console.error("Expected array, got:", filtered);
        list.innerHTML = '<li>Error loading product list.</li>';
        return;
      }

      filtered.forEach(product => {
        const price = parseFloat(product.price); // ✅ Safely parse price
        const formattedPrice = isNaN(price) ? 'N/A' : `$${price.toFixed(2)}`;

        const li = document.createElement('li');
        li.innerHTML = `
          <strong>${product.name}</strong> - ${formattedPrice}<br>
          ${product.description}<br>
          Available: ${product.available ? 'Yes' : 'No'}<br>
          <button onclick="editProduct(${product.id})">Edit</button>
          <button onclick="deleteProduct(${product.id})">Delete</button>
        `;
        list.appendChild(li);
      });
    })
    .catch(err => {
      console.error('Load failed:', err);
      list.innerHTML = '<li>Could not load products.</li>';
    });
}

function editProduct(id) {
  fetch(`${API_URL}/${id}`)
    .then(res => res.json())
    .then(p => {
      document.getElementById('product-id').value = p.id;
      document.getElementById('name').value = p.name;
      document.getElementById('description').value = p.description;
      document.getElementById('price').value = p.price;
      document.getElementById('available').checked = p.available;
    });
}

function deleteProduct(id) {
  fetch(`${API_URL}/${id}`, { method: 'DELETE' })
    .then(() => loadProducts())
    .catch(err => console.error('Delete failed:', err));
}

form.addEventListener('submit', (e) => {
  e.preventDefault();
  const id = document.getElementById('product-id').value;
  const product = {
    name: document.getElementById('name').value,
    description: document.getElementById('description').value,
    price: parseFloat(document.getElementById('price').value),
    available: document.getElementById('available').checked,
  };

  const method = id ? 'PATCH' : 'POST';
  const url = id ? `${API_URL}/${id}` : API_URL;

  fetch(url, {
    method: method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ product })
  })
    .then(res => {
      if (!res.ok) throw new Error('Save failed');
      return res.json();
    })
    .then(() => {
      form.reset();
      document.getElementById('product-id').value = '';
      loadProducts();
    })
    .catch(err => console.error('Save error:', err));
});

filterCheckbox.addEventListener('change', loadProducts);

// Load everything on page start
loadProducts();