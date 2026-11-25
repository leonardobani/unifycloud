#!/usr/bin/env python3
"""
Generate all app icons and launcher logos across all platforms (Android, iOS, macOS, Windows, Linux/Flatpak, Web, Tray)
and F-Droid release metadata from the master unifycloudLogo.png in the project root.
"""

import os
import sys
from PIL import Image

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..'))
LOGO_PATH = os.path.join(PROJECT_ROOT, 'unifycloudLogo.png')

if not os.path.exists(LOGO_PATH):
    print(f"Error: Master logo not found at {LOGO_PATH}")
    sys.exit(1)

master = Image.open(LOGO_PATH).convert('RGBA')
print(f"Loaded master logo: {master.size}, {master.mode}")

BG_COLOR = (216, 187, 255, 255)

# 1. Android Mipmap Icons
android_sizes = {
    'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': (48, 48),
    'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': (72, 72),
    'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': (96, 96),
    'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': (144, 144),
    'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': (192, 192),
}

for rel_path, size in android_sizes.items():
    dest = os.path.join(PROJECT_ROOT, rel_path)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    img = master.resize(size, Image.Resampling.LANCZOS)
    img.save(dest, 'PNG', optimize=True)
    print(f"Generated Android {rel_path} -> {size}")

# 2. Fastlane & F-Droid Release Icons
fdroid_icons = [
    'fastlane/metadata/android/en-US/images/icon.png',
    'fastlane/metadata/android/it-IT/images/icon.png',
]

for rel_path in fdroid_icons:
    dest = os.path.join(PROJECT_ROOT, rel_path)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    img = master.resize((512, 512), Image.Resampling.LANCZOS)
    img.save(dest, 'PNG', optimize=True)
    print(f"Generated F-Droid/Fastlane {rel_path} -> (512, 512)")

# 3. Tray Icon & Assets
tray_dest = os.path.join(PROJECT_ROOT, 'assets/icons/tray_icon.png')
tray_img = master.resize((192, 192), Image.Resampling.LANCZOS)
tray_img.save(tray_dest, 'PNG', optimize=True)
print(f"Generated Tray Icon {tray_dest} -> (192, 192)")

asset_logo_dest = os.path.join(PROJECT_ROOT, 'assets/icons/unifycloudLogo.png')
master.save(asset_logo_dest, 'PNG', optimize=True)
print(f"Saved full logo to assets: {asset_logo_dest}")

# 4. iOS AppIcon Set
ios_sizes = {
    'Icon-App-20x20@1x.png': (20, 20),
    'Icon-App-20x20@2x.png': (40, 40),
    'Icon-App-20x20@3x.png': (60, 60),
    'Icon-App-29x29@1x.png': (29, 29),
    'Icon-App-29x29@2x.png': (58, 58),
    'Icon-App-29x29@3x.png': (87, 87),
    'Icon-App-40x40@1x.png': (40, 40),
    'Icon-App-40x40@2x.png': (80, 80),
    'Icon-App-40x40@3x.png': (120, 120),
    'Icon-App-60x60@2x.png': (120, 120),
    'Icon-App-60x60@3x.png': (180, 180),
    'Icon-App-76x76@1x.png': (76, 76),
    'Icon-App-76x76@2x.png': (152, 152),
    'Icon-App-83.5x83.5@2x.png': (167, 167),
    'Icon-App-1024x1024@1x.png': (1024, 1024),
}

ios_dir = os.path.join(PROJECT_ROOT, 'ios/Runner/Assets.xcassets/AppIcon.appiconset')
for filename, size in ios_sizes.items():
    dest = os.path.join(ios_dir, filename)
    img = master.resize(size, Image.Resampling.LANCZOS)
    img.save(dest, 'PNG', optimize=True)
    print(f"Generated iOS {filename} -> {size}")

# 5. macOS AppIcon set & Linux/Flatpak Icon
# Construct macOS 1024x1024 with squircle body and drop shadow
macos_dir = os.path.join(PROJECT_ROOT, 'macos/Runner/Assets.xcassets/AppIcon.appiconset')
old_mac_1024 = Image.open(os.path.join(macos_dir, 'app_icon_1024.png'))

body_mask = Image.new('L', (1024, 1024), 0)
shadow_img = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))

for y in range(1024):
    for x in range(1024):
        r, g, b, a = old_mac_1024.getpixel((x, y))
        if a > 0:
            if (r, g, b) == (0, 0, 0):
                shadow_img.putpixel((x, y), (0, 0, 0, a))
            else:
                body_mask.putpixel((x, y), a)

body_canvas = Image.new('RGBA', (1024, 1024), BG_COLOR)
logo_scaled = master.resize((824, 824), Image.Resampling.LANCZOS)
body_canvas.paste(logo_scaled, (100, 100))
body_canvas.putalpha(body_mask)

final_mac = Image.alpha_composite(shadow_img, body_canvas)

macos_sizes = {
    'app_icon_16.png': (16, 16),
    'app_icon_32.png': (32, 32),
    'app_icon_64.png': (64, 64),
    'app_icon_128.png': (128, 128),
    'app_icon_256.png': (256, 256),
    'app_icon_512.png': (512, 512),
    'app_icon_1024.png': (1024, 1024),
}

for filename, size in macos_sizes.items():
    dest = os.path.join(macos_dir, filename)
    img = final_mac.resize(size, Image.Resampling.LANCZOS)
    img.save(dest, 'PNG', optimize=True)
    print(f"Generated macOS {filename} -> {size}")

# Linux / Flatpak icon (256x256 squircle)
flatpak_dest = os.path.join(PROJECT_ROOT, 'packaging/flatpak/dev.leonardobani.unifycloud.png')
flatpak_img = final_mac.resize((256, 256), Image.Resampling.LANCZOS)
flatpak_img.save(flatpak_dest, 'PNG', optimize=True)
print(f"Generated Flatpak icon {flatpak_dest} -> (256, 256)")

# 6. Windows app_icon.ico
windows_ico_dest = os.path.join(PROJECT_ROOT, 'windows/runner/resources/app_icon.ico')
ico_sizes = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
final_mac.save(windows_ico_dest, format='ICO', sizes=ico_sizes)
print(f"Generated Windows app_icon.ico with sizes: {ico_sizes}")

# 7. Web icons
web_sizes = {
    'web/favicon.png': (16, 16),
    'web/icons/Icon-192.png': (192, 192),
    'web/icons/Icon-512.png': (512, 512),
    'web/icons/Icon-maskable-192.png': (192, 192),
    'web/icons/Icon-maskable-512.png': (512, 512),
}

for rel_path, size in web_sizes.items():
    dest = os.path.join(PROJECT_ROOT, rel_path)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    img = master.resize(size, Image.Resampling.LANCZOS)
    img.save(dest, 'PNG', optimize=True)
    print(f"Generated Web {rel_path} -> {size}")

print("\nAll icons generated successfully!")
