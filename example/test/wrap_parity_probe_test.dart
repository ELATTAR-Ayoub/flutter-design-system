// Line-wrap parity — the Flutter half of the wrap inventory.
//
// Vertical parity says the pages stack to the same heights; it cannot say the
// paragraphs break in the same places. A paragraph that breaks one word early
// and recovers on the next line stacks identically and still reads wrong, and
// a chip that survives whole where the browser splits it is a visible
// difference this suite would otherwise never see.
//
// So: pump each route inside the real [DocsShell] at the 1440 frame with the
// reference's own fonts, measure every character of every paragraph, cut the
// text into lines wherever x goes backwards, and hold the result against what
// Chrome does with the same copy in the same column.
//
// `WRAP_DUMP=1` prints the whole inventory instead of just the failures:
//
//     WRAP|<page>|<lines>|<constraint>|<width>|<text>
//     WRAPLINE|<page>|<index>|<width>|<line text>
//
// which is the format `scratchpad/measure-wraps.js` emits from the browser, so
// the two dumps diff line for line.
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

const Size _viewport = Size(1440, 900);

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

String _norm(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

/// The break point: the last word before the engine moved to the next line.
String _lastWord(_Line line) => line.text.split(' ').last;

/// Enough of a paragraph to recognise it in a failure message.
String _clip(String s) => s.length > 60 ? '${s.substring(0, 60)}…' : s;

class _Para {
  _Para(this.paragraph, this.nested);
  final RenderParagraph paragraph;
  final List<String> nested;
}

/// Every text under [element], concatenated in tree order.
String _textUnder(Element element) {
  final StringBuffer buffer = StringBuffer();
  void visit(Element node) {
    // [RichText] only: it is the leaf that owns the paragraph, and a [Text]
    // above it would count the same string twice.
    final Widget widget = node.widget;
    if (widget is RichText) buffer.write(widget.text.toPlainText());
    node.visitChildren(visit);
  }

  visit(element);
  return buffer.toString();
}

/// Collects every top-level [RenderParagraph] under [root], in tree order.
///
/// A paragraph nested inside another paragraph's [WidgetSpan] is a CSS inline
/// element — the browser gives it no line box of its own — so it is folded into
/// its host's text rather than reported separately. The host's own element
/// children are its placeholders, in order and one per `U+FFFC`, which is what
/// makes the fold unambiguous even when a placeholder holds several paragraphs
/// (a code chip glued to the punctuation after it).
List<_Para> _paragraphs(Element root) {
  final List<_Para> out = <_Para>[];

  void visit(Element element) {
    final RenderObject? object = element is RenderObjectElement
        ? element.renderObject
        : null;
    if (object is RenderParagraph) {
      final _Para para = _Para(object, <String>[]);
      out.add(para);
      element.visitChildren(
        (Element child) => para.nested.add(_norm(_textUnder(child))),
      );
      return;
    }
    element.visitChildren(visit);
  }

  visit(root);
  return out;
}

/// Splices the chip texts back in where the placeholders sit.
String _plain(_Para para) {
  final String raw = para.paragraph.text.toPlainText(includePlaceholders: true);
  if (!raw.contains('￼')) return raw;
  int next = 0;
  return raw.replaceAllMapped(
    RegExp('￼'),
    (Match _) => next < para.nested.length ? para.nested[next++] : '',
  );
}

class _Line {
  _Line(this.text, this.width);
  final String text;
  final double width;
}

/// The paragraph cut into lines wherever x goes backwards.
///
/// [RenderParagraph] exposes no line metrics, so every non-space character is
/// measured on its own and the string is cut where one character starts left of
/// where the previous one ended. Character granularity is the point: a word the
/// engine fragments across a line boundary lands half on each line rather than
/// being counted twice, which is exactly what the web probe does with `Range`.
List<_Line> _lines(_Para para) {
  final RenderParagraph p = para.paragraph;
  final String raw = p.text.toPlainText(includePlaceholders: true);
  final List<_Line> out = <_Line>[];
  final List<List<int>> spans = <List<int>>[]; // [from, to] per line
  final List<List<double>> edges = <List<double>>[]; // [left, right] per line

  for (int i = 0; i < raw.length; i++) {
    if (raw[i].trim().isEmpty) continue;
    final List<ui.TextBox> boxes = p.getBoxesForSelection(
      TextSelection(baseOffset: i, extentOffset: i + 1),
    );
    if (boxes.isEmpty) continue;
    final ui.TextBox b = boxes.first;
    if (b.right - b.left <= 0.01) continue;
    if (spans.isEmpty || b.left < edges.last[1] - 0.5) {
      spans.add(<int>[i, i]);
      edges.add(<double>[b.left, b.right]);
    } else {
      spans.last[1] = i;
      if (b.right > edges.last[1]) edges.last[1] = b.right;
    }
  }

  int chip = 0;
  for (int i = 0; i < spans.length; i++) {
    String text = raw.substring(spans[i][0], spans[i][1] + 1);
    while (text.contains('￼')) {
      text = text.replaceFirst(
        '￼',
        chip < para.nested.length ? para.nested[chip++] : '',
      );
    }
    out.add(_Line(_norm(text), edges[i][1] - edges[i][0]));
  }
  return out;
}

/// Where the reference breaks every paragraph that takes more than one line.
///
/// Measured off `http://localhost:3000` at 1440x900, dark, fonts loaded, by
/// `scratchpad/measure-wraps.js` (2026-08-14): each character located with a
/// `Range`, the text cut wherever x goes backwards. The value is the last word
/// of each line, joined with `|` — the break points themselves, which is the
/// only part of a line that a wrap flip can change.
///
/// Keyed by the paragraph's own text so a rewrite of the copy shows up as a
/// missing key rather than a silent pass, and by page because two routes carry
/// the same blurb in different columns.
///
/// A paragraph absent from this table is one the reference sets on a single
/// line, and is asserted to be single-line here too — which is what makes the
/// table a closed inventory rather than a list of interesting cases.
const Map<String, Map<String, String>>
_referenceBreaks = <String, Map<String, String>>{
  'overview': <String, String>{
    'THE OPERATING MANUAL. TWO BRAND ROLES NAMED FOR WHAT THEY MEAN RATHER THAN WHAT THEY LOOK LIKE, TWO COMPLETE THEMES, AND EVERY VALUE MEASURED OUT OF THE LIVE STYLESHEET RATHER THAN CLAIMED. EVERYTHING HERE IS A LIVE COMPONENT, NOT A PICTURE OF ONE.':
        'what|live|of|one.',
    'THE DECISIONS EVERYTHING ELSE INHERITS. CHANGE SOMETHING HERE AND IT PROPAGATES THROUGH EVERY BASE COMPONENT AND THE ENTIRE AGENT CONSOLE.':
        'base|console.',
    'SURFACES, THE ACTION AND VALUE RAMPS, TEXT, HAIRLINES, SEMANTIC STATES, AND EVERY CONTRAST RATIO MEASURED LIVE IN BOTH THEMES.':
        'text,|contrast|themes.',
    'TWO FACES ONLY: SPACE GROTESK FOR EVERY WORD, GEIST MONO FOR EVERY NUMBER. FULL SPECIMEN OF EACH TYPE CLASS, PLUS THE PROSE BLOCK THAT REACHES THE SAME SCALE WITHOUT ONE.':
        'word,|of|that|one.',
    'THE 8-POINT SPACING SCALE, RADIUS LADDER, ELEVATION SET, 12-COLUMN GRID AND RESPONSIVE BREAKPOINTS.':
        'ladder,|responsive|breakpoints.',
    'TWO FAMILIES: AMBIENT DEPTH, AND MACHINE SURFACES THAT LOOK LIKE THEY CAN BE PHYSICALLY PRESSED. PORTED FROM YUKIRHYTHM.':
        'machine|physically|Yukirhythm.',
    'DURATIONS, EASING CURVES AND THE NAMED ANIMATIONS — EACH ONE RUNNING LIVE SO TIMING CAN BE JUDGED, NOT GUESSED.':
        'named|can|guessed.',
    'THE ICON COMPONENT WRAPPING LUCIDE: FIXED SIZES, STROKE RULES, AND THE CURATED ICON SET, GROUPED BY DOMAIN.':
        'fixed|set,|domain.',
    'THREE FAMILIES, DELIBERATELY SEPARATED. BASE IS THE GENERIC CHASSIS ANY PRODUCT COULD USE. AGENT IS A COMPLETE AI CONSOLE, WRITTEN FROM SCRATCH AND POINTED AT A TRANSPORT YOU SUPPLY. SITE PAGES OWN NO VISUAL VALUES OF THEIR OWN — ONLY THE COMPOSITION RULES THAT ASSEMBLE THE OTHER TWO INTO A PAGE.':
        'a|visual|page.',
    'THE SHADCN CHASSIS, RESTYLED ONTO THIS SYSTEM\'S TOKENS. GENERIC, REUSABLE, PRODUCT-AGNOSTIC.':
        'reusable,|product-agnostic.',
    'A COMPLETE AI CONSOLE — TRANSCRIPT, COMPOSER, AVATAR AND VOICE — POINTED AT A TRANSPORT YOU SUPPLY. WRITTEN FROM SCRATCH, AND PRODUCT-AGNOSTIC BY CONSTRUCTION.':
        'pointed|by|construction.',
    'COMPOSITION RATHER THAN CONTROLS: THE CONTAINERS, BANDS AND READING COLUMNS THAT ASSEMBLE AN FAQ, A POLICY OR A HELP ARTICLE OUT OF BASE COMPONENTS WITHOUT INVENTING A SINGLE NEW VISUAL VALUE.':
        'reading|base|value.',
    'TWO COMPLETE THEMES. DARK IS THE DEFAULT, AND LIGHT IS EQUALLY SUPPORTED. ROUGHLY 70% OF ANY SCREEN IS NEUTRAL SURFACE FROM THE FIVE-STEP LADDER, 20% BLUE, 10% LIME.':
        '10%|lime.',
    'BLUE ACTS, LIME VALUES. BLUE IS INTERACTION: PRIMARY BUTTONS, SELECTION, ACTIVE NAV, FOCUS. LIME IS WORTH: BALANCES, REWARDS, RANKINGS, PREMIUM ACTIONS. NEVER SWAP THEM.':
        'swap|them.',
    'THIS IS THE DESIGN SYSTEM AND COMPONENT LIBRARY. THE TEN PRODUCT SCREENS ARE BUILT ON TOP OF IT AND ARE TRACKED SEPARATELY — NOTHING IN HERE IMPLEMENTS A REAL WALLET, PAYMENT, BLOCKCHAIN OR SHIPPING INTEGRATION. ALL FIGURES, PACKS, CARDS AND USERS ARE PLACEHOLDER DATA.':
        'wallet,|data.',
  },
  'colors': <String, String>{
    'ZINC FOR EVERYTHING STRUCTURAL, BLUE FOR ACTION, LIME FOR WORTH, FOUR STATE COLOURS, AND NOTHING ELSE. TWO ROLES, TWO THEMES, AND EVERY VALUE ON THIS PAGE MEASURED RATHER THAN CLAIMED.':
        'and|rather|claimed.',
    'EVERY VALUE BELOW IS READ FROM THE LIVE STYLESHEET AND EVERY CONTRAST RATIO IS COMPUTED FROM IT AT RUNTIME. NOTHING ON THIS PAGE IS TYPED BY HAND, SO IT CANNOT DISAGREE WITH APP/GLOBALS.CSS — AND IT RE-MEASURES WHEN YOU FLIP THE THEME, SO THE RATIOS YOU ARE READING ARE THE RATIOS FOR THE MODE YOU ARE ACTUALLY IN. THE RULES THAT GOVERN ALL OF IT LIVE IN RULES.MD.':
        'disagree|that|RULES.md.',
    'SIX STEPS ON SHADCN\'S OWN TOKEN NAMES, READ DOWNWARD ON LIGHT AND UPWARD ON DARK. THERE IS NO SECOND NAMING SYSTEM.':
        'second|system.',
    'SECONDARY TEXT, METADATA, HELPER COPY. THE ONE STEP THAT IS NOT A MIRROR BETWEEN THEMES — SEE THE NOTE BELOW. UTILITY: TEXT-MUTED-FOREGROUND.':
        'below.|text-muted-foreground.',
    'EVERY OTHER NEUTRAL INVERTS CLEANLY BETWEEN THE TWO THEMES. MUTED FOREGROUND DOES NOT. ON DARK IT IS ZINC 300, WHICH MEASURES ABOUT 13:1; THE MIRROR IMAGE WOULD BE ZINC 400 ON WHITE, WHICH MEASURES 3.1:1 AND FAILS AA OUTRIGHT. NOR IS IT ZINC 500, WHICH THIS SYSTEM SHIPPED FOR A LONG TIME: THAT CLEARS AA ON --BACKGROUND AND MISSES IT ON --MUTED BY A TENTH OF A POINT — AND MUTED TEXT ON A MUTED FILL IS THE MOST REPEATED PAIR IN THE WHOLE SYSTEM. LIGHT SITS ONE STEP DEEPER THAN ZINC 500 SO BOTH PAIRS CLEAR. FLIP THE THEME AND WATCH THE RATIO ABOVE: IT STAYS LEGAL IN BOTH, AND IT GETS THERE BY DIFFERENT MEANS.':
        'be|and|so|means.',
    'BUTTONS, LINKS, FOCUS, SELECTION, THE AGENT. IT ANSWERS ONE QUESTION: CAN I ACT ON THIS, OR IS THIS THE THING I PICKED? IT IS A BLUE TODAY; IT HAS BEEN PURPLE AND WINE BEFORE, AND NO COMPONENT KNEW.':
        'I|knew.',
    'THE TEXT-SAFE END, RESOLVED FOR WHICHEVER THEME YOU ARE IN. THE ONLY ACTION COLOUR ALLOWED ON TEXT, ICONS AND LINKS. UTILITY: TEXT-ACTION-INK.':
        'and|text-action-ink.',
    'THE FILL. DRIVES --PRIMARY: BUTTONS, SELECTION, ACTIVE NAV. NEVER CARRIES A GLYPH — PUT TEXT-PRIMARY-FOREGROUND ON TOP.':
        'on|top.',
    'THE RATIOS ABOVE ARE MEASURED LIVE, SO FLIP THE THEME AND WATCH THEM TRADE PLACES. ON DARK, --COLOR-ACTION-BRIGHT CLEARS AA AND THE DEEP END FAILS. ON LIGHT IT IS EXACTLY REVERSED. A COMPONENT CANNOT KNOW WHICH SURFACE IT IS SITTING ON, SO IT NEVER NAMES EITHER END — IT WRITES TEXT-ACTION-INK, AND THE THEME BLOCK ANSWERS. THE MID SHADE IS A FILL IN BOTH THEMES AND CAN NEVER CARRY A GLYPH; PUT TEXT-PRIMARY-FOREGROUND ON TOP OF IT.':
        'is|answers.|it.',
    'BALANCES, RANKINGS, REWARDS, PREMIUM ACTIONS. NOTHING ELSE. IT IS LIME TODAY, AND IT FOLLOWS THE SAME INK RULE THE ACTION RAMP DOES.':
        'rule|does.',
    'FOUR MEANINGS, FIXED. TWO OF THEM MOVED WHEN THE BRAND DID, AND BOTH MOVES WERE FORCED RATHER THAN AESTHETIC.':
        'than|aesthetic.',
    'A STATE COLOUR HAS ONE JOB: TO BE UNMISTAKABLE FOR ANYTHING ELSE ON THE SCREEN. INFORMATION USED TO BE BLUE 400, WHICH STOPPED WORKING THE MOMENT ACTION BECAME BLUE — A NEUTRAL NOTICE READ AS A PROMOTION. SUCCESS USED TO BE GREEN 400, A FEW DEGREES FROM LIME, WHICH IS TOO CLOSE WHEN A COMPLETED SALE AND A VALUABLE ONE APPEAR IN THE SAME SAME ROW. WARNING DID NOT MOVE AND GAINED SEPARATION FOR FREE: IT IS AMBER, AND LIME SITS FORTY DEGREES AWAY FROM IT, WHERE THE OLD VALUE HUE SAT ALMOST ON TOP OF IT. THAT COLLISION IS THE ONE THIS REBRAND FIXED BY ACCIDENT.':
        'blue|in|top|accident.',
    'A SURFACE THAT HAS TO FEEL RARE, PRECIOUS OR ALIVE IS A TEXTURE, NOT A HUE — A MOVING GRADIENT, A FOIL RAMP, AN IRIDESCENT BLOOM. THOSE LIVE IN GLOBALS.CSS AS UTILITIES (FOIL-VALUE, BLOOM-COSMIC, SHEEN-ACTION) AND ARE BUILT FROM THE TWO RAMPS ABOVE, SO THEY FOLLOW A REBRAND WITHOUT CARRYING COLOUR TOKENS OF THEIR OWN.':
        'a|in|sheen-|rebrand|own.',
    'NOTHING MAY BE COMMUNICATED BY COLOUR ALONE. A STATE SHIPS ITS GLYPH AND ITS LABEL AS WELL AS ITS HUE; A STATUS SHIPS ITS SENTENCE. THE FOUR STATE COLOURS ABOVE ARE A SECOND SIGNAL ON TOP OF A FIRST ONE, NEVER THE ONLY ONE — WHICH IS ALSO WHAT KEEPS THIS SYSTEM LEGIBLE WHEN BOTH THEMES AND EVERY FORM OF COLOUR-BLINDNESS ARE ACCOUNTED FOR.':
        'its|colours|is|of|for.',
  },
  'typography': <String, String>{
    'TWO FACES ONLY: SPACE GROTESK FOR EVERY WORD, GEIST MONO FOR EVERY NUMBER. FULL SPECIMEN OF EACH TYPE CLASS, PLUS THE PROSE BLOCK THAT REACHES THE SAME SCALE WITHOUT ONE.':
        'Full|scale|one.',
    'THE WHOLE TYPE SYSTEM IS A SINGLE RULE WITH NO EXCEPTIONS, WHICH IS WHAT KEEPS IT CONSISTENT ACROSS EVERY SCREEN AND COMPONENT.':
        'every|component.',
    'HEADINGS, BODY, BUTTONS, LABELS, NAVIGATION, CARD NAMES, PACK NAMES. A GEOMETRIC GROTESK: TECHNICAL ENOUGH TO FEEL ENGINEERED, OPEN ENOUGH TO STAY READABLE AT 11PX.':
        'A|stay|11px.',
    'PRICES, BALANCES, DATES, QUANTITIES, STATISTICS, SERIALS AND CODE. NUMERICAL VARIANTS ARE TABULAR SO ALIGNED VALUES DO NOT JITTER.':
        'Numerical|jitter.',
    'WORDS USE SPACE GROTESK THROUGH .TYPE-*. NUMERICAL VALUES USE GEIST MONO THROUGH .TYPE-NUM-*. EACH NAMED FOUNDATION OWNS ITS COMPLETE FONT, SIZE, LINE-HEIGHT, WEIGHT AND TRACKING.':
        'line-|tracking.',
    'NINE CLASSES COVER EVERY PIECE OF TEXT IN THE PRODUCT. DISPLAY IS RESERVED FOR THE LANDING HERO AND PACK-OPENING MOMENTS — NOTHING ELSE EARNS IT.':
        'pack-|it.',
    'LANDING HERO. PACK-OPENING REVEAL. ONCE PER PAGE, AT MOST.':
        'reveal.|most.',
    'THE PAGE HEADING. EXACTLY ONE PER SCREEN.': 'per|screen.',
    'MAJOR PAGE SECTIONS — FEATURED PACKS, LIVE PULLS, TOP GRAILS.':
        'Featured|Grails.',
    'CARD TITLES, MODULE HEADINGS, MODAL TITLES.': 'modal|titles.',
    'PACK NAMES ON CARDS, COLLECTIBLE CARD NAMES, ROW TITLES.': 'card|titles.',
    'THE SENTENCE UNDER A PAGE HEADING. ONE PER SCREEN.': 'heading.|screen.',
    'EVERY PACK LISTS ITS ODDS, ITS REMAINING SUPPLY AND ITS TOP POSSIBLE HIT BEFORE YOU SPEND ANYTHING.':
        'spend|anything.',
    'STANDARD INTERFACE COPY, DESCRIPTIONS, DIALOG CONTENT.':
        'descriptions,|content.',
    'CARDS LAND IN YOUR STASH THE MOMENT A PACK FINISHES OPENING. FROM THERE YOU CAN KEEP THEM, SELL THEM BACK AT THE LISTED VALUE, OR ADD THEM TO A SHIPMENT.':
        'them|shipment.',
    'HELPER TEXT, SECONDARY DETAIL, TABLE CELLS, FILTER LABELS.':
        'table|labels.',
    'SECTION EYEBROWS, PANEL LABELS, FIELD LABELS, RARITY NAMES.':
        'field|names.',
    'THE FLOOR. BADGE TEXT, PIP CAPTIONS, CHART AXES. NEVER SMALLER.':
        'captions,|smaller.',
    'FIVE SIZES, ALL TABULAR, ALL SEMIBOLD. NUMBERS CARRY THE PRODUCT\'S MEANING — WHAT THINGS COST AND WHAT THEY ARE WORTH — SO THEY ARE GIVEN MORE WEIGHT THAN THE WORDS AROUND THEM.':
        'they|them.',
    'WALLET AVAILABLE BALANCE. TOTAL INVENTORY VALUE. HERO FIGURES.':
        'Total|figures.',
    'CARD VALUE IN THE INSPECTION MODAL. REWARD AMOUNTS. STAT TILES.':
        'modal.|tiles.',
    'PACK PRICE. CARD VALUE ON A TILE. LEADERBOARD POINTS.': 'tile.|points.',
    'TABLE FIGURES, TRANSACTION AMOUNTS, QUANTITIES, ODDS.': 'amounts,|odds.',
    'TIMESTAMPS, SUPPLY COUNTERS, TOKEN NAMES, METADATA FIGURES.':
        'token|figures.',
    'DECIMAL POINTS ALIGN. DIGITS KEEP THEIR COLUMN AS VALUES UPDATE LIVE, SO A TICKING BALANCE DOES NOT SHUFFLE SIDEWAYS.':
        'ticking|sideways.',
    'WORDS STAY IN SPACE GROTESK WHILE NUMERICAL VALUES USE GEIST MONO. THE NAMED CLASSES CARRY EACH TREATMENT WITHOUT PAGE-LEVEL TYPOGRAPHY VALUES.':
        'each|values.',
    'THE SAME SCALE, REACHED A SECOND WAY. A POLICY, A HELP ARTICLE OR THE OUTPUT OF A MARKDOWN RENDERER HAS NO CALL SITE TO PUT A CLASS ON, SO .PROSE STYLES THE ELEMENTS INSTEAD — AND IT DOES IT BY ADDING A SELECTOR TO THE TYPE ROLES ABOVE RATHER THAN BY OWNING A SECOND SET OF SIZES.':
        'no|the|sizes.',
    'EVERY ELEMENT HERE IS UNSTYLED MARKUP INSIDE A SINGLE PROSE WRAPPER. THE HEADING ABOVE IS THE SAME DECLARATION BLOCK AS .TYPE-H2 — NOT A COPY OF ITS SIZE, THE BLOCK ITSELF — SO RETUNING THE SCALE MOVES BOTH AND NEITHER CAN DRIFT FROM THE OTHER.':
        'the|scale|other.',
    'LINKS TAKE --COLOR-ACTION-INK, WHICH IS THE ONLY SHADE OF THE ACTION RAMP THAT READS IN BOTH THEMES, AND THEY ARE UNDERLINED AT REST BECAUSE A LINK IDENTIFIED BY HUE ALONE IS ONE SIGNAL WHERE THE ACCESSIBILITY CONTRACT ASKS FOR TWO.':
        'themes,|the|two.',
    'NESTED LISTS TAKE THE INTERIOR STEP RATHER THAN THE BLOCK STEP, SO A SUB-CLAUSE READS AS PART OF ITS PARENT RATHER THAN AS A NEW PARAGRAPH.':
        'its|paragraph.',
    'THAT HEADING IS AN H4 CARRYING .TYPE-LABEL. THE PROSE SELECTOR IS WRAPPED IN :WHERE(), SO IT WEIGHS ONE ELEMENT AND ANY REAL CLASS BEATS IT — .PROSE IS A DEFAULT, NOT A CAGE.':
        'it|cage.',
    'NOTHING. HTML CARRIES SCROLL-PADDING-BLOCK-START: VAR(--SCROLL-OFFSET), DERIVED FROM --HEIGHT-SITE-HEADER. A SCROLL-MARGIN HERE AS WELL WOULD ADD TO IT — MEASURED AT 192PX BELOW A 64PX HEADER BEFORE IT WAS REMOVED.':
        'well|removed.',
    'A TABLE IS DISPLAY:BLOCK WITH WIDTH:MAX-CONTENT CAPPED AT 100%, SO IT IS ITS OWN SCROLL PORT ON THE SYSTEM\'S THIN RAIL. IT TAKES CONTENT WIDTH RATHER THAN FILLING THE MEASURE — THE TRADE FOR NEVER BEING CLIPPED, WHICH IS WHAT HAPPENED AT 375PX BEFORE THE RULE EXISTED.':
        'content|existed.',
    'SIZES. EVERY ONE LIVES IN THE .TYPE-* ROLE IT SHARES A DECLARATION BLOCK WITH. IT ALSO SETS NO MAX-WIDTH — THE MEASURE BELONGS TO THE PAGE CONTAINER, AND TWO OWNERS FOR ONE NUMBER IS HOW --WIDTH-PAGE SPENT MONTHS AS PROSE ON THE SPACING PAGE.':
        'the|page.',
    '720PX. NARROWER THAN --WIDTH-CONTENT (1080PX) BECAUSE THAT COLUMN CARRIES SPECIMENS AND PANELS BESIDE THE COPY, WHILE THIS ONE CARRIES NOTHING BUT SENTENCES.':
        'one|sentences.',
    'THE PAGE HEADING IS THE PAGE\'S OWN H1. .PROSE STYLES H1 ANYWAY, BECAUSE AN UNSTYLED BROWSER DEFAULT IS WORSE THAN A HEADING LEVEL USED WRONGLY — BUT A DOCUMENT THAT OPENS WITH H2 IS THE CONVENTION.':
        'level|convention.',
    '@APPLY TYPE-H2 INSIDE A .PROSE H2 RULE FAILS THE BUILD OUTRIGHT — CANNOT APPLY UNKNOWN UTILITY CLASS — BECAUSE @APPLY REACHES TAILWIND UTILITIES AND @UTILITY REGISTRATIONS, AND THE TYPE SCALE LIVES IN @LAYER COMPONENTS. THE CALL-SITE SPELLING [&_H2]:TYPE-H2 IS THE SAME WALL FROM THE OTHER SIDE AND FAILS SILENTLY, WHICH IS THE WORSE OF THE TWO: NO ERROR, NO CLASS, EVERY GUARD GREEN, AND THE SIZE QUIETLY FALLING BACK TO INHERITED.':
        'and|fails|inherited.',
    'ALWAYS APPLY A .TYPE-* OR .TYPE-NUM-* CLASS — NEVER A RAW PIXEL SIZE IN A UTILITY.':
        'a|utility.',
    'PUT NUMERICAL VALUES IN THE GEIST MONO TYPE-NUM FOUNDATION SO COMPARABLE FIGURES STAY TABULAR.':
        'so|tabular.',
    'KEEP .TYPE-MICRO AS THE ABSOLUTE FLOOR AT 10.5PX, AND ONLY FOR UPPERCASE LABELS.':
        'uppercase|labels.',
    'USE .TYPE-DISPLAY ONCE PER SCREEN AT MOST, AND ONLY FOR HERO OR REVEAL MOMENTS.':
        'reveal|moments.',
    'DON\'T APPLY FONT FAMILIES OR NUMERIC WEIGHTS AT THE CALL SITE; CHOOSE A NAMED FOUNDATION CLASS.':
        'a|class.',
    'DON\'T ADD A THIRD TYPEFACE FOR DISPLAY; HEAVY SPACE GROTESK AT TIGHT TRACKING ALREADY CARRIES THE HERO.':
        'tight|hero.',
  },
  'spacing': <String, String>{
    'THE 8-POINT SPACING SCALE, RADIUS LADDER, ELEVATION SET, 12-COLUMN GRID AND RESPONSIVE BREAKPOINTS.':
        'and|breakpoints.',
    'AN 8-POINT SYSTEM WITH A 4PX HALF-STEP FOR TIGHT INTERIOR SPACING. TAILWIND\'S DEFAULT 0.25REM UNIT ALREADY MATCHES, SO THE CLASS NUMBER IS SIMPLY THE PIXEL VALUE DIVIDED BY FOUR.':
        'already|four.',
    'RADIUS ENCODES SIZE: THE BIGGER THE SURFACE, THE SOFTER THE CORNER. THIS OVERRIDES SHADCN\'S COMPUTED RADIUS SCALE WITH EXPLICIT VALUES.':
        'radius|values.',
    'BADGES, PIPS, SMALL CHIPS, INLINE CODE.': 'small|code.',
    'BUTTONS, INPUTS, ROWS, DROPDOWN ITEMS. THE DEFAULT.': 'rows,|The|default.',
    'CARDS, PACK CARDS, COLLECTIBLE TILES, PANELS.': 'cards,|panels.',
    'LARGE CARDS, DIALOGS, FEATURE PANELS.': 'dialogs,|panels.',
    'PROMOTIONAL PANELS, PACK STAGE.': 'panels,|stage.',
    'THE LANDING HERO PANEL. LARGEST ALLOWED.': 'hero|allowed.',
    'PILLS, FILTER CHIPS, AVATARS, LIVE INDICATOR.': 'chips,|indicator.',
    'FOUR NEUTRAL DEPTH STEPS, PLUS TWO GLOWS THAT ARE STRICTLY RATIONED. ON A NEAR-BLACK BACKGROUND A SHADOW READS AS A SOFT DARKENING, SO DEPTH MOSTLY COMES FROM THE SURFACE LADDER — SHADOWS ONLY CONFIRM IT.':
        'shadow|it.',
    'RESTING ROWS, CHIPS, TABLE HEADERS. BARELY THERE.': 'headers.|there.',
    'HOVERED CARDS, POPOVERS, DROPDOWNS, STICKY BARS.': 'dropdowns,|bars.',
    'DIALOGS, DRAWERS, THE PACK-OPENING STAGE.': 'pack-opening|stage.',
    'SELECTED PACK, FOCUSED PRIMARY CTA, ACTIVE OPENING STAGE. SIGNALS THIS IS THE THING YOU CHOSE.':
        'the|chose.',
    'LEGENDARY OR MYTHIC REVEAL, REWARD UNLOCK, PREMIUM ACTION. SIGNALS THIS IS WORTH SOMETHING.':
        'worth|something.',
    'DESKTOP-FIRST ON A 1440PX FRAME. CONTENT IS CAPPED SO THAT GRIDS NEVER STRETCH INTO UNREADABLE ROWS ON ULTRAWIDE DISPLAYS. EVERY MEASURE BELOW IS A TOKEN; THIS SECTION USED TO STATE THREE OF THEM AS PROSE ONLY, WHICH MEANT A CONTAINER HAD NOTHING TO READ AND AN ARBITRARY MAX-WIDTH WAS THE ONLY WAY TO OBEY IT.':
        'on|only,|it.',
    'TAILWIND\'S STOCK SCALE, UNMODIFIED, AND THESE ARE THE REAL NUMBERS RATHER THAN AN INTENT. THIS SECTION DESCRIBED A 1200PX DESKTOP BOUNDARY THAT NO BREAKPOINT HAS EVER FIRED AT; THE VALUES BELOW ARE THE ONES EVERY COMPONENT IN THIS REPOSITORY IS ACTUALLY WRITTEN AGAINST.':
        'section|ones|against.',
    'THE OBVIOUS FIX FOR A 1200PX INTENT IS A --BREAKPOINT-XL OVERRIDE. IT WAS REJECTED: EVERY ONE OF THE SIXTY-EIGHT BASE COMPONENTS IS WRITTEN AGAINST THE STOCK SCALE, SO MOVING A BOUNDARY RE-FLOWS ALL OF THEM SILENTLY AND NOTHING IN THE BUILD REPORTS IT. THE PROSE WAS WRONG, NOT THE SCALE. USE XL: FOR THE DESKTOP SWITCH AND MD: FOR THE MOBILE BOUNDARY.':
        'so|for|boundary.',
    'ASK FOR A MEASURE BY TOKEN — --WIDTH-PAGE, --WIDTH-CONTENT, --WIDTH-PROSE — NEVER BY NUMBER.':
        '--width-|number.',
    'DON\'T PUT A GLOW ON A RESTING SURFACE — GLOW MEANS SELECTED, RARE OR PREMIUM.':
        'or|premium.',
    'DON\'T LET A CARD AND ITS INNER INPUT SHARE THE SAME RADIUS; THE LADDER SHOULD READ.':
        'should|read.',
    'DON\'T WRITE A MEASURE AS AN ARBITRARY VALUE; IF THE TOKEN IS MISSING, ADD IT TO GLOBALS.CSS RATHER THAN WORKING AROUND IT.':
        'to|it.',
  },
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  final Map<String, String> routes = <String, String>{
    'overview': dsRoot,
    'colors': '$dsRoot/colors',
    'typography': '$dsRoot/typography',
    'spacing': '$dsRoot/spacing',
  };

  final bool dump = Platform.environment['WRAP_DUMP'] == '1';

  for (final MapEntry<String, String> entry in routes.entries) {
    testWidgets('${entry.key} breaks where the reference breaks', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = _viewport;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController theme = DsThemeController();
      final AppRouter router = AppRouter(route: entry.value);
      addTearDown(theme.dispose);
      addTearDown(router.dispose);

      final Widget page = pageFor(entry.value);
      await tester.pumpWidget(
        DsTheme(
          controller: theme,
          child: AppRouterScope(
            router: router,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: DocsShell(route: entry.value, child: page),
            ),
          ),
        ),
      );
      await tester.pump();

      final Map<String, String> reference = _referenceBreaks[entry.key]!;
      final Finder finder = find.byWidget(page);
      final Set<String> seen = <String>{};

      for (final _Para para in _paragraphs(tester.element(finder))) {
        final List<_Line> lines = _lines(para);
        final String text = _norm(_plain(para));
        if (dump) {
          // ignore: avoid_print
          print(
            'WRAP|${entry.key}|${lines.length}'
            '|${para.paragraph.constraints.maxWidth.toStringAsFixed(3)}'
            '|${para.paragraph.size.width.toStringAsFixed(3)}|$text',
          );
          for (int i = 0; i < lines.length; i++) {
            // ignore: avoid_print
            print(
              'WRAPLINE|${entry.key}|$i'
              '|${lines[i].width.toStringAsFixed(3)}|${lines[i].text}',
            );
          }
        }

        final String key = text.toUpperCase();
        seen.add(key);
        final String? expected = reference[key];
        final String actual = lines.map(_lastWord).join('|');

        if (expected == null) {
          expect(
            lines.length,
            lessThan(2),
            reason:
                'the reference sets "${_clip(text)}" on one line; '
                'this port wraps it as $actual',
          );
        } else {
          expect(
            actual,
            expected,
            reason:
                'the lines of "${_clip(text)}" end on different words '
                'than the reference\'s',
          );
        }
      }

      // The table is an inventory, so it has to be spent: a paragraph the
      // reference wraps and this port no longer renders at all would otherwise
      // pass every assertion above by never being looked at.
      expect(
        reference.keys.where((String key) => !seen.contains(key)),
        isEmpty,
        reason:
            'the reference wraps these paragraphs, and the page no longer '
            'renders them',
      );
    });
  }
}
