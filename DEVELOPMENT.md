# Itbaa Development Guide

## Setup

```bash
git clone https://github.com/ahmedrowaihi/ladybird-itbaa.git ladybird
cd ladybird
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

- `Utilities/Itbaa/lib/` - Core library
- `Utilities/Itbaa/cli/` - CLI tool
- `Utilities/CMakeLists.txt` - Build config

## Commit Changes

```bash
git add -A
git commit --amend -m "feat: Introduce Itbaa HTML to PDF library and CLI tool"
```

## Regenerate Patch

```bash
git diff $(cat itbaa-dist/LADYBIRD_COMMIT) > itbaa-dist/patches/001-itbaa.patch
```

## Update to Newer Ladybird

```bash
# Add upstream if not already added
git remote add upstream https://github.com/LadybirdBrowser/ladybird.git

# Fetch and rebase onto upstream
git fetch upstream master
git rebase upstream/master
# Resolve conflicts if any, then: git rebase --continue

# Update pinned commit and regenerate patch
git rev-parse upstream/master > itbaa-dist/LADYBIRD_COMMIT
git diff $(cat itbaa-dist/LADYBIRD_COMMIT) > itbaa-dist/patches/001-itbaa.patch

# Force push to your fork
git push origin master --force-with-lease
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
