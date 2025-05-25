# pragmacat


# **Cat Breeds App**

A Flutter application that displays information about cat breeds using The Cat API. The app is built following the MVVM architecture, applying SOLID principles, and utilizing Riverpod for state management.

## Screenshots

Splash Screen

Home Screen

Details Screen

## Technologies Used

Flutter
Riverpod
Dio
GoRouter
CachedNetworkImage
JsonSerializable


## Project Structure

lib/
├── config/
├── core/

│   └── api/
    ├── models/
│   └── providers/

├── features/

│   └── details/
│   └── home/
│   └── splash/

└── utils/

## Features

Splash screen with app logo
Home screen with search functionality and a list of cat breeds
Each card displays:

Breed name (top-left)
Country of origin (bottom-left)
Intelligence level (bottom-right)
"More..." button (top-right) leading to the details screen
Details screen with breed image and detailed description

## Architecture

The application follows the MVVM architecture:

Model: Represents the data structures (e.g., Breed model)
View: UI components displaying data and handling user interactions
ViewModel: Manages the logic and state, interacting with services and repositories

The SOLID principles are applied to ensure a clean and maintainable codebase.
