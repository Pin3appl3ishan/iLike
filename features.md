# 📱 iLike App – Feature Reference (Flutter + MERN)

A cross-platform dating app with a shared backend (MongoDB + Node.js), supporting both mobile (Flutter) and web (React + TypeScript).

---

## 🧑‍💼 USER FEATURES

### 🟢 Auth & Onboarding
- ✅ Signup/Login (Email + Password)
- ✅ Local session management (Hive for Flutter, JWT for Web)
- ✅ isLoggedIn flag for gated access
- 🟡 Onboarding/intro slides (optional)

### 👤 Profile Setup
- ✅ Choose gender and interests
- ✅ Upload profile picture
- 🔶 Enter age/bio (optional)
- 🔶 Save profile locally (Hive)
- ✅ Save profile remotely (MongoDB)

### 🔀 Matchmaking
- ✅ Swipe-based matching (Tinder-like)
  - ✅ Like / Dislike functionality
  - ✅ Store mutual match in DB


### 💬 Chat
- ✅ 1-on-1 chat interface
- 🔶 Show chat history (mock or live)
- 🔶 Send & receive messages (REST first, socket.io optional)
- 🟡 Typing indicator / Seen status
- 🔶 Show “You’ve Matched!” screen

### 🛠 Settings & Logout
- ✅ Logout
- 🟡 Edit profile
- ❌ Block/Report user (Post-MVP)
- ❌ Dark mode toggle (Post-MVP)

---

## 🛡️ ADMIN FEATURES

### 📊 Dashboard Overview
- ✅ View total users, matches, messages
- ✅ Show recent signups

### 👥 User Management
- ✅ View all users
- ✅ Ban / Unban users
- ✅ Delete user
- ✅ Search / Filter by name/email/date

### ❤️ Match Management
- ✅ View all match pairs
- ✅ Delete match
- 🔶 View active chats (optional)

---

## ✅ MoSCoW Prioritization Summary

| Feature | Priority | Notes |
|--------|----------|-------|
| Signup/Login (Email + Password) | ✅ **Must** | Core functionality |
| Local session (Hive / JWT) | ✅ **Must** | Persistent login |
| isLoggedIn flag | ✅ **Must** | Access control |
| Profile setup (gender, interests, pic) | ✅ **Must** | Required for matching |
| Save profile remotely | ✅ **Must** | Matching backend |
| Swipe UI & Like/Dislike | ✅ **Must** | Primary interaction |
| Mutual match storage | ✅ **Must** | Needed for chat |
| Chat interface (basic) | ✅ **Must** | MVP-level chat |
| Logout | ✅ **Must** | Session security |
| Random match | 🔶 **Should** | Adds uniqueness |
| You’ve matched screen | 🔶 **Should** | UX improvement |
| Chat history & messaging | 🔶 **Should** | REST + fallback |
| Edit profile | 🟡 **Could** | Useful, but optional |
| Typing / Seen indicators | 🟡 **Could** | Cosmetic +
 UX |
| Dark mode, Block/Report | ❌ **Won’t** | Post-MVP scope |

---

## 👥 USER STORIES

### As a **User**, I want to:
- Sign up / log in securely.
- Set up my profile with gender, interests, and picture.
- Swipe left/right to match with others.
- Receive a match alert on mutual likes.
- Randomly connect to someone online.
- Chat with matched users.
- Log out securely.

### As an **Admin**, I want to:
- View stats of users and matches.
- See a searchable list of users.
- Ban, unban, or delete users as needed.
- View and manage match data.
- Investigate abusive or buggy user connections.

---

## 🔧 Tech Stack

| Layer | Tech |
|-------|------|
| Mobile App | Flutter (Clean Architecture + Hive) |
| Web App | React + TypeScript + Tailwind |
| Backend | Node.js + Express + MongoDB |
| Real-time Chat | REST for MVP, Socket.io for later |
| Admin Dashboard | React with Tailwind UI |
