#!/usr/bin/env bash
# Enforce design system usage in staged code:
# - No Material components (androidx.compose.material3.* or androidx.compose.material.*)
#   outside the design system module.
# - Material icons are ONLY allowed in design system module (for DesignSystemIcons registry).
#   All other modules must use DesignSystemIcons instead of Material icons directly.
# - No raw hex colors (Color(0x...)) outside the design system palette.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

RANGE=""
REF=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --range)
            RANGE="$2"
            shift 2
            ;;
        --ref)
            REF="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 2
            ;;
    esac
done

if [ -n "$RANGE" ] && [ -z "$REF" ]; then
    if [[ "$RANGE" == *..* ]]; then
        REF="${RANGE##*..}"
    else
        REF="$RANGE"
    fi
fi

if [ -n "$RANGE" ]; then
    FILES=$(git diff --name-only "$RANGE" --diff-filter=ACM)
else
    FILES=$(git diff --cached --name-only --diff-filter=ACM)
fi

if [ -z "$FILES" ]; then
    exit 0
fi

VIOLATIONS=0
CHECKED_FILES=0

echo "🎨 Checking design system usage..."

for file in $FILES; do
    case "$file" in
        *.kt|*.java)
            # Material3 is ONLY allowed in design system module (for bridge components)
            # Skip Material3 checks for allowed bridge components in design system module
            case "$file" in
                designsystem/src/main/java/com/designsystem/ui/components/surface/DesignSystemModalBottomSheet.kt)
                    # Temporary bridge component using Material3 ModalBottomSheet
                    continue
                    ;;
                designsystem/src/main/java/com/designsystem/ui/components/input/DesignSystemDatePicker.kt|designsystem/src/main/java/com/designsystem/ui/components/input/TimePickerDialog.kt)
                    # Temporary bridge components using Material3 DatePicker/TimePicker
                    continue
                    ;;
            esac

            # Get file content for all checks
            if [ -n "$REF" ]; then
                content=$(git show "$REF:$file" 2>/dev/null || true)
                if [ -z "$content" ]; then
                    continue
                fi
            else
                if [ ! -f "$file" ]; then
                    continue
                fi
            fi
            CHECKED_FILES=$((CHECKED_FILES + 1))

            # Check Material3 usage - only allowed in design system module
            if [[ "$file" != designsystem/* && "$file" != candela/* ]]; then
                # Outside design system: Material3 is completely forbidden
                if [ -n "$REF" ]; then
                    material3_hits=$(printf "%s\n" "$content" | grep -nE 'androidx\.compose\.material3\.' | \
                        grep -vE 'DatePicker|TimePicker|DatePickerDialog|TimeInput|rememberDatePickerState|rememberTimePickerState|ExperimentalMaterial3Api' || true)
                else
                    material3_hits=$(grep -nE 'androidx\.compose\.material3\.' "$file" | \
                        grep -vE 'DatePicker|TimePicker|DatePickerDialog|TimeInput|rememberDatePickerState|rememberTimePickerState|ExperimentalMaterial3Api' || true)
                fi
                if [ -n "$material3_hits" ]; then
                    echo -e "${RED}❌ VIOLATION: Material3 usage in $file${NC}"
                    echo "$material3_hits" | sed 's/^/     - /'
                    echo "   Fix: Material3 is only allowed in design system module. Use DesignSystem components instead."
                    VIOLATIONS=$((VIOLATIONS + 1))
                fi
            fi

            # Check Material (not Material3) usage
            # Material icons are ONLY allowed in design system module
            if [[ "$file" == designsystem/* || "$file" == candela/* ]]; then
                # Allow Material icons in design system module (for DesignSystemIcons registry)
                if [ -n "$REF" ]; then
                    material_hits=$(printf "%s\n" "$content" | grep -nE 'androidx\.compose\.material\.' | \
                        grep -vE 'androidx\.compose\.material\.icons(Extended|\.|$)' || true)
                else
                    material_hits=$(grep -nE 'androidx\.compose\.material\.' "$file" | \
                        grep -vE 'androidx\.compose\.material\.icons(Extended|\.|$)' || true)
                fi
            else
                # Outside design system: Material icons are NOT allowed - must use DesignSystemIcons
                if [ -n "$REF" ]; then
                    material_hits=$(printf "%s\n" "$content" | grep -nE 'androidx\.compose\.material\.' || true)
                else
                    material_hits=$(grep -nE 'androidx\.compose\.material\.' "$file" || true)
                fi
            fi
            if [ -n "$material_hits" ]; then
                if [[ "$file" == designsystem/* || "$file" == candela/* ]]; then
                    echo -e "${RED}❌ VIOLATION: Material usage (non-icon) in $file${NC}"
                    echo "$material_hits" | sed 's/^/     - /'
                    echo "   Fix: Only Material icons are allowed in design system module."
                else
                    echo -e "${RED}❌ VIOLATION: Material usage in $file${NC}"
                    echo "$material_hits" | sed 's/^/     - /'
                    echo "   Fix: Use DesignSystemIcons instead of Material icons directly."
                    echo "   Example: Replace 'Icons.Rounded.Add' with 'DesignSystemIcons.Add'"
                fi
                VIOLATIONS=$((VIOLATIONS + 1))
            fi

            case "$file" in
                designsystem/src/main/java/com/designsystem/ui/foundation/color/*)
                    # Skip raw color checks for color palette files
                    ;;
                *)
                    if [ -n "$REF" ]; then
                        raw_color_hits=$(printf "%s\n" "$content" | grep -nE 'Color[[:space:]]*\([[:space:]]*0[xX][0-9A-Fa-f]{6,8}' || true)
                    else
                        raw_color_hits=$(grep -nE 'Color[[:space:]]*\([[:space:]]*0[xX][0-9A-Fa-f]{6,8}' "$file" || true)
                    fi
                    if [ -n "$raw_color_hits" ]; then
                        echo -e "${RED}❌ VIOLATION: Raw hex color usage in $file${NC}"
                        # shellcheck disable=SC2001
                        echo "$raw_color_hits" | sed 's/^/     - /'
                        echo "   Fix: Use DesignSystemTheme color tokens instead of Color(0x...)."
                        VIOLATIONS=$((VIOLATIONS + 1))
                    fi
                    ;;
            esac
            ;;
    esac
done

if [ "$CHECKED_FILES" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No Kotlin/Java files staged for design system checks"
    exit 0
fi

if [ "$VIOLATIONS" -gt 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}❌ DESIGN SYSTEM CHECK FAILED: $VIOLATIONS issue(s)${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "See docs/tech/designsystem/designSystem.md for guidance."
    exit 1
fi

echo -e "${GREEN}✓${NC} Design system usage looks good"
exit 0
