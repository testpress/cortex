import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../design/design_provider.dart';

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

  @override
  State<AppHtml> createState() => _AppHtmlState();
}

class _AppHtmlState extends State<AppHtml> {
  late final WebViewController _controller;
  double _height = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final double? height = double.tryParse(message.message);
          if (height != null && mounted) {
            setState(() => _height = height);
            widget.onHeightChanged?.call(height);
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
              padding: 2px 0;
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
            function cleanTrailingEmptyNodes() {
              const content = document.getElementById('content');
              let last = content.lastElementChild;
              while (last && last.textContent.trim() === '' && !last.querySelector('img') && !last.querySelector('iframe') && !last.querySelector('math')) {
                last.remove();
                last = content.lastElementChild;
              }
            }

            function sendHeight() {
              const height = document.getElementById('content').offsetHeight;
              if (window.HeightChannel) {
                HeightChannel.postMessage(height.toString());
              }
            }

            // Clean up any empty trailing <p> tags from the CMS before measuring
            cleanTrailingEmptyNodes();

            // Observe content changes (like image loads) to update height
            const resizeObserver = new ResizeObserver(entries => {
              sendHeight();
            });
            resizeObserver.observe(document.getElementById('content'));

            window.onload = sendHeight;
          </script>
        </body>
      </html>
    ''';

    _controller.loadHtmlString(html);
  }

  String _colorToRgba(Color color) {
    return 'rgba(${color.r * 255}, ${color.g * 255}, ${color.b * 255}, ${color.a})';
  }

  @override
  Widget build(BuildContext context) {
    // Start with a reasonable minimum height to prevent flickering
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 20),
      child: SizedBox(
        height: _height < 20 ? 20 : _height,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
