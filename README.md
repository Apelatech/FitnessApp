# ApelaTech Fitness

**Smarter Fitness. Powered by AI.**

A comprehensive Flutter mobile application for AI-powered fitness coaching, featuring personalized workout plans, nutrition tracking, and virtual trainer interaction.

## 🚀 Features

### 🏠 **Homepage**
- Modern hero section with motivational messaging
- Quick action cards for immediate access to key features
- Daily stats overview and progress tracking
- Feature highlights with gradient cards

### 🤖 **AI FitBot Coach**
- Real-time ChatGPT-powered fitness coaching
- Interactive chat interface with quick replies
- Personalized workout and nutrition recommendations
- Form checking and motivation support
- Camera integration for meal and exercise logging

### 🏋️ **Workout & Training Plans**
- Goal-based workout categorization (Fat Loss, Muscle Gain, Strength, etc.)
- Featured workouts with detailed exercise breakdowns
- Custom routine creation and scheduling
- Progress tracking with visual analytics
- Quick start options for immediate workouts

### 🍎 **Meal Planning & Nutrition**
- AI-assisted macro calculations and meal suggestions
- Visual nutrition breakdown with charts
- Barcode and camera scanning for food logging
- Daily calorie and macro tracking
- Quick-add options for common foods

### 📊 **Progress Analytics Dashboard**
- Comprehensive fitness metrics visualization
- Weekly and monthly progress charts
- Achievement system with unlockable badges
- Workout frequency and intensity tracking
- Body composition and goal comparison

### 👨‍💼 **Trainer Portal Features**
- In-app trainer-client communication
- Custom plan creation and assignment
- Progress monitoring and feedback
- Video upload and exercise demonstration

## 🎨 Design System

### Color Palette
- **Primary**: Jet Black (#1C2526)
- **Secondary**: Sky Blue (#4A90E2)
- **Accent**: Fire Orange (#FF5733)
- **Success**: #43A047
- **Warning**: #FB8C00
- **Error**: #E53935

### Typography
- **Primary Font**: Manrope (headings and titles)
- **Secondary Font**: Inter (body text and UI elements)

### UI Components
- Modern card-based layout
- Gradient accent elements
- Smooth animations with animate_do
- Material Design 3 principles
- Dark and light theme support

## 🛠 Tech Stack

### Frontend
- **Flutter 3.7+** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material Design 3** - UI framework

### State Management
- **Provider** - State management solution
- **Shared Preferences** - Local data persistence

### UI & Animations
- **google_fonts** - Custom typography
- **animate_do** - Smooth animations
- **flutter_staggered_animations** - List animations
- **fl_chart** - Analytics charts and graphs

### Networking & Storage
- **dio** - HTTP client for API calls
- **http** - Additional HTTP support
- **shared_preferences** - Local storage

### Media & Permissions
- **image_picker** - Camera and gallery access
- **permission_handler** - App permissions
- **flutter_local_notifications** - Push notifications

## 📱 Supported Platforms

- **Android** 5.0+ (API level 21+)
- **iOS** 12.0+

## 🏗 Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_constants.dart
│   └── theme/
│       └── app_theme.dart
├── features/
│   ├── ai_fitbot/
│   │   └── presentation/pages/
│   ├── analytics/
│   │   └── presentation/pages/
│   ├── home/
│   │   └── presentation/pages/
│   ├── nutrition/
│   │   └── presentation/pages/
│   └── workouts/
│       └── presentation/pages/
└── shared/
    ├── models/
    │   ├── chat_message.dart
    │   ├── nutrition.dart
    │   └── workout.dart
    └── widgets/
        ├── custom_button.dart
        └── custom_card.dart
```

### Architecture Principles
- **Feature-based organization** - Each feature is self-contained
- **Clean Architecture** - Separation of concerns with clear layers
- **Reusable Components** - Shared widgets and models
- **Consistent Theming** - Centralized design system

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- iOS development requires Xcode (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/apelatech/fitness-app.git
   cd fitness-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

### Building for Production

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 🔧 Configuration

### API Configuration
Update the base URL in `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://your-api-endpoint.com';
static const String chatGptApiKey = 'your_openai_api_key';
```

### Theme Customization
Modify colors and styles in:
- `lib/core/constants/app_colors.dart`
- `lib/core/theme/app_theme.dart`

## 📋 Development Guidelines

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Implement proper error handling
- Add comments for complex logic
- Use const constructors for performance

### State Management
- Use Provider for app-wide state
- Keep state minimal and focused
- Implement proper loading and error states
- Use proper lifecycle management

### UI Development
- Follow the established design system
- Use shared widgets for consistency
- Implement proper accessibility features
- Test on multiple screen sizes

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Test coverage
flutter test --coverage
```

## 📱 App Store Deployment

### Preparation Checklist
- [ ] Update app version in `pubspec.yaml`
- [ ] Configure app icons and splash screens
- [ ] Set up proper app signing
- [ ] Test on physical devices
- [ ] Prepare store listings and screenshots
- [ ] Configure analytics and crash reporting

### Store Assets Required
- App icons (multiple sizes)
- Screenshots (phones and tablets)
- Feature graphics
- App description and keywords
- Privacy policy URL

## 🔐 Security & Privacy

- No authentication required (frontend only)
- Local data storage only
- Camera permissions for meal logging
- Notification permissions for reminders
- No personal data transmitted externally

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **MightyFitness Script** - Backend architecture inspiration
- **Flutter Team** - Amazing cross-platform framework
- **Material Design** - Beautiful UI components
- **OpenAI** - AI coaching capabilities

## 📞 Support

For support and questions:
- **Email**: support@apelatech.com
- **Website**: [apelatech.com](https://apelatech.com)
- **Documentation**: [docs.apelatech.com](https://docs.apelatech.com)

---

**Made with ❤️ by the ApelaTech Team**

*Revolutionizing personal fitness with intelligent, accessible coaching.*
#   a p e l a t e c h . c o m  
 