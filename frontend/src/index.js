const express = require('express');
const path = require('path');
const app = express();
const axios = require('axios');

app.use(express.static(path.join(__dirname)));
app.use(express.json());

app.post('/submit', async (req, res) => {
  try {
    const result = await axios.post('http://backend-service:5000/store', req.body); // Kubernetes DNS
    res.json(result.data);
  } catch (error) {
    res.status(500).json({ error: 'Failed to send data to backend' });
  }
});

app.listen(3000, () => {
  console.log('Frontend server running on port 3000');
});