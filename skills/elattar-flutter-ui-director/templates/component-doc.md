# Template: component documentation block

Goes above the class, in the component's own file. It records the contract a
consumer needs without leaving the source. Keep it to what is true; delete a row
that does not apply rather than writing "n/a" everywhere.

```dart
/// A short sentence on what this is for.
///
/// **Not for:** the neighbouring case it will be misused for, and the component
/// to use instead.
///
/// ## Usage
///
/// ```dart
/// StatusPill(
///   status: PaymentStatus.overdue,
///   onPressed: () => openInvoice(id),
/// )
/// ```
///
/// ## Variants
///
/// | Variant | Meaning |
/// | --- | --- |
/// | `neutral` | No judgement. The default. |
/// | `success` | The thing completed. |
/// | `warning` | Attention needed, nothing lost yet. |
/// | `destructive` | Failed, or about to cause loss. |
///
/// ## States
///
/// | State | Treatment |
/// | --- | --- |
/// | default | Filled surface, label, glyph. |
/// | hover | Surface lifts. Pointer only. |
/// | focus | Visible ring. Never removed. |
/// | pressed | Press feedback through `Press`. |
/// | disabled | Muted, not focusable, reason in a `Tooltip`. |
/// | loading | `Spinner` replaces the glyph, label stays. |
/// | selected | Exposed to assistive technology, not painted only. |
///
/// ## Keyboard
///
/// | Key | Action |
/// | --- | --- |
/// | Tab | Reaches the control. |
/// | Enter, Space | Activates it. |
///
/// ## Semantics
///
/// Announced as a button with the label, and the selected state exposed.
/// An icon only usage requires `label`.
///
/// ## Responsive
///
/// Label truncates with an ellipsis below `Breakpoints.sm`; the glyph and the
/// hit area do not shrink. Grows with text scale, no fixed height.
///
/// ## Theming
///
/// All color from `ThemeScope.of(context)`. Status colors carry meaning and are
/// always paired with the label, never used alone. Verified in light and dark.
class StatusPill extends StatelessWidget {
  // ...
}
```

## Tests that keep it honest

One test per applicable state, plus these three:

```dart
testWidgets('exposes its label to assistive technology', (WidgetTester t) async {
  // pump, then expect a Semantics node with the label
});

testWidgets('activates on Enter from the keyboard', (WidgetTester t) async {
  // focus, send the key, expect the callback
});

testWidgets('renders at 200 percent text scale without overflow', (WidgetTester t) async {
  // pump inside a MediaQuery with textScaler, expect no overflow errors
});
```

In repository mode also render the component in a specimen route, one instance
per variant and state, and let `test/token_guard_test.dart` prove there are no
literals.
