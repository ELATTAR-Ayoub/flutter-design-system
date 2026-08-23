/// The non-web half of [scroll_bridge.dart]: see that library for the why.
///
/// There is no `window` to hang anything on, and every widget test in this
/// package mounts `DocsShell` on the VM, so this has to exist and has to do
/// nothing.
library;

import 'package:flutter/widgets.dart';

/// No-op off the web. The signature is the contract; the behaviour is not.
void dsInstallScrollBridge(ScrollController controller) {}
