import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:macos_ui/macos_ui.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:my_gpt_client/chat/presentation/views/macos_highlight_view.dart';
import 'package:my_gpt_client/view/widgets/macos_activity_indicator.dart';

import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';

import '../../../core/entities/chat_role.dart';
import '../../../view/widgets/selection_transformer.dart';
import '../view_models/chat_content_view_model.dart';

class ChatMessageBox extends StatefulWidget {
  final ChatMessageViewModel message;

  const ChatMessageBox({required this.message, super.key});

  @override
  State<ChatMessageBox> createState() => _ChatMessageBoxState();
}

class _ChatMessageBoxState extends State<ChatMessageBox> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: (widget.message.role == ChatRole.user)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      widthFactor: 0.9,
      child: Align(
        alignment: (widget.message.role == ChatRole.user)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: _messageColor(),
          ),
          child: (widget.message.message.isNotEmpty)
              ? SelectableRegion(
                  focusNode: _focusNode,
                  selectionControls: emptyTextSelectionControls,
                  child: SelectionTransformer.separated(
                    child: MarkdownBody(
                      data: widget.message.message,
                      styleSheet: _getMarkdownStyleSheet(),
                      imageBuilder: (uri, title, alt) => Text(
                        '![$alt](${uri.path})',
                        style: MacosTheme.of(context).typography.body.copyWith(
                              color: (widget.message.role == ChatRole.user)
                                  ? MacosColors.white
                                  : null,
                            ),
                      ),
                      onSelectionChanged: (text, selection, cause) {},
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          await Clipboard.setData(ClipboardData(text: href));
                        }
                      },
                      builders: {
                        'code': CodeBuilder(),
                        // 'latex': RichtTextLatexBuilder(
                        //   textStyle: MacosTheme.of(context).typography.body,
                        // ),
                      },
                      // extensionSet: md.ExtensionSet(
                      //   [LatexBlockSyntax()],
                      //   [],
                      // ),
                    ),
                  ),
                )
              : const MacosActivityIndicator(),
        ),
      ),
    );
  }

  Color _messageColor() => switch (widget.message.role) {
        ChatRole.user => MacosColors.systemBlueColor,
        ChatRole.model =>
          (MacosTheme.of(context).brightness == Brightness.light)
              ? CupertinoColors.systemFill
              : MacosColors.unemphasizedSelectedContentBackgroundColor,
        ChatRole.system => const Color(0x00000000),
      };

  MarkdownStyleSheet _getMarkdownStyleSheet() {
    final defaultTextStyle = MacosTheme.of(context).typography.body.copyWith(
          color:
              (widget.message.role == ChatRole.user) ? MacosColors.white : null,
        );
    final brightness = MacosTheme.of(context).brightness;
    final primaryColor = MacosTheme.of(context).primaryColor;

    return MarkdownStyleSheet(
      a: defaultTextStyle.copyWith(
        color: brightness == Brightness.dark
            ? CupertinoColors.link.darkColor
            : CupertinoColors.link.color,
      ),
      p: defaultTextStyle,
      pPadding: EdgeInsets.zero,
      h1: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: defaultTextStyle.fontSize! + 10,
      ),
      h1Padding: EdgeInsets.zero,
      h2: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: defaultTextStyle.fontSize! + 8,
      ),
      h2Padding: EdgeInsets.zero,
      h3: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: defaultTextStyle.fontSize! + 6,
      ),
      h3Padding: EdgeInsets.zero,
      h4: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: defaultTextStyle.fontSize! + 4,
      ),
      h4Padding: EdgeInsets.zero,
      h5: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: defaultTextStyle.fontSize! + 2,
      ),
      h5Padding: EdgeInsets.zero,
      h6: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w500,
      ),
      h6Padding: EdgeInsets.zero,
      em: defaultTextStyle.copyWith(
        fontStyle: FontStyle.italic,
      ),
      strong: defaultTextStyle.copyWith(
        fontWeight: FontWeight.bold,
      ),
      del: defaultTextStyle.copyWith(
        decoration: TextDecoration.lineThrough,
      ),
      blockquote: defaultTextStyle,
      img: defaultTextStyle,
      checkbox: defaultTextStyle.copyWith(
        color: primaryColor,
      ),
      blockSpacing: (defaultTextStyle.fontSize ?? 16.0) *
          (defaultTextStyle.height ?? 1.0),
      listIndent: 24,
      listBullet: defaultTextStyle,
      listBulletPadding: const EdgeInsets.only(right: 4),
      tableHead: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w600,
      ),
      tableBody: defaultTextStyle,
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(
        borderRadius: BorderRadius.circular(2.5),
        color: widget.message.role != ChatRole.user
            ? ((brightness == Brightness.dark)
                ? CupertinoColors.white
                : CupertinoColors.separator.color)
            : MacosColors.white,
        width: 0.75,
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: BoxDecoration(
        color: widget.message.role != ChatRole.user
            ? (brightness == Brightness.dark)
                ? CupertinoColors.systemGrey6.darkColor
                : CupertinoColors.systemGrey6.color
            : null,
      ),
      blockquotePadding: const EdgeInsets.all(8.0),
      blockquoteDecoration: BoxDecoration(
        color: widget.message.role != ChatRole.user
            ? (brightness == Brightness.dark)
                ? CupertinoColors.systemGrey6.darkColor
                : CupertinoColors.systemGrey6.color
            : null,
        borderRadius: BorderRadius.circular(5.0),
        border: Border(
          left: BorderSide(
            color: brightness == Brightness.dark
                ? CupertinoColors.systemGrey4.darkColor
                : CupertinoColors.systemGrey4.color,
            width: 4,
          ),
        ),
      ),
      codeblockDecoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6.color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: brightness == Brightness.dark
                ? CupertinoColors.systemGrey4.darkColor
                : CupertinoColors.systemGrey4.color,
          ),
        ),
      ),
    );
  }
}

final class CodeBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(BuildContext context, md.Element element,
      TextStyle? preferredStyle, TextStyle? parentStyle) {
    var language = 'dart';
    final isInline = !element.textContent.contains('\n');

    if (element.attributes['class'] != null) {
      var lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: CodeBuilderWidget(
              element: element,
              language: language,
              isInline: isInline,
            ),
          ),
        ],
      ),
    );
  }
}

class CodeBuilderWidget extends StatefulWidget {
  final md.Element element;
  final String language;
  final bool isInline;

  const CodeBuilderWidget({
    required this.element,
    required this.language,
    this.isInline = false,
    super.key,
  });

  @override
  State<CodeBuilderWidget> createState() => _CodeBuilderWidgetState();
}

class _CodeBuilderWidgetState extends State<CodeBuilderWidget> {
  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = MacosTheme.of(context).typography.body;
    final isLight = MacosTheme.of(context).brightness == Brightness.light;
    final content = widget.element.textContent.trim();

    if (widget.isInline) {
      //  return Container(
      //         height: (defaultTextStyle.fontSize ?? 16.0) *
      //                 (defaultTextStyle.height ?? 1.0) +
      //             2.5,
      //         color: isLight
      //             ? atomOneLightTheme['root']?.backgroundColor
      //             : atomOneDarkTheme['root']?.backgroundColor,
      //         padding: const EdgeInsets.symmetric(horizontal: 5.0),
      //         child: Text(
      //           content,
      //           style: defaultTextStyle.copyWith(
      //               fontFamily: 'Menlo',
      //               height: 1.2,
      //               fontSize: (defaultTextStyle.fontSize ?? 16.0) * 0.85),
      //         ),
      //       );
      return Text.rich(
        TextSpan(text: content),
        style: defaultTextStyle.copyWith(
          fontFamily: 'Menlo',
          height: 1.2,
          fontSize: (defaultTextStyle.fontSize ?? 16.0),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.isInline ? 2.0 : 5.0),
      clipBehavior: Clip.antiAlias,
      child: MacosHighlightView(
        content,

        language: widget.language,
        // // Specify padding
        padding: const EdgeInsets.all(8.0),

        /*
            anOldHope
            androidStudio
            gruvboxDarkTheme
            obsidianTheme
          */

        theme: isLight ? atomOneLightTheme : atomOneDarkTheme,

        textStyle: defaultTextStyle.copyWith(
          fontFamily: 'Menlo',
        ),
      ),
    );
  }
}

// final class RichtTextLatexBuilder extends LatexElementBuilder {
//   RichtTextLatexBuilder({
//     super.textStyle,
//     super.textScaleFactor,
//   });

//   @override
//   Widget visitElementAfterWithContext(BuildContext context, md.Element element,
//       TextStyle? preferredStyle, TextStyle? parentStyle) {
//     return Text.rich(
//       TextSpan(
//         children: [
//           WidgetSpan(
//             baseline: TextBaseline.alphabetic,
//             alignment: PlaceholderAlignment.baseline,
//             child: super.visitElementAfterWithContext(
//                 context, element, preferredStyle, parentStyle),
//           )
//         ],
//       ),
//     );
//   }
// }
