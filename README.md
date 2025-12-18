# 📱 Flutter Chat App

A Flutter application for a **polling-based one-to-one chat system** with **JWT authentication** and **backend-enforced permissions**.

---

## 🚀 App Flow
1. Splash Screen
2. Login / Register
3. User List
4. Chat Conversation
5. My Profile

---

## 🧭 Navigation & Routes

The app uses centralized route management via `AppRoutes`.

### Available Routes
| Route | Screen |
|-----|-------|
| `/` | SplashView |
| `/login` | LoginView |
| `/register` | RegisterView |
| `/user-list` | UserListView |
| `/chat-conversation` | ChatConversationView |
| `/my-profile` | MyProfileView |

Chat navigation requires arguments:
- `userId`
- `userName`
- `isTargetUserAllowed`

Missing arguments are safely handled with an error screen.

---

## 🔐 Authentication
- Users authenticate using **email and password**
- JWT token is stored securely after login
- All API requests include the token in headers
- Unauthorized users are redirected to login

---

## 👥 User List
- Displays all users except the logged-in user
- Shows online / last seen status
- Blocked users are handled based on backend response
- Selecting a user opens a chat conversation

---

## 💬 Chat Conversation
- One-to-one messaging only
- Messages are fetched using **HTTP polling**
- Polling starts when the chat screen is active
- Polling stops when leaving the screen
- Only new messages are fetched per poll
- Chat history loads with pagination
- Messages are ordered correctly
- Read/unread state is supported

---

## 🚦 Permission Handling
- User permission (`allowed`) is enforced **on the backend**
- Frontend uses permission flags only for UI behavior
- If a user is blocked:
  - Message input is disabled
  - Backend returns permission-denied errors
- Frontend displays proper error messages

---

## 👁️ Read Receipts
- Messages include read/unread status
- Messages are marked as read when chat is opened
- Status updates on the next polling cycle

---

## 🟢 Online / Last Seen
- Online status derived from recent API activity
- `lastSeen` value shown in user list and profile
- No WebSockets used

---

## 🧱 Architecture
- Feature-based structure
- Clean separation of UI, logic, and data
- Centralized routing
- Reusable widgets and services

---

## ⚠️ Error Handling
- API errors are handled gracefully
- Permission errors are clearly shown to the user
- Missing route arguments are safely handled

---

## 📦 Requirements
- Flutter (latest stable)
- Backend Node.js API running
- Internet connection for polling

---

## ✅ Key Highlights
- Polling-based chat (no WebSockets)
- Secure JWT authentication
- Backend-enforced permissions
- Clean routing and architecture
- Interview-assignment compliant

---
