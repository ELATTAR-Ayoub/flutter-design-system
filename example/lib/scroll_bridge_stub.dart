/// The non-web half of [scroll_bridge.dart]: see that library for the why.
///
/// There is no `window` to hang anything on, and every widget test in this
/// package mounts `DocsShell` on the VM, so this has to exist and has to do
/// nothing.
library;

import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

/// No-op off the web. The signature is the contract; the behaviour is not.
void elInstallScrollBridge(ScrollController controller) {}
