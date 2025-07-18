# SketchChair Makefile
# Java 11 cross-platform build system

# Configuration
JAVA_VERSION = 11
SRC_DIR = src
BUILD_DIR = bin
LIB_DIR = lib
DIST_DIR = dist
MAIN_CLASS = cc.sketchchair.sketch.main
PROJECT_NAME = SketchChair
VERSION = 1.0

# Platform-specific configurations
MACOS_LIBS = libCurrent
WINDOWS_LIBS = libCurrent
LINUX_LIBS = libCurrent

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

# Create basic JAR file
.PHONY: jar
jar: compile
	@echo "Creating basic JAR file..."
	@mkdir -p $(DIST_DIR)
	@jar cf $(DIST_DIR)/$(PROJECT_NAME).jar -C $(BUILD_DIR) .
	@echo "JAR created: $(DIST_DIR)/$(PROJECT_NAME).jar"

# Create executable JAR with dependencies
.PHONY: jar-with-deps
jar-with-deps: compile
	@echo "Creating executable JAR with dependencies..."
	@mkdir -p $(DIST_DIR)/temp
	@# Extract all dependency JARs
	@for jar in $(LIB_DIR)/*.jar; do \
		if [ -f "$$jar" ]; then \
			echo "Extracting $$jar..."; \
			cd $(DIST_DIR)/temp && jar xf "../../$$jar"; \
		fi; \
	done
	@# Copy compiled classes
	@cp -r $(BUILD_DIR)/* $(DIST_DIR)/temp/
	@# Create manifest
	@echo "Main-Class: $(MAIN_CLASS)" > $(DIST_DIR)/temp/META-INF/MANIFEST.MF
	@# Create executable JAR
	@cd $(DIST_DIR)/temp && jar cfm ../$(PROJECT_NAME)-executable.jar META-INF/MANIFEST.MF .
	@rm -rf $(DIST_DIR)/temp
	@echo "Executable JAR created: $(DIST_DIR)/$(PROJECT_NAME)-executable.jar"

# Create macOS-specific JAR
.PHONY: jar-macos
jar-macos: compile
	@echo "Creating macOS JAR..."
	@mkdir -p $(DIST_DIR)/macos/temp
	@# Copy macOS-specific native libraries
	@if [ -d "$(MACOS_LIBS)" ]; then \
		find $(MACOS_LIBS) -name "*macosx*" -o -name "*darwin*" -o -name "*osx*" | \
		while read lib; do \
			echo "Including macOS library: $$lib"; \
			cp "$$lib" $(DIST_DIR)/macos/temp/ 2>/dev/null || true; \
		done; \
	fi
	@# Extract core dependencies
	@for jar in $(LIB_DIR)/*.jar; do \
		if [ -f "$$jar" ]; then \
			cd $(DIST_DIR)/macos/temp && jar xf "../../../$$jar"; \
		fi; \
	done
	@# Copy compiled classes
	@cp -r $(BUILD_DIR)/* $(DIST_DIR)/macos/temp/
	@# Create manifest with macOS-specific settings
	@echo "Main-Class: $(MAIN_CLASS)" > $(DIST_DIR)/macos/temp/META-INF/MANIFEST.MF
	@echo "Built-For: macOS" >> $(DIST_DIR)/macos/temp/META-INF/MANIFEST.MF
	@# Create macOS JAR
	@cd $(DIST_DIR)/macos/temp && jar cfm ../$(PROJECT_NAME)-macos-$(VERSION).jar META-INF/MANIFEST.MF .
	@rm -rf $(DIST_DIR)/macos/temp
	@echo "macOS JAR created: $(DIST_DIR)/macos/$(PROJECT_NAME)-macos-$(VERSION).jar"

# Create Windows-specific JAR
.PHONY: jar-windows
jar-windows: compile
	@echo "Creating Windows JAR..."
	@mkdir -p $(DIST_DIR)/windows/temp
	@# Copy Windows-specific native libraries
	@if [ -d "$(WINDOWS_LIBS)" ]; then \
		find $(WINDOWS_LIBS) -name "*windows*" -o -name "*win*" -o -name "*dll*" | \
		while read lib; do \
			echo "Including Windows library: $$lib"; \
			cp "$$lib" $(DIST_DIR)/windows/temp/ 2>/dev/null || true; \
		done; \
	fi
	@# Extract core dependencies
	@for jar in $(LIB_DIR)/*.jar; do \
		if [ -f "$$jar" ]; then \
			cd $(DIST_DIR)/windows/temp && jar xf "../../../$$jar"; \
		fi; \
	done
	@# Copy compiled classes
	@cp -r $(BUILD_DIR)/* $(DIST_DIR)/windows/temp/
	@# Create manifest with Windows-specific settings
	@echo "Main-Class: $(MAIN_CLASS)" > $(DIST_DIR)/windows/temp/META-INF/MANIFEST.MF
	@echo "Built-For: Windows" >> $(DIST_DIR)/windows/temp/META-INF/MANIFEST.MF
	@# Create Windows JAR
	@cd $(DIST_DIR)/windows/temp && jar cfm ../$(PROJECT_NAME)-windows-$(VERSION).jar META-INF/MANIFEST.MF .
	@rm -rf $(DIST_DIR)/windows/temp
	@echo "Windows JAR created: $(DIST_DIR)/windows/$(PROJECT_NAME)-windows-$(VERSION).jar"

# Create Linux-specific JAR
.PHONY: jar-linux
jar-linux: compile
	@echo "Creating Linux JAR..."
	@mkdir -p $(DIST_DIR)/linux/temp
	@# Copy Linux-specific native libraries
	@if [ -d "$(LINUX_LIBS)" ]; then \
		find $(LINUX_LIBS) -name "*linux*" -o -name "*so*" | \
		while read lib; do \
			echo "Including Linux library: $$lib"; \
			cp "$$lib" $(DIST_DIR)/linux/temp/ 2>/dev/null || true; \
		done; \
	fi
	@# Extract core dependencies
	@for jar in $(LIB_DIR)/*.jar; do \
		if [ -f "$$jar" ]; then \
			cd $(DIST_DIR)/linux/temp && jar xf "../../../$$jar"; \
		fi; \
	done
	@# Copy compiled classes
	@cp -r $(BUILD_DIR)/* $(DIST_DIR)/linux/temp/
	@# Create manifest with Linux-specific settings
	@echo "Main-Class: $(MAIN_CLASS)" > $(DIST_DIR)/linux/temp/META-INF/MANIFEST.MF
	@echo "Built-For: Linux" >> $(DIST_DIR)/linux/temp/META-INF/MANIFEST.MF
	@# Create Linux JAR
	@cd $(DIST_DIR)/linux/temp && jar cfm ../$(PROJECT_NAME)-linux-$(VERSION).jar META-INF/MANIFEST.MF .
	@rm -rf $(DIST_DIR)/linux/temp
	@echo "Linux JAR created: $(DIST_DIR)/linux/$(PROJECT_NAME)-linux-$(VERSION).jar"

# Create all platform-specific JARs
.PHONY: jar-all-platforms
jar-all-platforms: jar-macos jar-windows jar-linux
	@echo "All platform JARs created successfully!"
	@echo "macOS:   $(DIST_DIR)/macos/$(PROJECT_NAME)-macos-$(VERSION).jar"
	@echo "Windows: $(DIST_DIR)/windows/$(PROJECT_NAME)-windows-$(VERSION).jar"
	@echo "Linux:   $(DIST_DIR)/linux/$(PROJECT_NAME)-linux-$(VERSION).jar"

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
	@echo "SketchChair Cross-Platform Build System"
	@echo "Available targets:"
	@echo "  all                - Build everything (default)"
	@echo "  setup              - Set up build environment"
	@echo "  compile            - Compile Java sources"
	@echo "  clean              - Clean build artifacts"
	@echo "  jar                - Create basic JAR file"
	@echo "  jar-with-deps      - Create executable JAR with dependencies"
	@echo "  jar-macos          - Create macOS-specific JAR"
	@echo "  jar-windows        - Create Windows-specific JAR"
	@echo "  jar-linux          - Create Linux-specific JAR"
	@echo "  jar-all-platforms  - Create all platform JARs"
	@echo "  run                - Run the application"
	@echo "  test               - Test compilation"
	@echo "  help               - Show this help"

# Show build info
.PHONY: info
info:
	@echo "Build Configuration:"
	@echo "  Project Name: $(PROJECT_NAME)"
	@echo "  Version:      $(VERSION)"
	@echo "  Java Version: $(JAVA_VERSION)"
	@echo "  Source Dir:   $(SRC_DIR)"
	@echo "  Build Dir:    $(BUILD_DIR)"
	@echo "  Lib Dir:      $(LIB_DIR)"
	@echo "  Dist Dir:     $(DIST_DIR)"
	@echo "  Main Class:   $(MAIN_CLASS)"
	@echo "  Classpath:    $(CLASSPATH)"
