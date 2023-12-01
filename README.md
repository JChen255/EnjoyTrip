# EnjoyTrip

## Introduction
**EnjoyTrip** is an innovative trip planning app designed for iOS, utilizing the power of Swift and SwiftUI. This app showcases modern iOS development techniques including MVVM architecture, Environment Objects, UserDefaults for data persistence, and multithreading to ensure a responsive user experience🛤️.

## Technical Stack
- **Swift & SwiftUI**: Core technologies for iOS app development.
- **MVVM Architecture**: Model-View-ViewModel pattern for maintainable and scalable code.
- **Environment Object**: Used for sharing data throughout the app.
- **UserDefaults**: For storing user preferences and settings.
- **Multithreading**: To enhance performance and maintain a smooth UI.
- **Firebase**: Backend services for authentication, database, and storage.

## App Preview

### Login & Registration
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/13836982-69e3-4490-8cc0-7e51efd4d9ce" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/2a5b799f-04ef-46b2-9429-8ffc976bb3fd" width="200" >

### Home
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/1d5c1cf3-625b-4aeb-a699-502c77b34c4a" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/a954f085-a270-48dd-be77-008c0d55b6bb" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/6d2a6ae7-202c-475d-96f4-7b4f9ac8dd69" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/f99f7828-a138-4361-b152-06c0a1ece3f0" width="200" >

### Destination Detail
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/1cab46e3-f27e-4e7b-b088-32be2be40f1d" width="200" >

### Comments
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/f0371f13-a1f4-4599-bd04-670873f10736" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/da5c007c-89b6-4b0b-8fc9-4cc5dda937af" width="200" >

### Create Trip Plans
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/b2a2d022-3c2e-460b-b8e1-97c7edbf778e" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/a9a06123-5379-4979-9e66-65c876436202" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/a6424503-a865-432f-a1da-8434b91c9be1" width="200" >
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/6c74baff-a095-48d2-ad9d-405d11e883bd" width="200" >

### Setting
<img src="https://github.com/JChen255/EnjoyTrip/assets/98052549/7e35096e-820c-41e3-a768-ffc59379840e" width="200" >

## Features

### Account and Authentication
- **First-time Launch**: Account creation or login required.
- **Auto-login**: Direct navigation to the home screen on subsequent launches.

### App Structure
- **Tab Layout**: Home, Trips, Profile, Settings.

### Login/Registration
- **Login Functionality**: Using email and password.
- **Registration**: Mandatory fields include email, password, display name, and location.

### Home View
- **Destination Listings**: Displayed with essential details.
- **Search and Filter Capabilities**: Enhanced by MVVM and multithreading.
- **Sorting Functionality**: Customizable sorting options.

### Destination Detail View
- **Detailed Information**: Full details of the destination.
- **Activity Suggestions & Reviews**: Interactive sections with multithreading for smooth performance.

### Trip Planning
- **Trip Management**: Creation and customization of trips.
- **Dynamic Updates**: Leveraging Environment Objects and MVVM.
- **Cost Calculation**: Utilizes UserDefaults for saving user preferences.

### Profile
- **Customization**: Profile image upload and display name editing.
- **Review Management**: Users can interact with their reviews.
- **Account Management**: Including account deletion.

### Settings
- **Currency Settings**: UserDefaults for saving user's choice.
- **App Feedback**: Integrated feedback system.
- **Logout Feature**: Securely ends the user session.

## Development Notes
- **MVVM**: Utilized for data handling and business logic.
- **Environment Objects**: For global state management.
- **UserDefaults**: For storing simple user preferences.
- **Multithreading**: Ensures the UI is responsive while performing background tasks.

## Firebase Schemas
- **User**: Holds information like display name, email, password, lists of reviews, trips, saves, currency, and profile.
- **Profile**: Details like full name, location, join date, photo, about you, and uploaded photos.
- **Destination**: Contains attributes like name, owner, location, description, review list, price, languages, age recommendation, and recommendations.
- **Review**: Linked to destinations, includes rating, title, description, and timestamp.
- **Trip**: Consists of destination list, collaborators, duration, title, description, and privacy setting.
- **Feedback**: Captures user feedback with rating, description, and timestamp.

## Getting Started
- **Installation**: Clone the repo and install necessary dependencies.
- **Run**: Open the project in Xcode and run it on a simulator or a real device.
