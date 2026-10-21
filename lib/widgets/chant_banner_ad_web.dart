import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Same Google publisher as the Naam Jap app (`web/app-ads.txt`).
const chantAdClient = 'ca-pub-2593285195088254';

/// AdSense display unit for this banner. AdMob units from the mobile app
/// do not serve on the website, so this stays a normal display slot.
const chantAdSlot = '';

const _bannerWidth = 320.0;
const _bannerHeight = 50.0;

/// Fixed banner under the Done button. It stays in the page flow, so taps
/// on the mala never land on the ad.
class ChantBannerAd extends StatefulWidget {
  const ChantBannerAd({super.key});

  @override
  State<ChantBannerAd> createState() => _ChantBannerAdState();
}

class _ChantBannerAdState extends State<ChantBannerAd> {
  static bool _scriptRequested = false;

  var _collapsed = false;
  var _requested = false;
  var _stableTicks = 0;
  web.HTMLElement? _slot;
  Timer? _attachTimer;
  Timer? _statusTimer;
  web.ResizeObserver? _observer;

  @override
  void initState() {
    super.initState();
    // Start the script with no ad tag in the page yet, so it cannot
    // measure a zero-size slot before the banner is placed.
    _ensureScript();
  }

  @override
  void dispose() {
    _attachTimer?.cancel();
    _statusTimer?.cancel();
    _observer?.disconnect();
    _slot?.remove();
    super.dispose();
  }

  void _onElementCreated(Object element) {
    final host = element as web.HTMLElement;
    host.style
      ..display = 'block'
      ..width = '100%'
      ..height = '100%'
      ..overflow = 'hidden';
    final ins =
        web.document.createElement('ins') as web.HTMLElement
          ..className = 'adsbygoogle'
          ..style.display = 'inline-block'
          ..style.width = '${_bannerWidth}px'
          ..style.height = '${_bannerHeight}px'
          ..setAttribute('data-ad-client', chantAdClient);
    if (chantAdSlot.isNotEmpty) {
      ins.setAttribute('data-ad-slot', chantAdSlot);
    }
    _slot = ins;

    void request() {
      if (_requested || !host.isConnected) return;
      final rect = host.getBoundingClientRect();
      // The Flutter slot is positioned with a transform, which AdSense
      // measures as 0x0. Place the real tag on the page at that spot.
      if (rect.width < 200 || rect.height < 40) {
        _stableTicks = 0;
        return;
      }
      _stableTicks++;
      if (_stableTicks < 8) return;
      final left = rect.left + (rect.width - _bannerWidth) / 2;
      ins.style
        ..position = 'fixed'
        ..display = 'inline-block'
        ..width = '${_bannerWidth}px'
        ..height = '${_bannerHeight}px'
        ..left = '${left.round()}px'
        ..top = '${rect.top.round()}px'
        ..zIndex = '2';
      web.document.body?.append(ins);
      if (ins.offsetWidth < 200 || ins.offsetHeight < 40) return;
      _requested = true;
      _observer?.disconnect();
      _attachTimer?.cancel();
      _ensureScript();
      _pushAd();
      _watchStatus(ins);
    }

    _observer = web.ResizeObserver(
      (JSArray<web.ResizeObserverEntry> entries, web.ResizeObserver observer) {
        request();
      }.toJS,
    );
    _observer!.observe(host);
    _attachTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (timer.tick > 30) {
        timer.cancel();
        return;
      }
      request();
    });
  }

  void _ensureScript() {
    if (_scriptRequested) return;
    _scriptRequested = true;
    if (web.document.getElementById('chant-adsbygoogle') != null) return;
    final existing = web.document.querySelector(
      'script[src*="pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"]',
    );
    if (existing != null) return;
    final script =
        web.HTMLScriptElement()
          ..id = 'chant-adsbygoogle'
          ..async = true
          ..crossOrigin = 'anonymous'
          ..src =
              'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=$chantAdClient';
    web.document.head?.append(script);
  }

  void _pushAd() {
    final window = web.window;
    final existing = window.getProperty<JSAny?>('adsbygoogle'.toJS);
    final JSObject queue;
    if (existing == null || existing.isUndefined || existing.isNull) {
      queue = <JSAny?>[].toJS;
      window.setProperty('adsbygoogle'.toJS, queue);
    } else {
      queue = existing as JSObject;
    }
    queue.callMethod('push'.toJS, JSObject());
  }

  void _watchStatus(web.HTMLElement ins) {
    var tries = 0;
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      tries++;
      final status = ins.getAttribute('data-ad-status');
      if (status == 'filled') {
        timer.cancel();
        return;
      }
      if (status == 'unfilled' || tries >= 16) {
        timer.cancel();
        if (mounted && status != 'filled') {
          _slot?.remove();
          _slot = null;
          setState(() => _collapsed = true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_collapsed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: Center(
        child: SizedBox(
          width: _bannerWidth,
          height: _bannerHeight,
          child: HtmlElementView.fromTagName(
            key: const ValueKey('chant-banner-ad'),
            tagName: 'div',
            onElementCreated: _onElementCreated,
          ),
        ),
      ),
    );
  }
}
