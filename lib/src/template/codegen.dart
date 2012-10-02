// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/** Collects common snippets of generated code. */
library codegen;

import 'info.dart';

/** Header with common imports, used in every generated .dart file. */
String header(String filename, String libraryName) => """
// Auto-generated from $filename.
// DO NOT EDIT.

library $libraryName;

import 'dart:html';
import 'package:web_components/watcher.dart';
""";

/** The code in .dart files generated for a web component. */
// TODO(sigmund): omit [_root] if the user already defined it.
String componentCode(
    String className,
    String extraFields,
    String createdBody,
    String insertedBody,
    String removedBody) => """
  /** Autogenerated from the template. */

  /**
   * Shadow root for this component. We use 'var' to allow simulating shadow DOM
   * on browsers that don't support this feature.
   */
  var _root;
$extraFields

  $className.forElement(e) : super.forElement(e) {
     _root = createShadowRoot();
  }

  void created_autogenerated() {
$createdBody
    // Call user-defined created();
    created();
  }

  void inserted_autogenerated() {
$insertedBody
    // Call user-defined inserted();
    inserted();
  }

  void removed_autogenerated() {
    // Call user-defined removed();
    removed();

$removedBody
  }

  /** Original code from the component. */
""";

// TODO(jmesserly): is raw triple quote enough to escape the HTML?
/** The code in the main.html.dart generated file. */
String mainDartCode(
    FileInfo info,
    String topLevelFields,
    String fieldInitializers,
    String modelBinding,
    String initialPage) => """
${header(info.filename, info.libraryName)}

${importList(info.imports.getKeys())}

${info.userCode}

/** Generated code. */
$topLevelFields

/** Create the views and bind them to models. */
void init() {
  // Create view.
  var _root = new DocumentFragment.html(_INITIAL_PAGE);

  // Initialize fields.
$fieldInitializers
  // Attach model to views.
$modelBinding

  // Attach view to the document.
  document.body.nodes.add(_root);
}

final String _INITIAL_PAGE = r'''
  $initialPage
''';
""";

/** Generate text for a list of imports. */
String importList(List<String> imports) =>
  Strings.join(imports.map((url) => "import '$url';"), '\n');

/** Generate text for a list of export. */
// TODO(sigmund): uncomment exports below (issue #58)
String exportList(List<String> exports) =>
  Strings.join(exports.map((url) => "// export '$url';"), '\n');
