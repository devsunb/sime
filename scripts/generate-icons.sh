#!/bin/bash
#
# Sime 메뉴바 아이콘 생성 스크립트
# 시스템 한국어 입력기와 동일한 형식: 16×16 + 32×32 멀티 해상도 TIFF
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RESOURCES_DIR="$PROJECT_DIR/Sime"

TEXT="선"
FONT="AppleSDGothicNeo-SemiBold"

echo "=== Sime 메뉴바 아이콘 생성 ==="

ICON_TIFF="$RESOURCES_DIR/icon.tiff"
TEMP_DIR=$(mktemp -d)

# SVG → PNG 변환 함수
svg_to_png() {
  local svg_file="$1"
  local png_file="$2"
  local size="$3"
  local dpi="$4"

  if command -v rsvg-convert &>/dev/null; then
    rsvg-convert -w "$size" -h "$size" -d "$dpi" -p "$dpi" -o "$png_file" "$svg_file"
  elif command -v cairosvg &>/dev/null; then
    cairosvg "$svg_file" -o "$png_file" -W "$size" -H "$size" --dpi "$dpi"
  else
    echo "  ⚠️  변환 도구 없음 (brew install librsvg 권장)"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
}

# 16x16 (1x @ 72 DPI) 생성
echo "  → 16×16 @ 72 DPI"
TEMP_16="$TEMP_DIR/icon_16.png"
cat > "$TEMP_DIR/icon_16.svg" <<SVGEOF
<?xml version="1.0" encoding="UTF-8"?>
<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <text x="8" y="12.5" font-family="$FONT, Apple SD Gothic Neo, sans-serif" font-size="13" font-weight="600" text-anchor="middle" fill="black">$TEXT</text>
</svg>
SVGEOF
svg_to_png "$TEMP_DIR/icon_16.svg" "$TEMP_16" 16 72

# 32x32 (2x @ 144 DPI) 생성
echo "  → 32×32 @ 144 DPI (Retina)"
TEMP_32="$TEMP_DIR/icon_32.png"
cat > "$TEMP_DIR/icon_32.svg" <<SVGEOF
<?xml version="1.0" encoding="UTF-8"?>
<svg width="32" height="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
  <text x="16" y="25" font-family="$FONT, Apple SD Gothic Neo, sans-serif" font-size="26" font-weight="600" text-anchor="middle" fill="black">$TEXT</text>
</svg>
SVGEOF
svg_to_png "$TEMP_DIR/icon_32.svg" "$TEMP_32" 32 144

# 개별 TIFF로 변환 후 DPI 설정
TEMP_TIFF_16="$TEMP_DIR/icon_16.tiff"
TEMP_TIFF_32="$TEMP_DIR/icon_32.tiff"

sips -s format tiff -s dpiWidth 72 -s dpiHeight 72 "$TEMP_16" --out "$TEMP_TIFF_16" >/dev/null 2>&1
sips -s format tiff -s dpiWidth 144 -s dpiHeight 144 "$TEMP_32" --out "$TEMP_TIFF_32" >/dev/null 2>&1

# 멀티 해상도 TIFF 생성
echo "  → 멀티 해상도 TIFF 병합"
tiffutil -cat "$TEMP_TIFF_16" "$TEMP_TIFF_32" -out "$ICON_TIFF"

# 정리
rm -rf "$TEMP_DIR"

echo ""
echo "✅ 완료: $ICON_TIFF"
tiffutil -info "$ICON_TIFF" 2>/dev/null | grep -E "Width|Resolution:"
