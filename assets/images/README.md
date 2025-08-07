# ApelaTech Fitness App Icons

## Icon Requirements

For a production app, you'll need the following icon sizes:

### Android
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48px)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72px)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96px)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144px)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192px)

### iOS
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (multiple sizes from 20x20 to 1024x1024)

## Icon Design Guidelines

The app icon should reflect the ApelaTech Fitness brand:

1. **Colors**: Use the brand color palette
   - Primary: Jet Black (#1C2526)
   - Accent: Fire Orange (#FF5733)
   - Secondary: Sky Blue (#4A90E2)

2. **Design Elements**:
   - Modern, clean design
   - Fitness-related iconography (dumbbell, pulse, etc.)
   - AI/tech elements to represent the smart coaching aspect
   - Gradient effects for visual appeal

3. **Style**:
   - Rounded corners for modern look
   - High contrast for visibility
   - Scalable design that works at all sizes
   - Professional appearance suitable for app stores

## Tools for Icon Generation

Consider using these tools to generate all required sizes:
- [App Icon Generator](https://www.appicon.co/)
- [Icon Kitchen](https://icon.kitchen/)
- [Figma](https://www.figma.com/) for custom design

## Current Status

- Default Flutter icons are currently in place
- Custom icons need to be designed and implemented before production release
- Update pubspec.yaml and platform-specific files once icons are ready
