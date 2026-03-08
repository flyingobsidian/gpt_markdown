# Implementation Plan: Emoji Support & Checkboxes/Radio Buttons in Tables

## Requirements

### Feature 1: Emoji Support
- **What**: Users can write `:emoji_name:` (e.g., `:smile:`, `:fire:`, `:thumbsup:`) and it renders as the emoji character
- **Why**: Common markdown convention (GitHub, Discord, Slack use this), makes markdown more expressive
- **Constraints**:
  - Must work in all markdown contexts (inline text, tables, headings, etc.)
  - Should support a reasonable set of common emojis (100+)
  - Performance-critical: regex pattern matching happens on every render

### Feature 2: Checkboxes & Radio Buttons in Table Cells
- **What**: Allow `[ ] text` and `( ) text` syntax inside table cells, not just at block level
- **Why**: Common use case for feature matrices, comparison tables, checklist tables
- **Constraints**:
  - Preserve existing block-level checkbox/radio behavior
  - Work seamlessly alongside other inline markdown (bold, links, code)
  - Must not break table cell layout/alignment

## How Similar Features Work (Codebase Research)

### Emoji Component (Inline) - Similar to: **BoldMd** (lib/markdown_component.dart:500-526)
```
Pattern: BoldMd matches **text**
→ Creates TextSpan with fontWeight=bold
→ Recursively processes inner content for nested formatting
```

**InlineMd Emoji Pattern**:
- Regex: `:\w+:` (matches `:name:` with word characters)
- Extract emoji name from between colons
- Map name → Unicode character using emoji dictionary
- Return TextSpan with emoji character

### Checkboxes in Tables - Similar to: **CheckBoxMd** (line 284-301)
```
Pattern: CheckBoxMd extends BlockMd, matches [ ] or [x] at start of line
→ Creates CustomCb widget with label
→ Uses MdWidget to render label with block-level processing
```

**Problem**: Table cells call `MdWidget(..., false)` - only inlineComponents processed

**Solution Options**:
1. **Inline Variant (Recommended)**: Create `CheckBoxInlineMd extends InlineMd`
   - Same rendering as CheckBoxMd but works inline
   - Add to both globalComponents and inlineComponents
   - Works in tables because it's in inlineComponents list
   - Works at block level too (appears in globalComponents)

2. **Refactor to Support Both**: Modify CheckBoxMd to work at both levels
   - More complex, risk of breaking existing behavior
   - Less clear separation of concerns

**Selected**: Option 1 - Create inline variants

## Implementation Plan

### Phase 1: Emoji Support (Self-contained, no dependencies)

#### Step 1.1: Create Emoji Dictionary
**File**: `lib/utils/emoji_map.dart` (new)
**What**: Static map of emoji names → Unicode characters
**Implementation**:
- Map of ~100 common emojis (smile, fire, thumbsup, etc.)
- Can be expanded later
- Keep separate from component logic for maintainability

**Example structure**:
```dart
const Map<String, String> emojiMap = {
  'smile': '😊',
  'fire': '🔥',
  'thumbsup': '👍',
  // ... more emojis
};
```

#### Step 1.2: Create EmojiMd Component
**File**: `lib/markdown_component.dart` (add to this file)
**What**: InlineMd component for emoji rendering
**Implementation**:
- Class `EmojiMd extends InlineMd`
- `exp` getter: `RegExp(r':\w+:')` - matches `:name:`
- `span()` method:
  - Extract name from between colons
  - Look up in emojiMap
  - Return TextSpan with emoji, or original text if not found
- Add to `inlineComponents` list (line 20-32)

#### Step 1.3: Add Emoji Tests
**File**: `test/inline/emoji_test.dart` (new)
**Tests to include**:
- `testWidgets('simple emoji renders correctly')`
- `testWidgets('emoji with styled text works')`
- `testWidgets('emoji in table cells renders')`
- `testWidgets('unknown emoji renders as fallback')`
- `testWidgets('multiple emojis in text')`
- `testWidgets('emoji not separated by colons is not matched')`

**Test approach**: Follow existing pattern from `test/inline/bold_test.dart`
- Use `pumpMarkdown(tester, markdown)`
- Use `getSerializedOutput(tester)` to verify emoji character appears

### Phase 2: Checkboxes & Radio Buttons in Tables

#### Step 2.1: Create CheckBoxInlineMd Component
**File**: `lib/markdown_component.dart` (add to this file)
**What**: InlineMd version of CheckBoxMd
**Implementation**:
- Class `CheckBoxInlineMd extends InlineMd`
- Copy regex from CheckBoxMd: `RegExp(r'\[((?:\x|\ ))\]\ (\S[^\n]*?)$')`
- Match and render same way as CheckBoxMd
- Return CustomCb widget via WidgetSpan
- Add to `inlineComponents` list

**Key difference from CheckBoxMd**:
- CheckBoxMd extends BlockMd (top-level only)
- CheckBoxInlineMd extends InlineMd (works anywhere including inside tables)
- Both use same CustomCb widget, just different component class

#### Step 2.2: Create RadioButtonInlineMd Component
**File**: `lib/markdown_component.dart` (add to this file)
**What**: InlineMd version of RadioButtonMd
**Implementation**:
- Class `RadioButtonInlineMd extends InlineMd`
- Copy regex from RadioButtonMd: `RegExp(r'\(((?:\x|\ ))\)\ (\S[^\n]*?)$')`
- Match and render same way as RadioButtonMd
- Return CustomRb widget via WidgetSpan
- Add to `inlineComponents` list

#### Step 2.3: Add Table Checkbox/Radio Tests
**File**: `test/block/table_test.dart` (modify existing)
**New tests**:
- `testWidgets('table with checkbox in cell')`
- `testWidgets('table with radio button in cell')`
- `testWidgets('table with checked checkbox')`
- `testWidgets('table with multiple checkboxes')`
- `testWidgets('table with mixed inline content and checkboxes')`

**Test approach**:
```dart
testWidgets('table with checkbox in cell', (tester) async {
  await pumpMarkdown(tester, '''
| Option | Status |
|--------|--------|
| [ ] Task 1 | Pending |
| [x] Task 2 | Done |
''');
  final output = getSerializedOutput(tester);
  expect(output, contains('CHECKBOX'));
  expect(output, contains('TABLE'));
});
```

#### Step 2.4: Regression Tests
**Verify existing behavior still works**:
- Block-level checkboxes still work (not broken by inline variants)
- Block-level radio buttons still work
- Checkboxes work in nested lists
- Mixed content in tables

### Phase 3: Validation & Documentation

#### Step 3.1: Integration Tests
**File**: `test/integration/complex_markdown_test.dart` (modify)
**Add tests** combining both features:
- Emoji in table cells with checkboxes
- Emoji in checkbox labels
- Emoji in radio button labels
- Complex table with all features

#### Step 3.2: Update README
- Add examples of emoji syntax
- Add examples of checkboxes in tables
- Document supported emoji list

---

## Complete File Change Summary

### New Files
1. `lib/utils/emoji_map.dart` - Emoji name → character mapping
2. `test/integration/emoji_and_checkboxes_test.dart` - Combined feature tests

### Modified Files
1. `lib/markdown_component.dart`
   - Add `EmojiMd` class (extends InlineMd)
   - Add `CheckBoxInlineMd` class (extends InlineMd)
   - Add `RadioButtonInlineMd` class (extends InlineMd)
   - Add 3 classes to `inlineComponents` list

2. `test/inline/emoji_test.dart` - New test file for emoji
3. `test/block/table_test.dart` - Add checkbox/radio in table tests

### Firestore Changes
None - this is a formatting library, no database changes needed

### Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Emoji regex collision with other syntax | Use specific `:\w+:` pattern, test edge cases |
| Inline checkboxes appear where unwanted | Test with complex markdown, add negative tests |
| Performance with large emoji map | Dictionary lookup is O(1), negligible impact |
| Regex complexity explosion | Keep components simple, isolated concerns |

---

## Validation Checklist

### Code Quality
- [ ] All new code follows existing style (no unused imports, consistent naming)
- [ ] No duplicate logic between BlockMd and InlineMd variants
- [ ] Emoji dictionary is maintainable and documented

### Testing
- [ ] All unit tests pass
- [ ] Integration tests verify feature interaction
- [ ] Regression tests confirm existing behavior unchanged
- [ ] Table rendering tests pass with new components

### Documentation
- [ ] README updated with examples
- [ ] Inline comments explain regex patterns
- [ ] Emoji list is findable and extensible

---

## Implementation Order (Critical Path)

1. **Emoji Map** - No dependencies, can be done first
2. **EmojiMd Component** - Uses emoji map, independent
3. **Emoji Tests** - Validates emoji feature
4. **CheckBoxInlineMd** - Uses existing CustomCb widget
5. **RadioButtonInlineMd** - Uses existing CustomRb widget
6. **Table Cell Tests** - Tests both new components
7. **Integration Tests** - Final validation
8. **Documentation** - Update README
