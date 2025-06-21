#  🚗 Masaar - مسار

## Simplifying Daily Commutes, Connect with Nearby Drivers for Effortless City Travel, Masaar – Your Trusted Route.

## 📑 Table of Contents
- [Purpose](#-purpose)
- [Features](#-features)
- [How to install & run Masaar](#-how-to-install--run-masaar)
- [Environment Variables & API Keys](#-environment-variables--api-keys)
- [UI/UX Design](#-uiux-design)
- [Schema](#-schema)
- [External Packages](#-external-packages)
- [Custom Widgets](#-custom-widgets)
- [Known Issues](#-known-issues-work-in-progress)
- [Contact Our Team](#-contact-our-team)

##  🎯 Purpose
Masaar (مسار) is an application made to digitize and make daily travel easier. It helps people get where they need to go quickly and safely by connecting them with nearby drivers. The goal is to provide a simple, reliable, and easy way to travel in cities.

## ✨ Features
- **🔐 User Account Management**  
  Seamlessly register and log in to create and manage your personal account, view ride history, and access saved payment methods.

- **🚕 Flexible Ride Booking**  
  Book rides instantly with no future scheduling required. Select from three tailored ride types to suit your needs: **Saver** for budget-friendly travel, **Comfort** for a more premium experience, and **Family** for spacious group trips.

- **🗺️ Live Driver & Route Tracking**  
  Stay updated with real-time GPS tracking that lets you monitor your driver's location and route throughout the journey.

- **💬 In-App Messaging with Drivers**  
  Communicate with your driver directly through a built-in chat system for a smoother, more connected experience.

- **💳 Secure Payments via Moyasar**  
  Enjoy safe and flexible payment processing through Moyasar, with support for major credit and debit cards.

- **👛 Digital Wallet & Stored Payments**  
  Add and save multiple cards for quick and convenient checkout. Refunds from canceled rides or other adjustments are automatically credited to your in-app wallet and can be applied to future trips. Manual top-ups are not required or supported.

- **⭐ Ratings & Ride Feedback**  
  Share your ride experience by rating drivers and submitting feedback, helping ensure service quality and reliability across the platform.


## 🚀 How to install & run Masaar
> ⚠️ [!IMPORTANT]\
> Before You Run the App, Make Sure You Have:
> - Flutter SDK installed (version listed in pubspec.yaml)
> - Dart SDK (comes with Flutter)
> - Android Studio
> - A connected device or emulator
> - Internet connection for fetching dependencies

1. Clone the Repository
    - git clone https://github.com/Deemabakhyer/PROJECT-1-Masaar.git
    - cd PROJECT-1-Masaar
    - code .
2. Install Dependencies
    - flutter pub get
3. Run the App
    - flutter run
4. (Optional) Build the App
    - For Android:
        - flutter build apk
    - For iOS
        - flutter build ios

## 🔑 Environment Variables & API Keys
Before running the app, you need to set up the following API keys:
- **Google Maps API Key**
- **Supabase URL & Anon Key**
- **Moyasar API Key**

Create a file named `.env` in the project root and add your keys like this:
```
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
MOYASAR_API_KEY=your_moyasar_api_key
```

> ⚠️ **Never commit your `.env` file or API keys to version control.**  
> Make sure `.env` is listed in your `.gitignore`.

Update your code to load these variables using [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) or your preferred method.

        
## 💡 Watch this tutorial on how to navigate through Masaar!
work in progres....

## 🎨 UI/UX Design
View the complete design on [Figma](https://www.figma.com/design/synPECe3VTrOajQMPtQPWh/Masaar?node-id=0-1&t=nqYHZSD7lLfXy7Ss-1).

## 🗂️ Schema
View the complete database schema on [Supabase](https://supabase.com/dashboard/project/vrsczitnkvjsterzxqpr).


## 📦 External Packages
- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter) – Map rendering and routing  
- [Geolocator](https://pub.dev/packages/geolocator) – Location tracking  
- [latlong2](https://pub.dev/packages/latlong2) – Geolocation data structures  
- [Geocoding](https://pub.dev/packages/geocoding) – Reverse geocoding and address lookup  
- [Flutter Map](https://pub.dev/packages/flutter_map) – Alternative map rendering (optional)  
- [Moyasar](https://pub.dev/packages/moyasar) – Payment gateway integration  
- [Flutter Chat UI](https://pub.dev/packages/flutter_chat_ui) – In-app chat interface  
- [Flutter Chat Core](https://pub.dev/packages/flutter_chat_core) – Core functionalities for Flutter Chat UI  
- [GetX](https://pub.dev/packages/get) – State management and routing  
- [Smooth Page Indicator](https://pub.dev/packages/smooth_page_indicator) – Page transitions  
- [Shared Preferences](https://pub.dev/packages/shared_preferences) – Local data storage  
- [Supabase Flutter](https://pub.dev/packages/supabase_flutter) – Backend services and authentication  
- [HTTP](https://pub.dev/packages/http) – Networking and API requests  
- [Dropdown Button 2](https://pub.dev/packages/dropdown_button2) – Customizable dropdown menus  
- [Ionicons](https://pub.dev/packages/ionicons) – Icon pack  
- [Cupertino Icons](https://pub.dev/packages/cupertino_icons) – iOS-style icons  
- [Permission Handler](https://pub.dev/packages/permission_handler) – Runtime permissions  
- [URL Launcher](https://pub.dev/packages/url_launcher) – Enables phone call and external URL launching  
- [Duration](https://pub.dev/packages/duration) – Human-readable duration formatting  
- [Intl](https://pub.dev/packages/intl) – Internationalization and date formatting  
- [WebView Flutter](https://pub.dev/packages/webview_flutter) – Display web content inside the app  
  

## 🧩 Custom Widgets
**Buttons**
- Primary Action Button
- Outlined Button
- Cancel Ride Button

**Cards**
- Past Ride Log Card
- Car Options Card

**Input Fields**
- Search Bar with Suggestions

**Bars**
- Bottom Navigation Bar
- App Bar

**Bottom Sheets**
- Driver Loading Indicator
- Ride Details Sheet

**Pop-ups & Dialogs**
- Cancel Ride Confirmation
- Submit Rating Dialog

## ⚙️ Known Issues (Work in Progress)
- **Driver Simulation:**  
  Currently, the application does not have real drivers. All driver profiles and interactions are simulated for demonstration purposes. We plan to develop a dedicated driver interface in the future.

- **Chat Functionality:**  
  The in-app chat feature is limited at this stage. Users can send messages, but receiving messages from drivers is not yet supported due to the lack of real driver accounts.

- **Wallet Top-Up Limitation:**  
  Users are currently unable to manually top up their in-app wallet due to limitations with the Moyasar payment gateway. Wallet balances can only be increased through refunds or ride adjustments.

We are actively working on expanding these features in the future.

## 📞 Contact Our Team
For questions, feedback, or collaboration, feel free to reach out to our team:
- 👩‍💻 [@Deemabakhyer](https://github.com/Deemabakhyer)
- 👨‍💻 [@AhmadAbdullah123](https://github.com/AhmadAbdullah123)
- 👩‍💻 [@MawadaS](https://github.com/MawadaS)
- 👩‍💻 [@RaghadAi1](https://github.com/RaghadAi1)

