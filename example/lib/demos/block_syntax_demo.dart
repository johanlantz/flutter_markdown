// Copyright 2020 Quiverware LLC. Open source contribution. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import '../shared/markdown_demo_widget.dart';

// Markdown source data showing the use of subscript tags.
const String _data = """
## Subscript _Syntax_

sub1 this is a _subtitle_ 1

and this is more text
""";



class BlockSyntaxDemo extends StatelessWidget
    implements MarkdownDemoWidget {
  static const _title = 'Block Syntax Demo';

  @override
  String get title => BlockSyntaxDemo._title;

  @override
  String get description => 'An example of how to create a custom block '
      'syntax parser and element builder.';

  @override
  Future<String> get data => Future<String>.value(_data);

  @override
  Future<String> get notes => Future<String>.value("");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Markdown(
            data: snapshot.data,
            blockBuilders: {
              'sub1': Subtitle1Builder(context, WrapAlignment.center),
            }, 
            blockSyntaxes: [
              Subtitle1BlockSyntax()
            ]
            //extensionSet: md.ExtensionSet([Subtitle1BlockSyntax()], []),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class Subtitle1Builder extends MarkdownElementBuilder {
  final BuildContext context;
  final WrapAlignment textAlign;
  Subtitle1Builder(this.context, this.textAlign) : super();

  @override
  bool visitElementBefore(md.Element element) {
    return true;
  }

  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    return Wrap(
      alignment: textAlign,
      children: [
        Text(
          element.textContent,
          textAlign: TextAlign.center,
          style: preferredStyle,
        ),
      ],
    );
  }

  @override
  Widget visitText(md.Text text, TextStyle preferredStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text.text, style: preferredStyle),
      ],
    );
  }
}

class Subtitle1BlockSyntax extends md.BlockSyntax {
  Subtitle1BlockSyntax() : super();
  @override
  RegExp get pattern => RegExp(r'^[ ]{0,3}sub1[ ]?(.*)$');
  @override
  md.Node parse(md.BlockParser parser) {
    final childLines = parseChildLines(parser);
    final children = md.BlockParser(childLines, parser.document).parseLines();
    return md.Element('sub1', children);
  }
  
}
