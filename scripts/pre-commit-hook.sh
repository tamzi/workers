#!/usr/bin/env bash
# Pre-commit hook: Fast validation checks before committing
# 
# This hook performs lightweight validation only (< 5 seconds):
# - File count and naming conventions
# - Documentation rules
# - No code examples in markdown
#
# Heavy checks (build, tests, lint) run during pre-push for better performance.
#
# Installation: Copy this file to .git/hooks/pre-commit
# Or run: ./scripts/install-git-hooks.sh
#
# ⚠️  CANNOT BE BYPASSED: Even if you use --no-verify to skip this hook,
#     violations will be caught by:
#     1. Pre-push hook (validates commit history and runs tests)
#     2. Server-side pre-receive hook (cannot be bypassed)

set -e  # Exit on first error

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🔍 Running pre-commit checks..."
echo ""
echo "Note: This hook performs fast validation checks only."
echo "Build, tests, and code quality checks run during pre-push."
echo ""

VIOLATIONS=0

# Get list of staged files
# Use separate lists to match pre-push file counting (no rename detection)
# while still only reading files that exist for content checks.
# For renames (R), only count the new filename to avoid double-counting
COUNTED_FILES=$(git diff --cached --name-status | awk '{ if ($1 ~ /^R/) { print $3 } else if ($1 ~ /^C/) { print $3 } else { print $2 } }')
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR)

if [ -z "$COUNTED_FILES" ]; then
    echo "No files staged for commit."
    exit 0
fi

# Check 1: Module README size limit (< 100 lines)
# Module READMEs should be brief (< 100 lines). Detailed docs go in docs/architecture/
echo "📏 Checking module README size limits..."
for file in $STAGED_FILES; do
    # Check if it's an Android module README (app/, core/, feature/, dds/, etc.)
    # Exclude: docs/, scripts/, buildLogic/, gradle/ (these can have longer READMEs)
    if [[ "$file" == */README.md ]] && \
       [[ "$file" != docs/* ]] && \
       [[ "$file" != scripts/* ]] && \
       [[ "$file" != buildLogic/* ]] && \
       [[ "$file" != gradle/* ]]; then
        LINE_COUNT=$(wc -l < "$file" | tr -d ' ')
        if [ "$LINE_COUNT" -gt 100 ]; then
            echo -e "${RED}❌ VIOLATION: $file has $LINE_COUNT lines (limit: 100)${NC}"
            echo -e "   Fix: Move detailed content to docs/architecture/<moduleName>/"
            VIOLATIONS=$((VIOLATIONS + 1))
        else
            echo -e "${GREEN}✓${NC} $file: $LINE_COUNT lines"
        fi
    fi
done
echo ""

# Check 2: File naming convention (camelCase for .md files except README.md and Agents.md)
# All markdown files should use camelCase (e.g., commitRules.md, not COMMIT_RULES.md)
echo "📝 Checking file naming conventions..."
for file in $STAGED_FILES; do
    if [[ "$file" == *.md ]]; then
        filename=$(basename "$file")
        # Skip README.md and Agents.md (allowed to be uppercase)
        if [[ "$filename" != "README.md" ]] && [[ "$filename" != "Agents.md" ]]; then
            # Check if filename starts with uppercase (wrong) or has underscores (wrong)
            # camelCase should start with lowercase and may have internal caps
            if [[ "$filename" =~ ^[A-Z] ]] || [[ "$filename" =~ _ ]]; then
                lowercase_name=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
                echo -e "${RED}❌ VIOLATION: $file uses wrong naming${NC}"
                echo -e "   Expected: camelCase (must start lowercase, no underscores)"
                echo -e "   Suggestion: $lowercase_name"
                echo -e "   Found: $filename"
                VIOLATIONS=$((VIOLATIONS + 1))
            else
                echo -e "${GREEN}✓${NC} $file: correct naming"
            fi
        fi
    fi
done
echo ""

# Check 3: One documentation file per commit (BLOCKING VIOLATION)
# Each documentation file should have its own commit for easier tracking
echo "📄 Checking documentation files per commit..."
DOC_COUNT=$(echo "$COUNTED_FILES" | grep -c '\.md$' || true)
if [ "$DOC_COUNT" -gt 1 ]; then
    echo -e "${RED}❌ VIOLATION: $DOC_COUNT documentation files staged (maximum: 1)${NC}"
    echo -e "   Rule: Each documentation file MUST be in its own commit"
    echo -e "   Staged .md files:"
    echo "$COUNTED_FILES" | grep '\.md$' | sed 's/^/     - /'
    echo ""
    echo -e "   ${RED}Split into separate commits - one file per commit${NC}"
    VIOLATIONS=$((VIOLATIONS + 1))
else
    echo -e "${GREEN}✓${NC} Only 1 documentation file (or none) staged"
fi
echo ""

# Check 4: Maximum files per commit (stricter enforcement)
# Commits should be focused (1-3 files ideal, 5 files max) to keep changes atomic
echo "📊 Checking commit size..."
FILE_COUNT=$(echo "$COUNTED_FILES" | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -gt 5 ]; then
    echo -e "${RED}❌ VIOLATION: $FILE_COUNT files staged (maximum: 5)${NC}"
    echo -e "   Rule: Keep commits focused - ideal is 1-3 files"
    echo -e "   Split large commits by layer and dependency order"
    VIOLATIONS=$((VIOLATIONS + 1))
elif [ "$FILE_COUNT" -gt 3 ]; then
    echo -e "${YELLOW}⚠️  WARNING: $FILE_COUNT files staged (ideal: 1-3)${NC}"
    echo -e "   Consider splitting by layer if they're unrelated"
else
    echo -e "${GREEN}✓${NC} $FILE_COUNT files staged"
fi
echo ""

# Check 5: No mixed code and documentation changes (BLOCKING VIOLATION)
# Documentation changes should be in separate commits from code changes
echo "🔀 Checking for mixed concerns..."
HAS_CODE=$(echo "$COUNTED_FILES" | grep -cv '\.md$' || true)
HAS_DOCS=$(echo "$COUNTED_FILES" | grep -c '\.md$' || true)

if [ "$HAS_CODE" -gt 0 ] && [ "$HAS_DOCS" -gt 0 ]; then
    echo -e "${RED}❌ VIOLATION: Mixing code and documentation changes${NC}"
    echo -e "   Rule: Documentation changes MUST be in separate commits"
    echo -e "   Code files: $HAS_CODE | Documentation files: $HAS_DOCS"
    echo ""
    echo -e "   ${RED}Split into separate commits:${NC}"
    echo -e "   1. Commit code changes first"
    echo -e "   2. Commit documentation changes separately (one file per commit)"
    VIOLATIONS=$((VIOLATIONS + 1))
else
    echo -e "${GREEN}✓${NC} No mixed concerns detected"
fi
echo ""

# Check 6: No Kotlin/Java code examples in markdown files
# Code examples belong in KDoc comments in actual code files, not markdown
echo "💻 Checking for code examples in markdown (should be KDoc)..."
CODE_EXAMPLES_FOUND=0
for file in $STAGED_FILES; do
    if [[ "$file" == *.md ]]; then
        # Check for kotlin or java code blocks
        if grep -q "\`\`\`kotlin\|\`\`\`java" "$file" 2>/dev/null; then
            # Exclude README.md files as they can have quick examples
            # Exclude meta-documentation (docs/agentRules/, docs/logs/) which needs examples
            if [[ "$(basename "$file")" != "README.md" ]] && \
               [[ "$file" != docs/agentRules/* ]] && \
               [[ "$file" != docs/logs/* ]]; then
                echo -e "${RED}❌ VIOLATION: $file contains Kotlin/Java code examples${NC}"
                echo -e "   Rule: Code examples belong in KDoc, not markdown files"
                echo -e "   Move code documentation to KDoc comments in actual code files"
                echo -e "   Exception: README.md files may have brief usage examples"
                echo -e "   See: docs/agentRules/documentationRules.md Rule 7"
                VIOLATIONS=$((VIOLATIONS + 1))
                CODE_EXAMPLES_FOUND=1
            fi
        fi
    fi
done
if [ "$CODE_EXAMPLES_FOUND" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No code examples in documentation files"
fi
echo ""

# Check 7: Design system enforcement (no Material components or raw colors)
if ! ./scripts/check-design-system-usage.sh; then
    VIOLATIONS=$((VIOLATIONS + 1))
fi
echo ""

# If violations found, block the commit
if [ "$VIOLATIONS" -gt 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}❌ COMMIT BLOCKED: $VIOLATIONS violation(s) found${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Please fix the violations above before committing."
    echo "See docs/agentRules/commitRules.md for details."
    echo ""
    echo -e "${YELLOW}⚠️  Attempting to bypass with --no-verify?${NC}"
    echo -e "${YELLOW}   Your violations will still be caught by:${NC}"
    echo -e "${YELLOW}   1. Pre-push hook (validates commit history)${NC}"
    echo -e "${YELLOW}   2. Server-side hook (cannot be bypassed)${NC}"
    echo ""
    exit 1
fi

# Success!
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ All checks passed!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit 0
