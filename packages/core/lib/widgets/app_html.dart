import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import 'app_loading_indicator.dart';

/// Controller for [AppHtml] that allows callers to inject JavaScript into
/// the underlying WebView without triggering a full page reload.
///
/// Obtain an instance, pass it to [AppHtml.controller], then call
/// [runJavaScript] at any time after the widget is built.
class AppHtmlController {
  Future<void> Function(String js)? _runner;

  /// Evaluates [js] inside the WebView. Safe to call before the WebView is
  /// ready — the call is silently dropped if the WebView is not yet attached.
  Future<void> runJavaScript(String js) async {
    await _runner?.call(js);
  }
}

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
    this.placeholder,
    this.onHeightChanged,
    this.onMessage,
    this.controller,
    this.onPageFinished,
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

  /// Optional placeholder to render while measuring height.
  /// This helps prevent layout jumps by providing an accurate initial height.
  final Widget? placeholder;

  /// Optional callback when the height of the content changes.
  final void Function(double)? onHeightChanged;

  /// Optional callback for receiving messages from JavaScript.
  final void Function(String)? onMessage;

  /// Optional controller for injecting JavaScript into the WebView.
  final AppHtmlController? controller;

  /// Optional callback when the page finishes loading.
  final void Function()? onPageFinished;

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
    _setupController();
    widget.controller?._runner = (js) => _controller.runJavaScript(js);
  }

  @override
  void didUpdateWidget(AppHtml oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._runner = null;
      widget.controller?._runner = (js) => _controller.runJavaScript(js);
    }
    if (oldWidget.data != widget.data ||
        oldWidget.textColor != widget.textColor ||
        oldWidget.backgroundColor != widget.backgroundColor) {
      _loadHtml();
    }
  }

  @override
  void dispose() {
    widget.controller?._runner = null;
    super.dispose();
  }

  void _setupController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final Map<String, dynamic> data =
                jsonDecode(message.message) as Map<String, dynamic>;
            final double? height = double.tryParse(
              data['height']?.toString() ?? '',
            );
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
      ..addJavaScriptChannel(
        'ImageClickChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (mounted) {
            _showZoomableImage(context, message.message);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controller.runJavaScript('sendHeight();');
            widget.onPageFinished?.call();
          },
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHtml();
  }

  void _loadHtml() {
    final design = Design.of(context);
    final bgColor = widget.backgroundColor;
    final txtColor = widget.textColor ?? design.colors.textPrimary;

    final bgCss = bgColor == null || bgColor.a == 0
        ? 'transparent'
        : _colorToRgba(bgColor);
    final txCss = _colorToRgba(txtColor);

    final html =
        '''
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
            /* Reset MS Word default margins and paddings to prevent white spaces around */
            p.MsoNormal, p.MsoListParagraph, p.MsoListParagraphCxSpFirst, p.MsoListParagraphCxSpMiddle, p.MsoListParagraphCxSpLast {
              margin: 0 0 8px 0 !important;
              padding: 0 !important;
            }
            #content {
              padding: 0;
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
              border: 1px solid $txCss;
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
            function removeEmptyNodes(container) {
              if (!container) return;
              const elements = container.querySelectorAll('p, div, span');
              elements.forEach(el => {
                // Do not remove custom option selection indicators, their descendants, or their parent wrappers
                if (el.closest('.indicator') || el.classList.contains('indicator') || el.querySelector('.indicator')) {
                  return;
                }
                const text = el.textContent.replace(/\u00a0/g, ' ').trim();
                if (text === '' && !el.querySelector('img, iframe, math, svg, table, input, textarea')) {
                  el.remove();
                }
              });
            }

            function cleanTrailingEmptyNodes(container) {
              if (!container) return;
              let last = container.lastElementChild;
              while (last && last.textContent.trim() === '' && !last.querySelector('img, iframe, math, svg, input, textarea')) {
                last.remove();
                last = container.lastElementChild;
              }
            }

            function setupImageClickHandlers() {
              document.querySelectorAll('img').forEach(img => {
                if (img.dataset.clickedSetup) return;
                img.dataset.clickedSetup = "true";
                img.style.cursor = 'pointer';
                img.onclick = function(e) {
                  e.preventDefault();
                  e.stopPropagation();
                  if (window.ImageClickChannel) {
                    window.ImageClickChannel.postMessage(img.src);
                  }
                };
              });
            }

            function cleanAll() {
              removeEmptyNodes(document.getElementById('content'));
              cleanTrailingEmptyNodes(document.getElementById('content'));
              document.querySelectorAll('.option-text').forEach(el => {
                removeEmptyNodes(el);
                cleanTrailingEmptyNodes(el);
              });
              setupImageClickHandlers();
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
              setupImageClickHandlers();
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
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          // 1. Placeholder dictates height while loading
          if (!_isReady && widget.placeholder != null) widget.placeholder!,

          // 2. The actual WebView
          if (_isReady)
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: SizedBox(
                height: _height,
                child: WebViewWidget(controller: _controller),
              ),
            )
          else
            // Render invisibly to allow JS measurement
            Opacity(
              opacity: 0.0,
              child: SizedBox(
                height: 1,
                child: WebViewWidget(controller: _controller),
              ),
            ),
        ],
      ),
    );
  }

  void _showZoomableImage(BuildContext context, String imageUrl) {
    final design = Design.of(context);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: design.colors.overlay.withValues(alpha: 0.8),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _ZoomableImageViewer(imageUrl: imageUrl, design: design),
          );
        },
      ),
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({required this.imageUrl, required this.design});

  final String imageUrl;
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: design.colors.transparent, // Transparent to catch tap
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 5.0,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: AppLoadingIndicator(
                            color: design.colors.primary.withValues(alpha: 0.5),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: design.colors.textInverse,
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: design.colors.onPrimary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      color: design.colors.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
