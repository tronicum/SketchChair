#!/bin/bash
# SketchChair Build Script for Microsoft OpenJDK 11
# This script helps set up the environment for building with Microsoft JDK

set -e

echo "SketchChair Cross-Platform Build Script"
echo "========================================"

# Function to detect Microsoft JDK
detect_microsoft_jdk() {
    echo "Detecting Microsoft OpenJDK 11..."
    
    # Common Microsoft JDK installation paths
    POSSIBLE_PATHS=(
        "/Library/Java/JavaVirtualMachines/microsoft-11.jdk/Contents/Home"
        "/usr/lib/jvm/msopenjdk-11"
        "/opt/microsoft/jdk-11"
        "$(which java | sed 's|/bin/java||')"
    )
    
    for path in "${POSSIBLE_PATHS[@]}"; do
        if [ -d "$path" ] && [ -f "$path/bin/javac" ]; then
            JAVA_VERSION=$("$path/bin/java" -version 2>&1 | head -n 1)
            if [[ "$JAVA_VERSION" == *"Microsoft"* ]] || [[ "$JAVA_VERSION" == *"11."* ]]; then
                echo "Found Microsoft JDK at: $path"
                export JAVA_HOME="$path"
                export PATH="$JAVA_HOME/bin:$PATH"
                return 0
            fi
        fi
    done
    
    echo "Microsoft OpenJDK 11 not found in common locations."
    echo "Please set JAVA_HOME manually or install Microsoft OpenJDK 11."
    return 1
}

# Function to show current Java environment
show_java_info() {
    echo ""
    echo "Current Java Environment:"
    echo "JAVA_HOME: ${JAVA_HOME:-'Not set'}"
    echo "Java version:"
    java -version 2>&1 | head -n 3
    echo ""
}

# Function to build for specific platform
build_platform() {
    local platform=$1
    echo "Building for $platform..."
    case "$platform" in
        "macos"|"mac")
            make jar-macos
            ;;
        "windows"|"win")
            make jar-windows
            ;;
        "linux")
            make jar-linux
            ;;
        "all")
            make jar-all-platforms
            ;;
        *)
            echo "Unknown platform: $platform"
            echo "Available platforms: macos, windows, linux, all"
            return 1
            ;;
    esac
}

# Main script logic
main() {
    case "${1:-''}" in
        "setup")
            detect_microsoft_jdk
            show_java_info
            ;;
        "info")
            show_java_info
            make info
            ;;
        "clean")
            make clean
            ;;
        "compile")
            make compile
            ;;
        "build")
            platform="${2:-all}"
            build_platform "$platform"
            ;;
        "test")
            make test
            ;;
        "run")
            make run
            ;;
        "help"|"")
            echo ""
            echo "Usage: $0 [command] [options]"
            echo ""
            echo "Commands:"
            echo "  setup          - Detect and configure Microsoft JDK"
            echo "  info           - Show Java environment and build info"
            echo "  clean          - Clean build artifacts"
            echo "  compile        - Compile Java sources"
            echo "  build [platform] - Build JAR for platform (macos|windows|linux|all)"
            echo "  test           - Test compilation"
            echo "  run            - Run the application"
            echo "  help           - Show this help"
            echo ""
            echo "Examples:"
            echo "  $0 setup                 # Configure environment"
            echo "  $0 build macos           # Build for macOS"
            echo "  $0 build all             # Build for all platforms"
            echo ""
            ;;
        *)
            echo "Unknown command: $1"
            echo "Run '$0 help' for usage information."
            return 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
