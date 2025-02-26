# Flutter iOS Development Commands
.PHONY: help clean build run test pod-install open-sim list-sims run-iphone15 reset

help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Clean the project
	cd ios && rm -rf Pods Podfile.lock
	pod install --repo-update
	cd ..
	flutter clean
	flutter pub get


build: ## Build the app in debug mode
	flutter build ios --debug

build-release: ## Build the app in release mode
	flutter build ios --release

run: ## Run the app in debug mode
	flutter run

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

run-release: ## Run the app in release mode
	flutter run --release

test: ## Run all tests
	flutter test

pod-install: ## Install iOS pods
	cd ios && pod install && cd ..

open-sim: ## Open iOS Simulator with iPhone 15 Pro
	xcrun simctl boot "iPhone 15 Pro" || true
	open -a Simulator

run-iphone15: ## Run app specifically on iPhone 15 Pro
	flutter run -d "iPhone 15 Pro"

check: ## Run Flutter doctor
	flutter doctor -v

devices: ## List all connected devices
	flutter devices

clean-pods: ## Clean and reinstall pods
	cd ios && rm -rf Pods && rm -f Podfile.lock && pod install && cd ..

clean-xcode: ## Clean Xcode derived data
	rm -rf ~/Library/Developer/Xcode/DerivedData

setup: ## Initial setup after cloning
	flutter pub get
	cd ios && pod install && cd ..

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
	rm -rf ~/Library/Developer/Xcode/DerivedData
	cd ios && rm -rf Pods && rm -f Podfile.lock && cd ..
	flutter pub get
	cd ios && pod install && cd ..
	@echo "🧹 Reset complete! Project is fresh and clean." 