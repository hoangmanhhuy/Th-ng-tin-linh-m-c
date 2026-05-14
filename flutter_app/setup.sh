#!/bin/bash
# Script khởi tạo Flutter project Digital Ecclesia
# Chạy: chmod +x setup.sh && ./setup.sh

set -e

echo "=== Khởi tạo Flutter project Digital Ecclesia ==="

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_NAME="thong_tin_linh_muc"
TEMP_DIR="$PARENT_DIR/${PROJECT_NAME}_temp"

echo "1. Tạo Flutter project mới..."
flutter create --org com.digitalecclesia --project-name "$PROJECT_NAME" "$TEMP_DIR"

echo "2. Sao chép lib/ và pubspec.yaml từ source code..."
cp -r "$SCRIPT_DIR/lib/" "$TEMP_DIR/lib/"
cp "$SCRIPT_DIR/pubspec.yaml" "$TEMP_DIR/pubspec.yaml"

echo "3. Cài đặt dependencies..."
cd "$TEMP_DIR"
flutter pub get

echo "4. Chạy thử ứng dụng..."
echo ""
echo "=== Hoàn tất! ==="
echo ""
echo "Để chạy app:"
echo "  cd $TEMP_DIR"
echo "  flutter run"
echo ""
echo "Hoặc mở Android Studio / VS Code tại: $TEMP_DIR"
