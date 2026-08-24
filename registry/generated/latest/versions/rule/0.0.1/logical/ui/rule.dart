/// The validator layer — what `zod` + `@hookform/resolvers` do on the web,
/// with no dependency at all.
///
/// Ruling F7: *"Validator = dependency-free `ElRule<T>` lists with first-issue /
/// all-issues collection; the Zod-4 email regex ships verbatim as one rule."*
///
/// The shape is deliberately small, because the reference's shape is small.
/// `forms-map.md` §5.1 lists every schema the page declares, and all of them are
/// the same thing: an ordered list of checks against one value, each carrying
/// the sentence it renders. That is [ElRule]. There is no object schema, no
/// coercion, no transform, no async refinement — none of it is reachable from
/// the surface being ported, and inventing it would be inventing an API the
/// reference does not have.
///
/// Two Zod-4 behaviours this file reproduces exactly, because the rendered
/// message depends on them (`forms-map.md` §5.3–5.4):
///
/// 1. **Zod 4 runs every string check in declaration order without aborting.**
///    `"AB"` against `min(3) → max(20) → regex(/^[a-z0-9_]+$/)` raises
///    `too_small` *and* `invalid_format`, in that order. So [ElRules.check]
///    walks the whole list and collects, rather than returning at the first
///    failure.
/// 2. **`criteriaMode` decides how many survive.** RHF's default `firstError`
///    truncates the issue list to its first entry; `"all"` keeps them all. That
///    is [ElIssueMode], and it is the entire difference between the account
///    form's one message and the password form's four.
///
/// Deduplication is deliberately *not* done here. `FieldError` is what dedupes
/// (`field.tsx:196–198` builds a `Map` keyed by message), so the port dedupes in
/// `ElFieldError` too — same operation, same place.
library;

/// A predicate over one field's value. `true` means the value passes.
typedef ElRuleTest<T> = bool Function(T value);

/// One check, and the sentence it renders when a value fails it.
///
/// The message is not derived, formatted or interpolated: every string in
/// `forms-map.md` §5.1 is written out at the schema, punctuation included, so a
/// rule carries its message the way the schema does.
class ElRule<T> {
  const ElRule(this.test, this.message);

  /// Passes when this returns `true`.
  final ElRuleTest<T> test;

  /// What `FieldError` renders when [test] fails. Verbatim, including the
  /// trailing full stop the reference writes.
  final String message;

  /// [message] when [value] fails this rule, `null` when it passes.
  String? issue(T value) => test(value) ? null : message;

  // ── The checks the reference's four schemas actually use ─────────────────

  /// `z.string().min(n, msg)`.
  ///
  /// Length is counted in **UTF-16 code units**, which is what JavaScript's
  /// `String.length` counts and therefore what Zod compares. Dart's
  /// `String.length` is the same measure, so the two agree without conversion —
  /// including where they are both "wrong" about an emoji.
  static ElRule<String> minLength(int min, String message) =>
      ElRule<String>((String v) => v.length >= min, message);

  /// `z.string().max(n, msg)`.
  static ElRule<String> maxLength(int max, String message) =>
      ElRule<String>((String v) => v.length <= max, message);

  /// `z.string().regex(re, msg)`.
  ///
  /// Zod tests with `RegExp.test`, which is a **search**, not an anchored
  /// match — every regex in §5.1 that means "the whole value" writes its own
  /// `^…$`. [RegExp.hasMatch] is the same search, so the anchors carry across
  /// unchanged and `/[A-Z]/` still means "contains a capital".
  static ElRule<String> pattern(RegExp expression, String message) =>
      ElRule<String>(expression.hasMatch, message);

  /// `z.email(msg)` — one rule, one predicate, [emailPattern].
  static ElRule<String> email(String message) =>
      ElRule<String>(emailPattern.hasMatch, message);

  /// `z.boolean().refine(v => v, { message })` — the terms checkbox.
  ///
  /// The reference's source comment (`page.tsx:81–85`) explains why it is a
  /// `.refine` and not `z.literal(true)`: a literal types the field as `true`,
  /// so the `false` default cannot assign and the schema ends up unable to
  /// describe the only state the checkbox starts in.
  static ElRule<bool> accepted(String message) =>
      ElRule<bool>((bool v) => v, message);

  /// `z.enum([...], { message })`.
  ///
  /// Zod 4 applies the same `message` to the invalid-**type** case, which is
  /// how an untouched radio group (`undefined`) renders "Pick a payout rhythm."
  /// rather than a type error — so a null value fails this rule like any other
  /// value outside the set (`forms-map.md` §5.5).
  static ElRule<T?> oneOf<T>(List<T> allowed, String message) =>
      ElRule<T?>((T? v) => v != null && allowed.contains(v), message);

  /// **Zod 4's `z.email()` predicate, verbatim** — `zod/v4/core/regexes.js:31`,
  /// where it is commented *"Practical email validation"*:
  ///
  /// ```js
  /// /^(?!\.)(?!.*\.\.)([A-Za-z0-9_'+\-\.]*)[A-Za-z0-9_+-]@([A-Za-z0-9][A-Za-z0-9\-]*\.)+[A-Za-z]{2,}$/
  /// ```
  ///
  /// It ships as one rule and as one string because the message depends on the
  /// predicate exactly: it is stricter than HTML5's, and the four ways it is
  /// stricter are all reachable by typing into the field — **no leading dot, no
  /// `..` anywhere, at least one dotted domain label, and a TLD of two or more
  /// letters**, so `a@b` fails where a browser's own `type="email"` accepts it.
  /// Loosening it by one character changes which keystroke makes "That is not
  /// an email address." disappear.
  ///
  /// Dart's regex engine reads this dialect unchanged: both lookaheads, the
  /// escaped `\-` inside the classes, and `{2,}` all mean here what they mean
  /// in JavaScript. The Dart source uses a raw **double-quoted** string because
  /// the pattern itself contains an apostrophe.
  static final RegExp emailPattern = RegExp(
    r"^(?!\.)(?!.*\.\.)([A-Za-z0-9_'+\-\.]*)[A-Za-z0-9_+-]@([A-Za-z0-9][A-Za-z0-9\-]*\.)+[A-Za-z]{2,}$",
  );
}

/// RHF's `criteriaMode` — how many of a field's issues survive to the message.
enum ElIssueMode {
  /// `"firstError"`, the default. Zod's issue list is truncated to its first
  /// entry per path, so `""` in the account form's `handle` renders only
  /// "At least 3 characters." even though the regex failed too.
  first,

  /// `"all"`. Every issue reaches `FieldError`, which renders a bare string for
  /// one and a bulleted list for two or more. The password form is the only
  /// place in the corpus where that list branch fires.
  all,
}

/// Runs rule lists.
class ElRules {
  const ElRules._();

  /// Every message [value] fails, in the order the rules are declared, cut to
  /// one entry under [ElIssueMode.first].
  ///
  /// The full walk happens either way — a rule list is a schema, and a schema
  /// that stopped early would report a different *first* issue than Zod does
  /// whenever an earlier check passes and a later one fails.
  static List<String> check<T>(
    T value,
    List<ElRule<T>> rules, {
    ElIssueMode mode = ElIssueMode.first,
  }) {
    final List<String> issues = <String>[];
    for (final ElRule<T> rule in rules) {
      final String? issue = rule.issue(value);
      if (issue == null) continue;
      issues.add(issue);
      if (mode == ElIssueMode.first) break;
    }
    return issues;
  }

  /// [messages] with repeats removed, first occurrence winning.
  ///
  /// `FieldError`'s own dedupe (`field.tsx:196–198`): `new Map(errors.map(e =>
  /// [e.message, e])).values()`. A JS `Map` preserves insertion order and a
  /// later duplicate overwrites the value at its *original* position, so the
  /// surviving order is first-seen — which is what this reproduces.
  static List<String> dedupe(List<String> messages) {
    final Set<String> seen = <String>{};
    return <String>[
      for (final String message in messages)
        if (seen.add(message)) message,
    ];
  }
}
