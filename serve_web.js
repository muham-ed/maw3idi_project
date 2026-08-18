const express = require('express');
const path = require('path');
const app = express();
const port = 8080;

app.use(express.static(path.join(__dirname, 'build/web')));

app.get('/*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Flutter Web App is running at http://192.168.1.5:${port}`);
  console.log('Open this link in your browser to record the project.');
});
