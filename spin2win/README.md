# Spin to Win

A Flutter application that allows users to create and manage spinning wheel configurations for fun decision-making games.

## Features

- **Multiple Wheel Configurations**: Create and save different wheel setups for various scenarios (food choices, activities, rewards, etc.)
- **Interactive Spinning Animation**: Realistic wheel spinning with physics-based animations
- **Celebration Effects**: Star and sparkle animations when a result is selected
- **Sequential Gameplay**: Progress through multiple wheels in a predetermined order
- **Persistent Storage**: All configurations are saved locally using SharedPreferences
- **Drag & Drop**: Reorder wheel configurations to customize the flow
- **Customizable Options**: Add, edit, and remove wheel options with different colors

## How to Use

1. **Launch the App**: Start with the home screen showing available wheel configurations
2. **Select a Wheel**: Tap on any configuration to begin spinning
3. **Spin the Wheel**: Press the "SPIN!" button to start the animation
4. **View Results**: Watch the celebration animation and see your result
5. **Continue**: Use "Next Wheel" to progress through the sequence or "Finish" to complete

### Managing Configurations

- **Add New Wheels**: Use the "+" button to create new configurations
- **Edit Wheels**: Tap the settings icon or edit existing configurations
- **Reorder**: Drag configurations to change the sequence order
- **Customize Options**: Add or remove options, change labels and colors

## Installation

1. Ensure you have Flutter installed (SDK 3.8.1 or higher)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Launch with `flutter run`

## Dependencies

- `flutter`: Flutter SDK
- `shared_preferences`: For persistent local storage

## Default Configurations

The app comes with three pre-configured wheels:
- **Food Choices**: Pizza, Burger, Sushi, Tacos, Pasta, Salad
- **Activities**: Movies, Sports, Reading, Gaming, Walking  
- **Rewards**: Ice Cream, New Book, Movie Night, Day Off
