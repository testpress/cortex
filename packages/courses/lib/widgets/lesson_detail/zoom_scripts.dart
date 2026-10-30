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
        meta.content = 'width=device-width, initial-scale=1.0';

        var style = document.getElementById('tp-touch-styles');
        if (!style) {
          style = document.createElement('style');
          style.id = 'tp-touch-styles';
          style.innerHTML = [
            'html, body, button, [role="button"], a, .footer-button__button { touch-action: manipulation !important; -webkit-tap-highlight-color: transparent !important; }',
            'html, body { -webkit-user-select: none !important; user-select: none !important; }',
            '@media (hover: none) { .tippy-box, [role="tooltip"], .tooltip, .popover, .zoom-tooltip, .tippy-popper { display: none !important; pointer-events: none !important; visibility: hidden !important; } }',
            'button[aria-label*="Meeting Information" i], button[aria-label*="Meeting Info" i], .meeting-info-icon, [class*="meeting-info-icon"] { display: none !important; pointer-events: none !important; }',
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

  static const String blockUpsells = '''
    (function () {
      if (window.__tpBlockerInstalled) return;
      window.__tpBlockerInstalled = true;

      var BLOCKED = [
        'send report', 'report a problem', 'report problem',
        'download zoom', 'download the app', 'get the app',
        'install zoom', 'app store', 'google play',
        'request remote control', 'remote control',
        'launching zoom', 'download now', 'try joining again',
        'meeting information', 'invite link'
      ];

      function matches(text) {
        text = (text || '').toLowerCase();
        for (var i = 0; i < BLOCKED.length; i++) {
          if (text.indexOf(BLOCKED[i]) > -1) return true;
        }
        return false;
      }

      // 1. Swallow clicks on trigger buttons before Zoom's handlers run.
      function interceptClick(e) {
        var el = e.target && e.target.closest &&
          e.target.closest('button, a, [role="button"], [role="menuitem"], span');
        if (!el) return;
        var label = (el.textContent || '') + ' ' + (el.getAttribute('aria-label') || '');
        if (matches(label)) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
      }
      document.addEventListener('click', interceptClick, true);
      document.addEventListener('touchend', interceptClick, true);

      // 2. Fallback: hide any dialog that still opens with blocked text.
      var obs = new MutationObserver(function () {
        var dialogs = document.querySelectorAll('[role="dialog"], [role="alertdialog"], .zm-modal, .ReactModal__Content');
        dialogs.forEach(function (d) {
          if (d.__tpHidden) return;
          if (matches(d.textContent)) {
            d.__tpHidden = true;
            d.style.setProperty('display', 'none', 'important');
            var mask = document.querySelector('.zm-modal-mask, .ReactModal__Overlay, [class*="modal-mask"]');
            if (mask) mask.style.setProperty('display', 'none', 'important');
            var closeBtn = d.querySelector('button[aria-label*="close" i], button.close, [class*="close"]');
            if (closeBtn && typeof closeBtn.click === 'function') {
              try { closeBtn.click(); } catch (_) {}
            }
          }
        });

        // Hide Remote Control in the View Options dropdown
        var menuItems = document.querySelectorAll('[role="menuitem"]');
        for (var m = 0; m < menuItems.length; m++) {
          var mText = (menuItems[m].textContent || '').toLowerCase();
          if (mText.indexOf('remote control') > -1) {
            menuItems[m].style.setProperty('display', 'none', 'important');
          }
        }
      });
      obs.observe(document.documentElement, { childList: true, subtree: true });
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
