# SketchChair Build System

This document describes the modern Java 11 cross-platform build system for SketchChair.

## Requirements

- **Java 11 or higher** (Microsoft OpenJDK 11 recommended)
- **Make** (available on Unix-like systems, including macOS and Linux)
- **Git** (for version control)

## Quick Start

### 1. Install Microsoft OpenJDK 11

Download and install Microsoft OpenJDK 11 from:
- **macOS**: `brew install --cask microsoft-openjdk11`
- **Windows**: Download from [Microsoft OpenJDK](https://docs.microsoft.com/en-us/java/openjdk/download)
- **Linux**: Use your distribution's package manager or download from Microsoft

### 2. Build the Project

Using the convenient build script:
```bash
# Setup and detect Microsoft JDK
./build.sh setup

# Build for your current platform
./build.sh build macos     # For macOS
./build.sh build windows   # For Windows
./build.sh build linux     # For Linux
./build.sh build all       # For all platforms
```

Or using Make directly:
```bash
# Basic compilation
make compile

# Create platform-specific JARs
make jar-macos
make jar-windows
make jar-linux
make jar-all-platforms

# Create executable JAR with all dependencies
make jar-with-deps
```

## Available Build Targets

### Core Targets
- `make compile` - Compile Java sources
- `make clean` - Remove all build artifacts
- `make test` - Test compilation
- `make info` - Show build configuration

### JAR Creation
- `make jar` - Create basic JAR file
- `make jar-with-deps` - Create executable JAR with all dependencies
- `make jar-macos` - Create macOS-specific JAR with native libraries
- `make jar-windows` - Create Windows-specific JAR with native libraries
- `make jar-linux` - Create Linux-specific JAR with native libraries
- `make jar-all-platforms` - Create all platform-specific JARs

### Utility Targets
- `make run` - Run the application (if main class is available)
- `make help` - Show all available targets

## Build Script Commands

The `build.sh` script provides a convenient wrapper around Make:

```bash
./build.sh setup          # Detect and configure Microsoft JDK
./build.sh info            # Show Java environment and build info
./build.sh clean           # Clean build artifacts
./build.sh compile         # Compile Java sources
./build.sh build [platform] # Build JAR for platform
./build.sh test            # Test compilation
./build.sh run             # Run the application
./build.sh help            # Show help
```

## Output Structure

After building, you'll find:

```
dist/
├── SketchChair.jar                    # Basic JAR
├── SketchChair-executable.jar         # Executable JAR with dependencies
├── macos/
│   └── SketchChair-macos-1.0.jar     # macOS-specific JAR
├── windows/
│   └── SketchChair-windows-1.0.jar   # Windows-specific JAR
└── linux/
    └── SketchChair-linux-1.0.jar     # Linux-specific JAR
```

## Running the Application

### Platform-Specific JARs
```bash
# macOS
java -jar dist/macos/SketchChair-macos-1.0.jar

# Windows
java -jar dist/windows/SketchChair-windows-1.0.jar

# Linux
java -jar dist/linux/SketchChair-linux-1.0.jar
```

### Universal Executable JAR
```bash
java -jar dist/SketchChair-executable.jar
```

## GitHub Actions CI/CD

The project includes automated builds for all platforms using GitHub Actions:

- **Triggers**: Push to `master`, `develop`, `upgrade-merge` branches, or pull requests
- **Platforms**: Ubuntu (Linux), Windows, macOS
- **JDK**: Microsoft OpenJDK 11
- **Artifacts**: Platform-specific JARs uploaded as workflow artifacts
- **Releases**: Automatic attachment of JARs to GitHub releases

## Development Workflow

1. **Setup environment**:
   ```bash
   ./build.sh setup
   ```

2. **Make changes** to source code in `src/`

3. **Test compilation**:
   ```bash
   ./build.sh test
   ```

4. **Build for testing**:
   ```bash
   ./build.sh build macos  # or your platform
   ```

5. **Run application**:
   ```bash
   ./build.sh run
   ```

6. **Clean when needed**:
   ```bash
   ./build.sh clean
   ```

## Troubleshooting

### Java Version Issues
If you get Java version errors:
```bash
# Check current Java version
java -version

# Set JAVA_HOME manually (macOS example)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
```

### Build Failures
1. Ensure Java 11+ is installed and configured
2. Run `make clean` to remove stale artifacts
3. Check that all dependencies are in the `lib/` directory
4. Verify that `core.jar` exists (should be copied from `libCurrent/`)

### Platform-Specific Issues
- **macOS**: Ensure Xcode command line tools are installed
- **Windows**: Use Git Bash or WSL for the build script
- **Linux**: Install `build-essential` package for Make

## Legacy Build System

The original Ant-based build system is still available in `build.xml`, but the Make-based system is recommended for new development. The Make system provides:

- Better cross-platform support
- Simpler configuration
- Modern Java 11 compatibility
- Automatic dependency management
- Platform-specific JAR creation

## Java 11 Upgrade Notes

This build system includes fixes for Java 11 compatibility:
- Replaced deprecated `com.sun.image.codec.jpeg` with `ImageIO`
- Removed problematic JAXB imports
- Updated build configuration to use `--release 11` flag
- Added proper classpath management for all dependencies
