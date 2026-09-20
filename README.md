# 📱 iOS Habit Tracker App

An intuitive, lightweight, and modern iOS Habit Tracker app built with **SwiftUI** and powered by **SwiftData**. This app allows users to easily track daily habits, organize them by categories, filter progress, and maintain persistent storage locally.

## ✨ Features

* **Full CRUD Support**:

  * **Create**: Add new habits with categories and descriptions.

  * **Read**: Fetch and display habits seamlessly with automatic sorting (`@Query`).

  * **Update**: Toggle habit completion status, edit habit names, or re-assign categories.

  * **Delete**: Quick swipe-to-delete action and handling empty states gracefully.

* **Search & Filtering**: Search habits by name and filter by `All`, `Active`, or `Completed` statuses.

* **Data Persistence**: Local storage management using SwiftData's `ModelContainer` and `ModelContext`.

* **Dark Mode Support**: Persisted user preference for Dark Mode / Light Mode using `@AppStorage`.

* **Error Handling**: Explicit save checks and error handling mechanisms to safeguard app state.

## 🛠️ Tech Stack & Architecture

* **Language**: Swift 5.9+

* **UI Framework**: SwiftUI

* **Database / Persistence**: SwiftData (`@Model`, `ModelContainer`, `ModelContext`, `@Query`)

* **App State & Preferences**: `@AppStorage`, `@Binding`, `@State`

* **Target OS**: iOS 17.0+

## 📁 Core Architecture & Components

```
HabitTrackerApp/
│
├── Models/
│   ├── Habit.swift            # Model class annotated with @Model
│   └── Category.swift         # Category model and relationship logic
│
├── Views/
│   ├── ContentView.swift      # Main UI, fetch & display logic using @Query
│   ├── AddEditHabitView.swift # Logic for inserting and editing habits
│   └── Components/            # Custom reusable view components
│
└── App/
    └── HabitTrackerApp.swift  # App entry point configuring ModelContainer

```

## 📸 Functionality Highlights

| Feature | Swift Framework / API Used | 
 | ----- | ----- | 
| **Data Modeling** | `@Model` decorator in `Habit.swift` | 
| **Persistence Engine** | `.modelContainer` set up in `HabitTrackerApp.swift` | 
| **Querying & Sorting** | `@Query` wrapper in `ContentView.swift` | 
| **Actions (Insert/Delete)** | `ModelContext` (`insert()`, `delete()`) | 
| **Theme Preference** | `@AppStorage` for Dark Mode preference persistence | 

## 🧪 Testing Checklist

The app has been tested against the following scenarios:

1. \[x\] Create a new habit and assign a category.

2. \[x\] Search habits using the dynamic search bar.

3. \[x\] Filter view between **All**, **Active**, and **Completed**.

4. \[x\] Edit habit names and toggle completion states.

5. \[x\] Swipe to delete habits and verify empty view display.

6. \[x\] App restart tests to confirm data persistence across app launches.

## 🚀 Getting Started

### Prerequisites

* **Xcode 15.0** or later.

* **iOS 17.0+** SDK / Simulator.

### Installation

1. **Clone the repository:**

   ```
   git clone https://github.com/ramimhossain12/HabitTracker.git
   
   ```

2. **Open in Xcode:**

   ```
   cd HabitTrackerApp
   open HabitTrackerApp.xcodeproj
   
   ```

3. **Build & Run:**
   Select an iOS 17+ Simulator or connected physical device, then press `Cmd + R`.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
