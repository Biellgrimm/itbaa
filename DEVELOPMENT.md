# Itbaa Development Guide

## Setup

```bash
git clone https://github.com/AhmedRowaihi/ladybird.git
cd ladybird
git checkout itbaa
```

## Build & Test

```bash
# Build
cmake --preset Itbaa_Static
cmake --build Build/itbaa-static --target itbaa-cli

# Test
./Build/itbaa-static/bin/itbaa test.html output.pdf
./Build/itbaa-static/bin/itbaa --info test.html
```

## Making Changes

Edit files in:

-   `Utilities/Itbaa/lib/` - Core library
-   `Utilities/Itbaa/cli/` - CLI tool
-   `Utilities/CMakeLists.txt` - Build config

## Commit Changes

```bash
git add -A
git commit --amend -m "feat: Introduce Itbaa HTML to PDF library and CLI tool"
```

## Regenerate Patch

```bash
git format-patch -1 HEAD --stdout > itbaa-dist/patches/001-itbaa.patch
```

## Update to Newer Ladybird

```bash
git fetch origin master
git rebase origin/master
# Resolve conflicts if any
git rev-parse origin/master > itbaa-dist/LADYBIRD_COMMIT
git format-patch -1 HEAD --stdout > itbaa-dist/patches/001-itbaa.patch
```

## Project Structure

```
Utilities/Itbaa/
├── lib/
│   ├── Itbaa.h/cpp          # C API
│   ├── Renderer.h/cpp       # HTML rendering
│   ├── PDFWriter.h/cpp      # PDF generation
│   └── DisplayListPlayerPDF # Vector rendering
└── cli/
    └── main.cpp             # CLI tool
```
