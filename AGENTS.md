# Repository Guidelines

## Project Structure & Module Organization

HSTracker is a macOS Swift app built from `HSTracker.xcodeproj`. App source lives in `HSTracker/`, organized by feature and integration area: `Core/`, `Logging/`, `Hearthstone/`, `Database/`, `Network/`, `HSReplay/`, `UIs/`, and related modules. Assets, nibs, resources, and localized strings are under `HSTracker/Assets`, `HSTracker/Resources`, and `*.lproj` directories. Unit tests live in `HSTrackerTests/`. Release and automation scripts are in `fastlane/` and `scripts/`; translations are in `Translations/`.

## Build, Test, and Development Commands

- `brew install swiftlint`: installs the required linter.
- `bundle install`: installs Ruby tooling used by Fastlane.
- `bash scripts/bootstrap.sh`: downloads card data needed by the project.
- `open HSTracker.xcodeproj`: opens the app in Xcode for local builds and debugging.
- `xcodebuild -project HSTracker.xcodeproj -scheme HSTracker -destination 'platform=macOS' build`: builds the app from the command line.
- `xcodebuild -project HSTracker.xcodeproj -scheme HSTrackerTests -destination 'platform=macOS' test`: runs the unit test scheme.
- `bundle exec fastlane ci`: runs the CI lane, including dependency setup and tests.

## Coding Style & Naming Conventions

Use Swift conventions: 4-space indentation, `UpperCamelCase` for types, and `lowerCamelCase` for methods, properties, and local variables. Keep new code in the closest existing module rather than adding broad utility files. Run SwiftLint before submitting; `.swiftlint.yml` excludes generated, legacy, and test paths and disables several length-related rules, so still keep new code readable and focused.

## Testing Guidelines

Tests use XCTest and live in `HSTrackerTests/`. Add or update tests for parser, database, logging, stats, and replay changes where behavior can be isolated. Name test methods with the `test...` prefix, keep fixtures small, and run the `HSTrackerTests` scheme before opening a pull request.

## Commit & Pull Request Guidelines

Follow the existing history: concise subjects such as `fix: cultivating sprite card mark`, `feat: add Forge Of Souls Deck Highlight`, or release commits like `Version 3.5.12`. Keep one logical change per commit and ensure each commit can pass tests. PRs should be rebased on current `master`, describe the user-visible change, link related issues, include screenshots for UI or overlay changes, and confirm the CLA requirement from `CONTRIBUTING.md`.

## Security & Configuration Tips

HSTracker must be code signed to function locally. You may adjust `Config.xcconfig` for local signing, but do not submit those changes. Release credentials such as `HOCKEY_API_TOKEN` and `HSTRACKER_GITHUB_TOKEN` belong in the environment, never in commits.
