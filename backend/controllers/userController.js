const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../models/user");

exports.register = async (req, res) => {
  const { name, email, password, bio, avatar } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      bio,
      avatar,
    });
    await newUser.save();
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    res.status(500).json({ error: "Error registering user" });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ message: "Invalid credentials" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(400).json({ message: "Invalid credentials" });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });
    res.status(200).json({ token, userId: user._id });
  } catch (error) {
    res.status(500).json({ error: "Error logging in" });
  }
};

exports.getProfile = async (req, res) => {
  const userId = req.userId.trim(); // from the verifyToken middleware
  console.log(`📥 Getting profile for userId: ${userId}`);
  try {
    if (!userId) {
      console.error("❌ No userId found in params.");
      return res.status(400).json({ error: "User ID is required" });
    }

    const user = await User.findById(req.params.id).select("-password"); // exclude password from the response

    if (!user) {
      console.warn(`⚠️ No user found for ID: ${userId}`);
      return res.status(404).json({ message: "User not found" });
    }

    console.log("✅ User profile found:", user.name);
    res.status(200).json(user);
  } catch (error) {
    console.error("🔥 Error in getUserProfile:", error.message);
    res.status(500).json({ error: "Error fetching user profile" });
  }
};

exports.updateProfile = async (req, res) => {
  console.log("📤 Update profile hit");
  try {
    const updates = req.body;
    if (updates.password) {
      updates.password = await bcrypt.hash(updates.password, 10);
    }
    const user = await User.findByIdAndUpdate(req.params.id, updates, {
      new: true,
    }).select("-password");
    if (!user) return res.status(404).json({ message: "User not found" });
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ error: "Error updating user profile" });
  }
};

// return all users (excluding the one making request)
exports.getAllUsers = async (req, res) => {
  try {
    const currentUserId = req.user?.id; // from the verifyToken
    const users = await User.find({ _id: { $ne: currentUserId } }).select(
      "-password"
    ); // exclude the current user
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ error: "Error fetching users" });
  }
};

exports.likeUser = async (req, res) => {
  try {
    const currentUser = await User.findById(req.userId); // assuming req.userId is available in req.user.id
    const likedUser = await User.findById(req.params.id);

    if (!likedUser) return res.status(404).json({ message: "User not found" });

    if (currentUser.likes.includes(likedUser._id)) {
      return res.status(400).json({ message: "You already liked this user" });
    }

    currentUser.likes.push(likedUser._id);

    likedUser.followers.push(currentUser._id);

    await currentUser.save();
    await likedUser.save();

    res.status(200).json({
      message: "User liked successfully",
    });
  } catch (error) {
    console.error("🔥 Error in likeUser:", error.message);
    res.status(500).json({ error: "Error liking user" });
  }
};

exports.dislikeUser = async (req, res) => {
  try {
    const currentUser = await User.findById(req.userId); // assuming req.userId is available in req.user.id
    const dislikedUser = await User.findById(req.params.id);

    if (req.userId === req.params.id) {
      return res.status(400).json({ message: "You can't dislike yourself" });
    }

    if (!dislikedUser)
      return res.status(404).json({ message: "User not found" });

    // remove the disliked user from current user's likes
    currentUser.likes = currentUser.likes.filter(
      (like) => like.toString() !== dislikedUser._id.toString()
    );
    
    // remove the current user from disliked user's followers
    dislikedUser.followers = dislikedUser.followers.filter(
      (follower) => follower.toString() !== currentUser._id.toString()
    );

    await currentUser.save();
    await dislikedUser.save();

    res.status(200).json({
      message: "User disliked successfully",
    });
  } catch (error) {
    console.error("🔥 Error in dislikeUser:", error.message);
    res.status(500).json({ error: "Error disliking user" });
  }
};

exports.getMatches = async (req, res) => {
  try {
    const currentUser = await User.findById(req.userId); // assuming req.userId is available in req.user.id

    if (!currentUser)
      return res.status(404).json({ message: "User not found" });

    const matchedUsers = await User.find({
      _id: { $in: currentUser.likes }, // matches are mutual followers
      likes: req.userId,
    }).select("-password");

    if (matchedUsers.length === 0) {
      return res.status(404).json({ message: "No matches found" });
    }

    res.status(200).json(matchedUsers);
  } catch (error) {
    console.error("🔥 Error in getMatches:", error.message);
    res.status(500).json({ error: "Error fetching matches" });
  }
};
