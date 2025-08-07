# ApelaTech Fitness - Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Context
This is a Flutter mobile application for ApelaTech Fitness, an AI-powered fitness coaching platform. The app is designed for both Android and iOS and follows clean architecture principles.

## Key Technologies
- **Frontend**: Flutter (Dart) for cross-platform mobile development
- **State Management**: Provider pattern
- **UI Framework**: Material Design 3 with custom theming
- **Charts**: FL Chart for analytics visualization
- **Animations**: animate_do package for smooth transitions
- **Architecture**: Feature-based clean architecture

## Design System
- **Primary Colors**: 
  - Jet Black (#1C2526)
  - Fire Orange (#FF5733) 
  - Sky Blue (#4A90E2)
- **Typography**: 
  - Primary: Manrope font family
  - Secondary: Inter font family
- **Theme**: Modern fitness tech aesthetic with gradient elements

## Code Style Guidelines
1. Use meaningful variable and function names
2. Follow Dart/Flutter naming conventions (camelCase for variables, PascalCase for classes)
3. Implement proper error handling with try-catch blocks
4. Use const constructors where possible for performance
5. Organize imports: Flutter SDK, third-party packages, then relative imports
6. Use meaningful commit messages and comments

## Architecture Patterns
- **Feature-based structure**: Each feature has its own folder with presentation, domain, and data layers
- **Shared components**: Common widgets and models in the shared folder
- **Core configuration**: Theme, constants, and utilities in the core folder
- **Provider pattern**: For state management across the app

## Component Guidelines
- Create reusable custom widgets in the shared/widgets folder
- Use the established color palette from app_colors.dart
- Implement proper accessibility features (semantic labels, proper contrast)
- Follow the established card and button design patterns
- Use FadeIn animations for smooth user experience

## AI Features Implementation
- AI FitBot uses simulated responses (ChatGPT integration would be added in production)
- Chat interface follows modern messaging app patterns
- Include quick reply options for better user experience
- Implement typing indicators and message status

## Data Management
- Use models with proper serialization (toJson/fromJson methods)
- Implement proper data validation
- Use SharedPreferences for local data persistence
- Follow the established model patterns in shared/models

## Testing Considerations
- Write unit tests for business logic
- Implement widget tests for UI components
- Use meaningful test descriptions
- Mock external dependencies appropriately

## Performance Guidelines
- Use ListView.builder for large lists
- Implement proper image caching and optimization
- Use const widgets where possible
- Avoid unnecessary rebuilds with proper state management

## Accessibility
- Provide semantic labels for screen readers
- Ensure proper color contrast ratios
- Implement proper focus management
- Use meaningful error messages

When suggesting code changes or new features, ensure they align with the existing architecture and design patterns established in this project.
