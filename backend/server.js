const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();
console.log('Loaded JWT_SECRET:', process.env.JWT_SECRET);

const app = express();

app.use(cors());
app.use(express.json());

const authRoutes = require('./routes/auth');
app.use('/api/auth', authRoutes);

//MONGODB CONNECTION
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})

app.get('/', (req, res) => {
  res.send('iLike application backend is running!');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});