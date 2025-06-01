# ilike

A new Flutter project.

## Getting Started

iLike is a sleek, modern dating app built using Flutter and MongoDB. It’s designed with user experience in mind, incorporating swipe-based discovery, chat, and more. This repository documents the full app development across 7 agile sprints.

**Frontend:** Flutter (Material 2)  
**Backend:** Node.js, Express, MongoDB  
**Authentication:** JWT  
**Others:** Google Fonts, Flutter Native Splash, Custom Theming

## 📅 Development Timeline (Sprints)

| Sprint | Focus Area                             | Status     |
|--------|----------------------------------------|------------|
| Sprint 1 | Project Setup, Git, Splash, Login, Signup, Validation     | ✅ Completed |
| Sprint 2 | Native Splash, User Card, Theming, Bottom-Nav, Dashboard  | ✅ Completed |
| Sprint 3 | Dark/Light Mode, Api Development            | 🔄 In Progress |
| Sprint 4 | User Profile, Edit Profile, Firebase Auth   | ⏳ Upcoming |
| Sprint 5 | Matchmaking Logic, Backend Integration      | ⏳ Upcoming |
| Sprint 6 | Real-time Chat, Socket.io or Firebase       | ⏳ Upcoming |
| Sprint 7 | Final UI Polish, Testing, Deployment        | ⏳ Upcoming |

## 🎥 Demo Videos

- [Sprint 1 Demo](#)
- [Sprint 2 Demo](#)


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

## 🚀 How to Run

```bash
flutter pub get
flutter run


MIT License – feel free to fork and contribute.
