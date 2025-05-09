const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  console.log("🔍 Verifying token..."); // Log the start of token verification
  const authHeader = req.headers.authorization;
  console.log("Authorization Header:", authHeader); // Log the authorization header for debugging

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.log("No token provided or invalid format"); // Log if no token is provided or format is invalid
    return res.status(401).json({ message: "No token provided" });
  }

  const token = authHeader.split(" ")[1];
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    console.log("✅ Token verified, decoded payload:", decoded);
    next(); // Proceed to the next middleware or route handler
  } catch (error) {
    console.log("❌ Invalid token", error.message);
    return res.status(401).json({ message: "Invalid token" }); // Token is invalid so unauthorize the request
  }
};

module.exports = verifyToken;
