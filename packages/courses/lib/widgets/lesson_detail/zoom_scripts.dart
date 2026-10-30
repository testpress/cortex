class ZoomScripts {
  static const String permissionBridge = '''
    (function() {
      if (!window.__tpClosePatched) {
        window.__tpClosePatched = true;
        var _origClose = window.close;
        window.close = function() {
          if (window.ZoomAutoJoin) {
            window.ZoomAutoJoin.postMessage('onMeetingLeft');
          }
          if (_origClose) {
            try { _origClose.call(window); } catch (_) {}
          }
        };
      }

      if (window.__tpGumPatched) return;
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) return;
      window.__tpGumPatched = true;

      var _origGetUserMedia = navigator.mediaDevices.getUserMedia.bind(navigator.mediaDevices);
      navigator.mediaDevices.getUserMedia = function(constraints) {
        return _origGetUserMedia(constraints).catch(function(err) {
          if (err.name === 'NotAllowedError' && window.ZoomPermissionChannel) {
            window.ZoomPermissionChannel.postMessage('onPermissionDenied');
          }
          return Promise.reject(err);
        });
      };
    })();
  ''';

  static const String touchOptimizations = '''
    (function () {
      try {
        var meta = document.querySelector('meta[name="viewport"]');
        if (!meta) {
          meta = document.createElement('meta');
          meta.name = 'viewport';
          document.head.appendChild(meta);
        }
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';

        var style = document.getElementById('tp-touch-styles');
        if (!style) {
          style = document.createElement('style');
          style.id = 'tp-touch-styles';
          style.innerHTML = [
            'html, body, button, [role="button"], a, .footer-button__button { touch-action: manipulation !important; -webkit-tap-highlight-color: transparent !important; }',
            '.tippy-box, [role="tooltip"], .tooltip, .popover, .zoom-tooltip, .tippy-popper { display: none !important; pointer-events: none !important; visibility: hidden !important; }',
            'button:focus, button:active, [role="button"]:focus, [role="button"]:active { outline: none !important; box-shadow: none !important; }',
            '@media (hover: none) { button:hover, [role="button"]:hover { outline: none !important; box-shadow: none !important; } }'
          ].join(' ');
          document.head.appendChild(style);
        }

        if (!window.__tpTouchOptimized) {
          window.__tpTouchOptimized = true;
          document.addEventListener('touchstart', function(e) {
            var btn = e.target && e.target.closest('button, [role="button"], .footer-button__button');
            if (btn && typeof btn.focus === 'function') {
              btn.focus();
            }
          }, { passive: true });
        }
      } catch (e) {
        // Non-fatal DOM tweak.
      }
    })();
  ''';

  static const String hideScrollbars = '''
    (function () {
      try {
        var style = document.getElementById('tp-hide-scrollbars');
        if (!style) {
          style = document.createElement('style');
          style.id = 'tp-hide-scrollbars';
          style.innerHTML = '*::-webkit-scrollbar { display: none !important; width: 0 !important; height: 0 !important; background: transparent !important; } * { scrollbar-width: none !important; -ms-overflow-style: none !important; }';
          document.head.appendChild(style);
        }
      } catch (e) {
        // Non-fatal DOM tweak.
      }
    })();
  ''';

  static const String autoJoinMeeting = '''
    (function() {
      var maxRetries = 20;
      var retries = 0;

      var checkExist = setInterval(function() {
        retries++;

        // GUARD: If the Zoom app-launch dialog is showing (user clicked "Join with app"),
        // do not auto-click anything — clicking "Join from browser" here causes a stutter loop.
        var allBtns = document.querySelectorAll('button');
        for (var i = 0; i < allBtns.length; i++) {
          var t = (allBtns[i].textContent || allBtns[i].innerText || '').toLowerCase();
          if (t.indexOf('zoom workplace app') > -1) {
            clearInterval(checkExist);
            return;
          }
        }

        // PHASE 0: Check if meeting room is active (video grid or controls loaded)
        var meetingApp = document.querySelector('#meeting-app') ||
                         document.querySelector('.meeting-app') ||
                         document.querySelector('.footer-button__button');
        if (meetingApp && meetingApp.offsetParent !== null) {
          clearInterval(checkExist);
          if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onMeetingDetected');
          return;
        }

        // PHASE 1: Join from your browser link on launcher page
        var joinBrowserLink = document.querySelector('a[href*="/wc/"]');
        if (joinBrowserLink && joinBrowserLink.offsetParent !== null) {
          joinBrowserLink.click();
          clearInterval(checkExist);
          if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onButtonClicked');
          return;
        }

        // PHASE 2: Join Audio / Computer Audio popup
        var joinAudioBtn = document.querySelector('button.join-audio-by-computer') ||
                           document.querySelector('[aria-label*="Join Audio"]') ||
                           document.querySelector('button[title*="Join Audio"]');
        if (joinAudioBtn && joinAudioBtn.offsetParent !== null) {
          joinAudioBtn.click();
          clearInterval(checkExist);
          if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onMeetingDetected');
          return;
        }

        // PHASE 3: Fallback button text
        var allButtons = document.querySelectorAll('button');
        for (var i = 0; i < allButtons.length; i++) {
          var text = (allButtons[i].textContent || allButtons[i].innerText || "").toLowerCase();
          if (text.indexOf('join from your browser') > -1 ||
              text.indexOf('join by computer') > -1) {
            allButtons[i].click();
            clearInterval(checkExist);
            if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onButtonClicked');
            return;
          }
        }

        if (retries >= maxRetries) {
          clearInterval(checkExist);
          if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onAutoJoinTimeout');
        }
      }, 500);
    })();
  ''';
}
