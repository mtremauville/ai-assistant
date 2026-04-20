
# 🎾 Padel Maestro

> Your AI-powered padel coach. Train smarter, play better.

Padel Maestro is a full stack web application that generates personalized padel training sessions using AI. Solo or with a group, just tell it your level and what you want to work on — and get a tailored training plan instantly.

🐙 **Repository:** [github.com/mtremauville/ai-assistant](https://github.com/mtremauville/ai-assistant)

---

## ✨ Features

- 🤖 **AI-generated training sessions** — Describe your training type and level, get a personalized session powered by GPT-4o mini
- 👤 **Solo & group training** — Works for individual players or groups of multiple people
- 📊 **Training history** — Browse and review all your previous training sessions
- 🔐 **User authentication** — Secure signup and login via Devise

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Back-end | Ruby on Rails |
| Database | PostgreSQL |
| Front-end | HTML · SCSS · Bootstrap 5 |
| Interactivity | JavaScript · Stimulus.js |
| Authentication | Devise |
| AI | OpenAI GPT-4o mini · ruby_llm |
| Deployment | Heroku |
| Version control | Git · GitHub |

---

## 🧠 How it works

1. The user selects **solo or group** training mode
2. They specify their **level** (beginner, intermediate, advanced) and the **type of training** they want to focus on
3. GPT-4o mini generates a **structured training session** adapted to their input
4. The session is saved and accessible anytime from the **training history**

---

## 👤 Author

**Mickael Tremauville**
Diplômé Le Wagon — Promotion Janvier 2026
[github.com/mtremauville](https://github.com/mtremauville) · [linkedin.com/in/mickael-tremauville](https://linkedin.com/in/mickael-tremauville)

---

## 🚀 Getting Started

### Prerequisites

- Ruby 3.x
- Rails 8.x
- PostgreSQL
- An OpenAI API key

### Installation

```bash
git clone https://github.com/mtremauville/ai-assistant.git
cd ai-assistant
bundle install
rails db:create db:migrate db:seed

