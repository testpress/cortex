import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:core/core.dart';
import 'package:core/data/auth/auth_local_data_source.dart';

/// A WebView-based viewer for HTML and Embedded lesson content.
class LessonWebView extends StatefulWidget {
  const LessonWebView({
    super.key,
    this.htmlContent,
    this.url,
    this.padding,
  }) : assert(htmlContent != null || url != null, 'Either htmlContent or url must be provided');

  /// The raw HTML content or embed code to render.
  final String? htmlContent;

  /// A direct URL to load in the WebView.
  final String? url;

  /// Optional padding around the webview.
  final EdgeInsets? padding;

  @override
  State<LessonWebView> createState() => _LessonWebViewState();
}

class _LessonWebViewState extends State<LessonWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _showLoader = false;

  static const List<String> _whitelistedUrlPatterns = [
    'about:blank',
    'testpress.in',
    'youtube.com/embed/',
    'player.vimeo.com/video/',
    'data:',
  ];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
            // Wait 250ms before showing the loader to avoid flickering on fast renders
            Future.delayed(const Duration(milliseconds: 250), () {
              if (mounted && _isLoading) {
                setState(() => _showLoader = true);
              }
            });
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _showLoader = false;
              });
            }
            _applyInputFocusStabilityFix();
            _applyChatDomCompaction();
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
            // URL-mode is used for hosted embeds (like live chat) that may
            // redirect across multiple allowed domains during load.
            if (widget.url != null) {
              return NavigationDecision.navigate;
            }

            final url = request.url;
            
            final isWhitelisted = _whitelistedUrlPatterns.any(
              (pattern) => url.contains(pattern),
            );

            if (isWhitelisted) {
              return NavigationDecision.navigate;
            }
            
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
    if (oldWidget.htmlContent != widget.htmlContent || oldWidget.url != widget.url) {
      _loadContent();
    }
  }

  Future<void> _loadContent() async {
    if (widget.url != null) {
      final headers = <String, String>{};
      try {
        final token = await AuthLocalDataSource().getToken();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'JWT $token';
        }
      } catch (_) {
        // Fall back to unauthenticated request if secure storage read fails.
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
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { 
              margin: 0; 
              padding: 0; 
              background-color: $backgroundColor; 
              color: $textColor;
              font-family: sans-serif;
            }
            iframe, video, img { max-width: 100%; height: auto; }
            .content-wrapper { padding: 16px; }
            a { color: ${_colorToHexString(design.colors.primary)}; }
          </style>
        </head>
        <body>
          <div class="content-wrapper">
            ${widget.htmlContent ?? ''}
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
    return Stack(
      children: [
        Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: WebViewWidget(controller: _controller),
        ),
        if (_showLoader)
          const Center(
            child: AppLoadingIndicator(),
          ),
      ],
    );
  }
}
