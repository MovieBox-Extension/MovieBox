# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MovieBox (무비박스) is an iOS app for recording memorable movies with personal comments and saving them as movie cards. The app is built with SwiftUI and follows Clean Architecture principles with MVVM pattern.

**Published App**: Available on the [App Store](https://apps.apple.com/kr/app/%EB%AC%B4%EB%B9%84%EB%B0%95%EC%8A%A4/id6711330901)

## Architecture

### Clean Architecture Layers

The codebase is organized into three main architectural layers:

1. **Presentation Layer** (`Sources/Presentation/`)
   - SwiftUI views and ViewModels
   - ViewModels follow Input-Output pattern using Combine
   - All ViewModels conform to `ViewModel` protocol with `Input`, `Output`, and `transform()` method
   - Screens: MovieListScreen, MovieContentScreen, MovieBoxScreen, SettingScreen

2. **Domain Layer** (`Sources/Domain/`)
   - Business entities (pure Swift models)
   - Use cases (business logic)
   - Repository interfaces
   - Independent of frameworks and external APIs

3. **Data Layer** (`Sources/Data/`)
   - Repository implementations
   - Data sources (External APIs and Local storage)
   - DTOs and data mapping
   - Network layer using Moya

### Key Patterns

**Dependency Injection**: Uses Swinject container (`Sources/Utils/DI/DIContainer.swift`)
- Register dependencies with `.inObjectScope(.container)` for singleton-like behavior
- Use `@Injected` property wrapper to inject dependencies into ViewModels
- Container registers: DataSources → Repositories → UseCases

**ViewModel Input-Output Pattern**:
```swift
final class ExampleViewModel: ViewModel {
    var input = Input()
    @Published var output = Output()

    func transform() {
        // Transform inputs to outputs using Combine
    }
}
```

**Data Flow**: View → ViewModel (Input) → UseCase → Repository → DataSource → External API/Local DB

## Environment Configuration

The project uses `.xcconfig` files for environment variables:

- `env-dev.xcconfig` - Debug configuration
- `env-release.xcconfig` - Release configuration
- `env-example.xcconfig` - Template file

Required environment variables in `.xcconfig` files:
- `KOBIS_KEY` - Korean Box Office Information System API key
- `TMDB_KEY` - The Movie Database API key (Bearer token format)
- `TMDB_IMAGE_REQ_BASE_URL` - Base URL for TMDB image requests

These values are accessed in code via `Info.plist` through the `API` enum in `Sources/Constant.swift`.

## External APIs

1. **TMDB (The Movie Database)** - `TMDBRequest.swift`
   - Weekly trending movies
   - Movie search with pagination
   - Movie details, credits, videos, images
   - Similar and recommended movies
   - Base URL: `https://api.themoviedb.org/3`
   - Language: `ko-KR`

2. **KOBIS (Korean Box Office Information System)** - `KobisRequest.swift`
   - Daily box office data
   - Base URL: `https://kobis.or.kr/kobisopenapi/webservice/rest`

## Local Storage

- **Realm**: Movie card persistence (`MovieCardDTO`)
- **Custom Image Cache**: Two-tier caching system
  - Memory cache (LRU)
  - Disk cache (file-based storage)
  - Managed by `ImageCacheManager` singleton

## Build and Run

### Building the Project

```bash
# Open project in Xcode
open MovieBox/MovieBox.xcodeproj

# Build from command line (Debug)
xcodebuild -project MovieBox/MovieBox.xcodeproj -scheme MovieBox -configuration Debug build

# Build from command line (Release)
xcodebuild -project MovieBox/MovieBox.xcodeproj -scheme MovieBox -configuration Release build
```

### Running

- The project uses Swift Package Manager for dependencies (no Podfile)
- Dependencies are resolved automatically by Xcode
- Main target: `MovieBox`
- Schemes: `MovieBox` (main), `Alamofire`, `SkeletonUI` and other package schemes

### Before First Build

1. Copy `MovieBox/MovieBox/env-example.xcconfig` to create:
   - `MovieBox/MovieBox/env-dev.xcconfig`
   - `MovieBox/MovieBox/env-release.xcconfig`

2. Fill in the required API keys in both files

## Key Dependencies

- **Swinject** (2.10.0) - Dependency injection
- **Alamofire** (5.10.2) - HTTP networking (used via Moya)
- **Moya** - Network abstraction layer
- **Realm** (20.0.0) - Local database
- **Cosmos** (25.0.1) - Star rating view
- **YouTubePlayerKit** (1.9.0) - YouTube video playback
- **SkeletonUI** (2.0.2) - Loading skeletons
- **ShuffleIt** (2.1.3) - Card shuffle animations
- **Combine** - Reactive programming (Apple framework)

## Code Organization

```
Sources/
├── App/                    # App entry point (MovieBoxApp.swift)
├── Constant.swift         # API keys and constants
├── Data/
│   ├── DataMapping/       # DTOs and mappers
│   ├── DataSources/       # External (API) and Local (Realm) data sources
│   ├── Network/           # Moya target types (TMDBRequest, KobisRequest)
│   └── Repository/        # Repository implementations
├── Domain/
│   ├── Entities/          # Business models
│   ├── Interfaces/        # Repository protocols
│   ├── Mapper/            # Entity mapping
│   └── UseCases/          # Business logic
├── Presentation/
│   ├── Components/        # Reusable UI components
│   ├── Protocol/          # ViewModel protocol
│   └── Screens/           # Feature screens
└── Utils/
    ├── DI/                # Dependency injection container
    ├── ImageCache/        # Image caching system
    └── Managers/          # Utility managers
```

## Adding New Features

When adding a new feature that fetches data:

1. **Define Entity** in `Domain/Entities/` (pure business model)
2. **Create DTO** in `Data/DataMapping/DTOs/` (API response model)
3. **Add Network Request** in `Data/Network/` (add case to existing or new Request enum)
4. **Create DataSource** in `Data/DataSources/External/` (protocol + implementation)
5. **Create Repository** in `Data/Repository/` (implement interface from Domain)
6. **Create UseCase** in `Domain/UseCases/` (business logic)
7. **Register in DI** in `Utils/DI/DIContainer.swift`
8. **Create ViewModel** in `Presentation/Screens/[Feature]/ViewModel/`
9. **Create View** in `Presentation/Screens/[Feature]/View/`

## Privacy and Data

The app does NOT collect or store personal information. All data is stored locally on the device. See privacy policy in `Sources/Constant.swift` (Literal.privacyPolicy).
