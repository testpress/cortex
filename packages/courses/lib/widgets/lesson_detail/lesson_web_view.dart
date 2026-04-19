import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:core/core.dart';

/// A WebView-based viewer for HTML and Embedded lesson content.
class LessonWebView extends StatefulWidget {
  const LessonWebView({
    super.key,
    required this.htmlContent,
    this.padding,
  });

  /// The raw HTML content or embed code to render.
  final String htmlContent;

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
    'https://www.testpress.in',
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
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
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
    if (oldWidget.htmlContent != widget.htmlContent) {
      _loadContent();
    }
  }

  void _loadContent() {
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
            ${widget.htmlContent}
          </div>
        </body>
      </html>
    ''';

    _controller.loadHtmlString(styledHtml, baseUrl: baseUrl);
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
