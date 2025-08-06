# iLike

## Getting Started

iLike is a sleek, modern dating app built using Flutter and MongoDB. It’s designed with user experience in mind, incorporating swipe-based discovery, chat, and more. This repository documents the full app development across 7 agile sprints.

**Frontend:** Flutter   
**Backend:** Node.js, Express, MongoDB  
**Authentication:** JWT
**Testing:**  Mocktail, bloc_test, test_cov_console
**Others:** Google Fonts, Flutter Native Splash, Custom Theming

## 📅 Development Timeline (Sprints)

| Sprint | Focus Area                             | Status     |
|--------|----------------------------------------|------------|
| Sprint 1 | Project Setup, Git, Splash, Login, Signup, Validation     | ✅ Completed |
| Sprint 2 | Native Splash, User Card, Theming, Bottom-Nav, Dashboard  | ✅ Completed |
| Sprint 3 | Dark/Light Mode, Hive local storage, encorporate clean architecture  | ✅ Completed |
| Sprint 4 | User Profile, Onboarding, Api development   | ✅ Completed |
| Sprint 5 | Matchmaking Logic, Matches/Likes page, Testing    | ✅ Completed |
| Sprint 6 | Real-time Chat, Socket.io or Firebase       | ✅ Completed |
| Sprint 7 | Final UI Polish, Testing, Deployment        | ✅ Completed |

## 🎥 Demo Videos

- [Final Demo Video](https://youtu.be/mmcjWEIOPps)
  
- [Sprint 1 Demo](https://youtu.be/j95juPp9d7w)
- [Sprint 2 Demo](https://youtu.be/H4Yev9rif5Q)
- [Sprint 3 Demo](https://youtu.be/Uc60R-o47gQ)
- [Sprint 4 Demo](https://youtu.be/WWDHckMEdPU)
- [Sprint 5 Demo](https://youtu.be/3KoR120iF30)


## Routes
### ✅ **Auth Routes** 
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
