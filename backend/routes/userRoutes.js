const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const verifyToken = require('../middleware/verifyToken');

router.post('/register', userController.register);
router.post('/login', userController.login);

// Protected routes (requires valid token to access)
router.get('/:id', verifyToken, userController.getProfile);
router.put('/:id', verifyToken, userController.updateProfile);

module.exports = router;
