# news-app

📦 Setup Instructions

Clone the repository
git clone  https://github.com/Ashutosh-Dhodad/news-app.git
cd news-app

Install dependencies
flutter pub get

Run the app
flutter run

🖼️ Screenshots of the App
news_app/
├── README.md
├── screenshots/

🧱 Architecture Explanation
The app follows a simple MVVM (Model-View-ViewModel) architecture pattern:

Model: News article model that holds data from the API.

View: UI screens like Home, News Details, and Categories.

ViewModel: Handles the logic of fetching data and updating the UI.

Why MVVM?
Keeps UI and business logic separate.

Simplifies testing and maintenance.

Makes it easier to scale and add new features.

State management is handled using Provider, keeping the app reactive and clean.

🧩 Third-Party Packages and Why
Package	Purpose
http	To fetch news articles from the REST API.
provider	For state management between UI and business logic.
cached_network_image	Efficiently loads and caches article images.
fluttertoast	To show quick feedback to users (e.g., error messages).
intl	For formatting dates in articles.
url_launcher	Allows opening the full news article in the device browser.

