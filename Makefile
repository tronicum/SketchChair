# SketchChair Makefile
# Java 11 build system

# Configuration
JAVA_VERSION = 11
SRC_DIR = src
BUILD_DIR = bin
LIB_DIR = lib
DIST_DIR = dist
MAIN_CLASS = cc.sketchchair.sketch.main

# Find all Java source files
JAVA_FILES = $(shell find $(SRC_DIR) -name "*.java")

# Classpath - include all JAR files in lib directory
CLASSPATH = $(shell find $(LIB_DIR) -name "*.jar" | tr '\n' ':' | sed 's/:$$//')

# Default target
.PHONY: all
all: compile

# Setup dependencies
.PHONY: setup
setup:
	@echo "Setting up build environment..."
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(LIB_DIR)
	@mkdir -p $(DIST_DIR)
	@if [ ! -f $(LIB_DIR)/core.jar ]; then \
		echo "Copying core.jar from libCurrent..."; \
		cp libCurrent/core.jar $(LIB_DIR)/core.jar; \
	fi
	@echo "Setup complete."

# Compile Java sources
.PHONY: compile
compile: setup
	@echo "Compiling Java sources..."
	@javac --release $(JAVA_VERSION) \
		-cp "$(CLASSPATH)" \
		-d $(BUILD_DIR) \
		$(JAVA_FILES)
	@echo "Compilation complete."

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(DIST_DIR)
	@echo "Clean complete."

# Create JAR file
.PHONY: jar
jar: compile
	@echo "Creating JAR file..."
	@mkdir -p $(DIST_DIR)
	@jar cf $(DIST_DIR)/SketchChair.jar -C $(BUILD_DIR) .
	@echo "JAR created: $(DIST_DIR)/SketchChair.jar"

# Run the application (if main class exists)
.PHONY: run
run: compile
	@echo "Running SketchChair..."
	@java -cp "$(BUILD_DIR):$(CLASSPATH)" $(MAIN_CLASS)

# Test compilation only
.PHONY: test
test: compile
	@echo "Build test completed successfully."

# Show help
.PHONY: help
help:
	@echo "SketchChair Build System"
	@echo "Available targets:"
	@echo "  all      - Build everything (default)"
	@echo "  setup    - Set up build environment"
	@echo "  compile  - Compile Java sources"
	@echo "  clean    - Clean build artifacts"
	@echo "  jar      - Create JAR file"
	@echo "  run      - Run the application"
	@echo "  test     - Test compilation"
	@echo "  help     - Show this help"

# Show build info
.PHONY: info
info:
	@echo "Build Configuration:"
	@echo "  Java Version: $(JAVA_VERSION)"
	@echo "  Source Dir:   $(SRC_DIR)"
	@echo "  Build Dir:    $(BUILD_DIR)"
	@echo "  Lib Dir:      $(LIB_DIR)"
	@echo "  Dist Dir:     $(DIST_DIR)"
	@echo "  Main Class:   $(MAIN_CLASS)"
	@echo "  Classpath:    $(CLASSPATH)"
