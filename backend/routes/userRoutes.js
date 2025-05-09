const express = require('express');
const router = express.Router();
const {register, login, getProfile, updateProfile, getAllUsers, likeUser, dislikeUser, getMatches} = require('../controllers/userController');
const verifyToken = require('../middleware/verifyToken');

router.post('/register', register);
router.post('/login', login);

// Protected routes (requires valid token to access)
router.get('/profile/:id', verifyToken, getProfile);
router.put('/profile/:id', verifyToken, updateProfile);

router.get('/', verifyToken, getAllUsers);

router.post('/like/:id', verifyToken, likeUser);

router.post('/dislike/:id', verifyToken, dislikeUser);

router.get('/matches', verifyToken, getMatches);

module.exports = router;
