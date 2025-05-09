# ilike

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## Routes
### ✅ **Auth Routes** (Already Done)

- `POST /register` – Register new user
- `POST /login` – Authenticate and return JWT

---

### 📄 **User Routes**

1. `GET /user/:id` – Get a user's public profile (name, bio, avatar)
2. `PUT /user/:id` – Update a user's profile (bio, avatar, name, etc.)
3. `GET /users` – Get all users (can filter later for swipe feed)

---

### ❤️ **Interaction Routes**

1. `POST /like/:id` – Like another user (id = liked user)
2. `POST /dislike/:id` – Optional: Dislike (could skip for now)
3. `GET /matches/:id` – Get all matched users (i.e., mutual likes)
