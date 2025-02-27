# Flutter iOS Development Commands
.PHONY: help clean clean-fast clean-pods flutter-clean build run test pod-install open-sim list-sims run-iphone15 reset clean-pods-reset deep-clean

help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean-fast: ## Quick clean without pod reinstall
	@echo "🧹 Removing build artifacts..."
	cd ios && rm -rf Pods Podfile.lock DerivedData && cd .. && \
	flutter clean && \
	rm -f ".flutter-plugins 2" ".flutter-plugins 3" ".flutter-plugins 4" ".flutter-plugins-dependencies 2" ".flutter-plugins-dependencies 3" ".flutter-plugins-dependencies 4" && \
	flutter pub get
	@echo "✅ Fast clean completed successfully!"

clean-pods: ## Clean and reinstall pods
	@echo "🧩 Cleaning pods..."
	cd ios && pod deintegrate && \
	echo "🔄 Installing pods (this may take a while)..." && \
	pod install --repo-update
	@echo "🔗 Creating symbolic links for Firebase plugins..."
	@echo "✅ Pod clean and install completed successfully!"

flutter-clean: ## Run flutter clean only
	@echo "🧹 Cleaning Flutter build artifacts..."
	flutter clean
	@echo "✅ Flutter clean completed!"

clean: ## Full clean including pods (may take a while)
	@echo "🧹 Starting complete clean process..."
	@make clean-fast
	@make clean-pods
	@echo "✅ Clean process completed successfully!"

build: ## Build the app in debug mode
	flutter build ios --debug

build-release: ## Build the app in release mode
	flutter build ios --release

run: ## Run the app in debug mode
	xcrun simctl boot "iPhone 16" && open -a Simulator && flutter run -d "iPhone 16"

run-without-sign: ## Run the app in debug mode without signing
	cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug -sdk iphonesimulator CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
	xcrun simctl install "iPhone 16" "/Users/dave/Library/Developer/Xcode/DerivedData/Runner-hfbvzbfmmnllfxbratyguinviuyb/Build/Products/Debug-iphonesimulator/Runner.app" && xcrun simctl launch "iPhone 16" "com.stoppr.app"

flutter-sim: ## Run Flutter with debug and hot reload, bypassing code signing issues
	@echo "🚀 Building app without code signing..."
	@cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug -sdk iphonesimulator CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO > /dev/null
	@echo "📱 Installing on simulator..."
	@xcrun simctl boot "iPhone 16" 2>/dev/null || true
	@xcrun simctl install "iPhone 16" "/Users/dave/Library/Developer/Xcode/DerivedData/Runner-hfbvzbfmmnllfxbratyguinviuyb/Build/Products/Debug-iphonesimulator/Runner.app" 2>/dev/null
	@xcrun simctl launch "iPhone 16" "com.stoppr.app" 2>/dev/null
	@echo "🔥 Starting Flutter in attach mode for hot reload..."
	flutter attach --device-id="iPhone 16"

flutter-sim-debug: ## Run Flutter with debug, verbose output and hot reload, bypassing code signing issues
	@echo "🔍 Building app without code signing (VERBOSE MODE)..."
	cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug -sdk iphonesimulator CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
	@echo "📱 Installing on simulator (VERBOSE MODE)..."
	xcrun simctl boot "iPhone 16" || true
	xcrun simctl install "iPhone 16" "/Users/dave/Library/Developer/Xcode/DerivedData/Runner-hfbvzbfmmnllfxbratyguinviuyb/Build/Products/Debug-iphonesimulator/Runner.app" 
	xcrun simctl launch "iPhone 16" "com.stoppr.app"
	@echo "🔥 Starting Flutter in attach mode with verbose logging for hot reload..."
	flutter attach --device-id="iPhone 16" --verbose

run-release: ## Run the app in release mode
	flutter run --release

test: ## Run all tests
	flutter test

pod-install: ## Install iOS pods
	cd ios && pod install --repo-update && cd ..
	@echo "🔗 Creating symbolic links for Firebase plugins..."

open-sim: ## Open iOS Simulator with iPhone 15 Pro
	xcrun simctl boot "iPhone 15 Pro" || true
	open -a Simulator

run-iphone15: ## Run app specifically on iPhone 15 Pro
	flutter run -d "iPhone 15 Pro"

check: ## Run Flutter doctor
	flutter doctor -v

devices: ## List all connected devices
	flutter devices

clean-xcode: ## Clean Xcode derived data
	rm -rf ~/Library/Developer/Xcode/DerivedData

setup: ## Initial setup after cloning
	cd ios && rm -rf Pods && rm -f Podfile.lock && rm -f "Podfile 2.lock" || true && cd ..
	flutter pub get
	cd ios && pod install --repo-update && cd ..
	@echo "🔗 Creating symbolic links for Firebase plugins..."

format: ## Format all Dart files
	dart format lib/

analyze: ## Analyze Dart code
	flutter analyze

watch: ## Watch for changes and rebuild
	flutter pub run build_runner watch --delete-conflicting-outputs

build-runner: ## Run build_runner once
	flutter pub run build_runner build --delete-conflicting-outputs

list-sims: ## List available iOS simulators
	xcrun simctl list devices

reset: ## Complete reset: clean Flutter, remove derived data, pods, and setup again
	xcrun simctl shutdown all && xcrun simctl erase all
	flutter clean
	rm -f ".flutter-plugins 2" ".flutter-plugins 3" ".flutter-plugins 4" ".flutter-plugins-dependencies 2" ".flutter-plugins-dependencies 3" ".flutter-plugins-dependencies 4"
	rm -rf ~/Library/Developer/Xcode/DerivedData
	cd ios && rm -rf Pods && rm -f Podfile.lock && cd ..
	flutter pub get
	cd ios && pod deintegrate && pod cache clean --all && pod install --repo-update && cd ..
	@echo "🧹 Reset complete! Project is fresh and clean."

clean-pods-reset:
	@echo "🧹 Cleaning and completely resetting all pod dependencies..."
	cd ios && \
	rm -rf Pods Podfile.lock && \
	pod deintegrate && \
	pod cache clean --all && \
	pod install --repo-update && \
	echo "Creating symbolic links for firebase_auth..." && \
	mkdir -p Pods/firebase_auth && \
	echo "Done! ✅"

deep-clean: ## Thoroughly remove ALL pod and cache files, including duplicates
	@echo "🧹 Performing deep clean of all pod files and duplicates..."
	@echo "Step 1: Shutting down simulators..."
	xcrun simctl shutdown all 2>/dev/null || true
	@echo "Step 2: Cleaning Flutter artifacts..."
	flutter clean
	@echo "Step 3: Removing duplicate plugin files..."
	rm -f ".flutter-plugins 2" ".flutter-plugins 3" ".flutter-plugins 4"
	rm -f ".flutter-plugins-dependencies 2" ".flutter-plugins-dependencies 3" ".flutter-plugins-dependencies 4"
	@echo "Step 4: Cleaning Xcode artifacts..."
	rm -rf ~/Library/Developer/Xcode/DerivedData/*Runner*
	@echo "Step 5: Cleaning CocoaPods cache..."
	rm -rf ~/Library/Caches/CocoaPods
	@echo "Step 6: Removing iOS build artifacts..."
	cd ios && \
	rm -rf Runner.xcworkspace && \
	rm -rf *.xcworkspace && \
	rm -rf Pods && \
	rm -rf "Pods 2" "Pods 3" "Pods 4" 2>/dev/null || true && \
	rm -rf Podfile.lock && \
	echo "Step 7: Running pod deintegrate..." && \
	pod deintegrate || true && \
	echo "Step 8: Cleaning pod cache..." && \
	pod cache clean --all || true && \
	cd ..
	@echo "Step 9: Getting Flutter dependencies..."
	flutter pub get
	@echo "Step 10: Reinstalling pods..."
	cd ios && pod install --repo-update
	@echo "✅ Deep clean completed successfully! All duplicates removed."