import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:core/core.dart';
import 'package:core/data/config/app_config.dart';
import 'package:core/data/auth/auth_local_data_source.dart';

/// A WebView-based viewer for HTML and Embedded lesson content.
class LessonWebView extends StatefulWidget {
  const LessonWebView({
    super.key,
    this.htmlContent,
    this.description,
    this.url,
    this.padding,
  }) : assert(htmlContent != null || url != null,
            'Either htmlContent or url must be provided');

  /// The raw HTML content or embed code to render.
  final String? htmlContent;

  /// Optional description to render below the content.
  final String? description;

  /// A direct URL to load in the WebView.
  final String? url;

  /// Optional padding around the webview.
  final EdgeInsets? padding;

  @override
  State<LessonWebView> createState() => _LessonWebViewState();
}

class _LessonWebViewState extends State<LessonWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onPageFinished: (url) {
            _applyInputFocusStabilityFix();
            _applyChatDomCompaction();
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
            // Block all subsequent navigations to ensure users stay
            // locked within the current lesson content.
            return NavigationDecision.prevent;
          },
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final design = Design.of(context);
    _controller.setBackgroundColor(design.colors.canvas);
    _loadContent(); // Load or reload with correct theme colors
  }

  @override
  void didUpdateWidget(LessonWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlContent != widget.htmlContent ||
        oldWidget.url != widget.url) {
      _loadContent();
    }
  }

  Future<void> _loadContent() async {
    if (widget.url != null) {
      final headers = <String, String>{};
      try {
        final uri = Uri.parse(widget.url!);
        final apiUri = Uri.parse(AppConfig.apiBaseUrl);
        if (uri.host == apiUri.host) {
          final token = await AuthLocalDataSource().getToken();
          if (token != null && token.isNotEmpty) {
            headers['Authorization'] = 'JWT $token';
          }
        }
      } catch (_) {
        // Fall back to unauthenticated request if secure storage read fails or URL is malformed.
      }

      _controller.loadRequest(Uri.parse(widget.url!), headers: headers);
      return;
    }

    final design = Design.of(context);
    // We use https://www.testpress.in as baseUrl to provide a valid HTTPS origin.
    // This fixes YouTube Error 153 where local file:// or null origins are blocked.
    const baseUrl = 'https://www.testpress.in';

    final textColor = _colorToHexString(design.colors.textPrimary);
    final backgroundColor = _colorToHexString(design.colors.canvas);

    // Wrap content with basic responsive CSS to ensure embeds fit the screen
    final styledHtml = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <style>
            body { 
              margin: 0; 
              padding: 0; 
              background-color: $backgroundColor; 
              color: $textColor;
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
              line-height: 1.6;
              font-size: 15px;
              -webkit-user-select: none;
              -webkit-touch-callout: none;
              overflow-x: hidden;
              word-wrap: break-word;
              overflow-wrap: break-word;
            }
            img, video { max-width: 100%; height: auto; }
            iframe { 
              width: 100% !important; 
              height: auto !important;
              aspect-ratio: 16 / 9 !important; 
              border: none; 
              border-radius: 8px;
            }
            .content-wrapper { padding: 16px; }
            p { margin-top: 0; margin-bottom: 12px; }
            a { color: ${_colorToHexString(design.colors.primary)}; text-decoration: none; }
          </style>
        </head>
        <body>
          <div class="content-wrapper">
            ${widget.htmlContent ?? ''}
            ${widget.description != null && widget.description!.isNotEmpty ? '<div style="margin-top: 16px;">${widget.description}</div>' : ''}
          </div>
        </body>
      </html>
    ''';

    _controller.loadHtmlString(styledHtml, baseUrl: baseUrl);
  }

  Future<void> _applyInputFocusStabilityFix() async {
    if (widget.url == null || !Platform.isIOS) return;

    const script = '''
      (function () {
        try {
          var viewport = document.querySelector('meta[name="viewport"]');
          if (!viewport) {
            viewport = document.createElement('meta');
            viewport.name = 'viewport';
            document.head.appendChild(viewport);
          }
          viewport.setAttribute(
            'content',
            'width=device-width, initial-scale=1, maximum-scale=1, viewport-fit=cover'
          );

          var style = document.getElementById('tp-ios-input-zoom-fix');
          if (!style) {
            style = document.createElement('style');
            style.id = 'tp-ios-input-zoom-fix';
            style.innerHTML = `
              input, textarea, select {
                font-size: 16px !important;
              }
            `;
            document.head.appendChild(style);
          }
        } catch (e) {}
      })();
    ''';

    try {
      await _controller.runJavaScript(script);
    } catch (_) {
      // Non-fatal: page may block script execution.
    }
  }

  Future<void> _applyChatDomCompaction() async {
    if (widget.url == null) return;

    const script = '''
      (function () {
        try {
          var style = document.getElementById('tp-chat-dom-compaction');
          if (!style) {
            style = document.createElement('style');
            style.id = 'tp-chat-dom-compaction';
            style.innerHTML = `
              html, body {
                margin: 0 !important;
                padding: 0 !important;
              }

              /* Keep composer compact so message history gets more room */
              textarea,
              input[type="text"] {
                font-size: 16px !important;
              }

              textarea {
                min-height: 44px !important;
                max-height: 96px !important;
              }

              form {
                margin: 0 !important;
              }

              /* Trim oversized section spacing frequently used in embeds */
              .container,
              .content,
              .chat-container,
              .chat-wrapper,
              .live-chat,
              main {
                padding-top: 0 !important;
                margin-top: 0 !important;
              }
            `;
            document.head.appendChild(style);
          }
        } catch (e) {}
      })();
    ''';

    try {
      await _controller.runJavaScript(script);
    } catch (_) {
      // Non-fatal if the host page blocks runtime styling.
    }
  }

  String _colorToHexString(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: WebViewWidget(controller: _controller),
    );
  }
}
