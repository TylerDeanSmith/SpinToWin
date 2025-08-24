# Sound Assets for Spin to Win

This folder contains sound effects for the spinning wheel game.

## Required Files

Replace the placeholder files with actual audio files:

### tick.mp3
- **Purpose**: Plays each time a segment passes under the arrow while spinning
- **Duration**: 0.1-0.2 seconds (very short)
- **Sound**: Mechanical tick, click, or tap sound
- **Format**: MP3 (recommended) or WAV
- **Volume**: Should be subtle, not overwhelming

### celebration.mp3
- **Purpose**: Plays when the wheel stops and the winner is revealed
- **Duration**: 2-3 seconds
- **Sound**: Fanfare, "da daa" victory sound, or celebration tune
- **Format**: MP3 (recommended) or WAV
- **Volume**: Should be prominent and exciting

## Usage

The sound effects are automatically triggered by the spinning wheel:
- **Tick sounds**: Play during wheel rotation as segments cross the pointer
- **Celebration sound**: Plays when the wheel stops before showing the winner popup

## Fallback Behavior

If sound files are missing or cannot be loaded, the app will continue to work normally without audio. Error messages will only appear in debug mode.

## Customization

To change the sound files:
1. Replace the files in this folder with your desired audio files
2. Keep the same filenames (tick.mp3 and celebration.mp3)
3. Run `flutter pub get` if you haven't already
4. Hot reload or restart the app

For different audio formats, update the file extensions in:
- `lib/widgets/spinning_wheel.dart`
- Lines with `AssetSource('sounds/tick.mp3')` and `AssetSource('sounds/celebration.mp3')`