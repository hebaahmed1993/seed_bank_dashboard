# 🌿 SeedBank Dashboard

> **Status:** 🚧 Under Active Development (قيد التطوير المستمر)

A central cloud-based management dashboard built with **Flutter Web** for e-commerce platforms, originally designed for agricultural supply stores (seedlings, equipment, fertilizers) with an architectural flexibility that allows it to be re-customized for any commercial activity.

---

## 📑 Table of Contents
1. [Overview](#-overview)
2. [Architecture & Folder Structure](#-architecture--folder-structure)
3. [Cloud Firestore Schema](#-cloud-firestore-schema)
4. [Source Code Snippets](#-source-code-snippets)

---

## 🌟 Overview

* **Platform:** Flutter Web - SaaS Dashboard.
* **Current Domain:** Agricultural & Farming supplies management.
* **Flexibility:** Cleanly architected to be adaptable to various e-commerce verticals.
* **State Management:** Powered by **Riverpod** (`StateNotifier` & `StreamProvider`).
* **Cloud & Storage:**
  * Real-time **Cloud Firestore**.
  * **SharedPreferences** for local preferences (Language, Theme, Colors).

---

## 🏗️ Architecture & Folder Structure

The project follows **Clean Architecture** combined with a **Feature-First** structure to ensure high scalability and maintainability:

```text
lib/
├── app/          # Core operational setups (app_initializer, app_routes, main_navigation)
├── core/         # Shared utilities (enums, localization, storage, theme, custom widgets)
└── features/     # Feature modules (auth, dashboard, categories, inventory, orders...)
    └── categories/
        ├── data/          # (datasources, models, repositories implementations)
        ├── domain/        # (repositories contracts, usecases)
        └── presentation/  # (pages, providers, widgets)