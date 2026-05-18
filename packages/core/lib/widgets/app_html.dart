import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../design/design_provider.dart';
import 'app_loading_indicator.dart';

/// A premium HTML renderer for the Cortex SDK.
/// 
/// Uses a WebView to ensure perfect rendering of complex HTML, 
/// including MathJax, Tables, and Custom Styles used in Testpress.
class AppHtml extends StatefulWidget {
  const AppHtml({
    super.key,
    required this.data,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16,
    this.padding = EdgeInsets.zero,
    this.onHeightChanged,
    this.onMessage,
  });

  /// The HTML content to render.
  final String data;

  /// Optional background color. Defaults to transparent.
  final Color? backgroundColor;

  /// Optional text color. Defaults to design.colors.textPrimary.
  final Color? textColor;

  /// Base font size in pixels.
  final double fontSize;

  /// Padding around the content.
  final EdgeInsets padding;

  /// Optional callback when the height of the content changes.
  final void Function(double)? onHeightChanged;

  /// Optional callback for receiving messages from JavaScript.
  final void Function(String)? onMessage;

  @override
  State<AppHtml> createState() => _AppHtmlState();
}

class _AppHtmlState extends State<AppHtml> {
  late final WebViewController _controller;
  double _height = 0.0;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final Map<String, dynamic> data = jsonDecode(message.message) as Map<String, dynamic>;
            final double? height = double.tryParse(data['height']?.toString() ?? '');
            final bool ready = data['ready'] == true || _isReady;

            if (height != null && mounted) {
              setState(() {
                _height = height;
                _isReady = ready;
              });
              widget.onHeightChanged?.call(height);
            }
          } catch (_) {
            // Safe fallback for legacy or plain-string messages
            final double? height = double.tryParse(message.message);
            if (height != null && mounted) {
              setState(() {
                _height = height;
              });
              widget.onHeightChanged?.call(height);
            }
          }
        },
      )
      ..addJavaScriptChannel(
        'MessageChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (mounted) {
            widget.onMessage?.call(message.message);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controller.runJavaScript('sendHeight();');
          },
        ),
      );
  }

  Future<void> _updateHeight() async {
    try {
      final heightStr = await _controller.runJavaScriptReturningResult(
        'document.documentElement.scrollHeight.toString()'
      );
      final height = double.tryParse(heightStr.toString().replaceAll('"', '')) ?? 0;
      if (height > 0 && mounted) {
        setState(() {
          _height = height;
          _isReady = true;
        });
        widget.onHeightChanged?.call(height);
      }
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHtml();
  }

  @override
  void didUpdateWidget(AppHtml oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data || 
        oldWidget.textColor != widget.textColor ||
        oldWidget.backgroundColor != widget.backgroundColor) {
      _loadHtml();
    }
  }

  void _loadHtml() {
    final design = Design.of(context);
    final bgColor = widget.backgroundColor;
    final txtColor = widget.textColor ?? design.colors.textPrimary;
    
    final bgCss = bgColor == null || bgColor.a == 0 
        ? 'transparent' 
        : _colorToRgba(bgColor);
    final txCss = _colorToRgba(txtColor);

    final html = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <script>
            function signalReady() {
              if (window._isSignaled) return;
              window._isSignaled = true;
              if (window.HeightChannel) {
                window.HeightChannel.postMessage("ready:" + document.getElementById('content').offsetHeight);
              }
            }

            // Safety fallback: if MathJax takes too long or fails to load, signal ready anyway
            setTimeout(signalReady, 1000);

            window.MathJax = {
              startup: {
                pageReady: () => {
                  return MathJax.startup.defaultPageReady().then(signalReady);
                }
              }
            };
          </script>
          <style>
            body {
              margin: 0;
              padding: 0;
              background-color: $bgCss;
              color: $txCss;
              font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
              font-size: ${widget.fontSize}px;
              line-height: 1.5;
              overflow: hidden;
            }
            p, span, div, font, h1, h2, h3, h4, h5, h6 {
              color: $txCss !important;
            }
            #content {
              padding: 4px 0;
              display: inline-block;
              width: 100%;
            }
            #content > *:first-child {
              margin-top: 0 !important;
            }
            #content > *:last-child {
              margin-bottom: 0 !important;
            }
            img, iframe, table {
              max-width: 100% !important;
              height: auto !important;
            }
            table {
              border-collapse: collapse;
              width: 100%;
              margin: 8px 0;
            }
            td, th {
              border: 1px solid ${txCss};
              padding: 6px;
            }
          </style>
          <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" async></script>
        </head>
        <body>
          <div id="content">
            ${widget.data.trim()}
          </div>
          <script>
            function cleanTrailingEmptyNodes(container) {
              if (!container) return;
              let last = container.lastElementChild;
              while (last && last.textContent.trim() === '' && !last.querySelector('img, iframe, math, svg')) {
                last.remove();
                last = container.lastElementChild;
              }
            }

            function cleanAll() {
              cleanTrailingEmptyNodes(document.getElementById('content'));
              document.querySelectorAll('.option-text').forEach(cleanTrailingEmptyNodes);
            }

            function signalReady() {
              if (window._isSignaled) return;
              window._isSignaled = true;
              cleanAll();
              if (window.HeightChannel) {
                window.HeightChannel.postMessage(JSON.stringify({
                  ready: true,
                  height: document.getElementById('content').offsetHeight
                }));
              }
            }

            // Safety fallback: if MathJax takes too long or fails to load, signal ready anyway
            setTimeout(signalReady, 1000);

            window.MathJax = {
              startup: {
                pageReady: () => {
                  return MathJax.startup.defaultPageReady().then(signalReady);
                }
              }
            };

            function sendHeight() {
              const height = document.getElementById('content').offsetHeight;
              if (window.HeightChannel) {
                window.HeightChannel.postMessage(JSON.stringify({
                  ready: false,
                  height: height
                }));
              }
            }

            // Observe content changes (like image loads) to update height
            const resizeObserver = new ResizeObserver(entries => {
              sendHeight();
            });
            resizeObserver.observe(document.getElementById('content'));

            // Initial height check
            window.onload = sendHeight;
          </script>
        </body>
      </html>
    ''';

    _controller.loadHtmlString(html, baseUrl: 'https://testpress.in/');
  }

  String _colorToRgba(Color color) {
    return 'rgba(${color.r * 255}, ${color.g * 255}, ${color.b * 255}, ${color.a})';
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final double h = _height == 0 ? 300 : _height;
    
    return SizedBox(
      height: h,
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: _isReady ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
            child: WebViewWidget(controller: _controller),
          ),
          if (!_isReady)
            Positioned.fill(
              child: Container(
                color: design.colors.card,
                child: Center(
                  child: AppLoadingIndicator(
                    color: design.colors.primary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
