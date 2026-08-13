import 'package:flutter/widgets.dart';

/// Temporary placeholder app — replaced in Task 6 by the real docs shell
/// (`DocsShell` + routing + nav tree). It exists so the example target builds
/// and the token guard has an `example/lib` tree to scan.
void main() => runApp(const DocsApp());

class DocsApp extends StatelessWidget {
  const DocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Color(0xFF0A0A0B), // allow-hardcoded: scaffold placeholder, dies in Task 6
        child: DefaultTextStyle(
          style: TextStyle(color: Color(0xFFFAFAFA)), // allow-hardcoded: ditto
          child: Center(child: Text("Elattar's Design System")),
        ),
      ),
    );
  }
}
