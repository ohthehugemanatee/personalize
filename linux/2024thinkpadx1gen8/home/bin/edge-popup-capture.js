/* Outlook/Edge blank-popup capture harness.
 * Paste into DevTools console on the Outlook tab, then reproduce the popup.
 * Recorded popups survive after the popup closes:  __popcap.dump()
 */
(() => {
  if (window.__popcap) { console.warn('popcap already installed'); return window.__popcap; }

  const hits = [];
  const seen = new WeakSet();

  const isPopupish = (el) => {
    if (!(el instanceof HTMLElement)) return false;
    const cs = getComputedStyle(el);
    if (!['fixed', 'absolute'].includes(cs.position)) return false;
    const z = parseInt(cs.zIndex, 10);
    const role = (el.getAttribute('role') || '').toLowerCase();
    return (z >= 100) ||
           ['dialog', 'tooltip', 'menu', 'listbox'].includes(role) ||
           /callout|flyout|popover|hover-?card|tooltip/i.test(el.className + ' ' + el.id);
  };

  const describe = (el, why) => {
    const cs = getComputedStyle(el);
    const r = el.getBoundingClientRect();
    // "blank" heuristics
    const text = (el.innerText || '').trim();
    const imgs = el.querySelectorAll('img,svg,canvas').length;
    const iframes = [...el.querySelectorAll('iframe')].map(f => ({
      src: f.src, w: f.clientWidth, h: f.clientHeight,
      sameOrigin: (() => { try { return !!f.contentDocument; } catch (e) { return false; } })(),
      innerLen: (() => { try { return f.contentDocument.body.innerHTML.length; } catch (e) { return null; } })(),
    }));
    return {
      at: new Date().toISOString(), why,
      tag: el.tagName, id: el.id, cls: el.className,
      role: el.getAttribute('role'),
      rect: { x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) },
      css: { position: cs.position, zIndex: cs.zIndex, display: cs.display,
             visibility: cs.visibility, opacity: cs.opacity, overflow: cs.overflow,
             background: cs.backgroundColor, transform: cs.transform,
             clipPath: cs.clipPath, contentVisibility: cs.contentVisibility },
      childCount: el.childElementCount,
      textLen: text.length, textPreview: text.slice(0, 200),
      imgCount: imgs, iframes,
      looksBlank: text.length === 0 && imgs === 0 && r.width > 40 && r.height > 40,
      shadowRoots: [...el.querySelectorAll('*')].filter(n => n.shadowRoot).length,
      html: el.outerHTML,
    };
  };

  const record = (el, why) => {
    if (seen.has(el)) return;
    seen.add(el);
    const d = describe(el, why);
    hits.push({ el, d });
    console.log(`%c[popcap] ${why} ${d.tag}.${String(d.cls).slice(0,40)} ${d.rect.w}x${d.rect.h} blank=${d.looksBlank}`,
                'color:#c0f', d);
    // re-sample shortly after, to catch late-filled content
    setTimeout(() => {
      if (!el.isConnected) { d.laterState = 'detached'; return; }
      d.later = describe(el, why + '+600ms');
    }, 600);
  };

  const obs = new MutationObserver(muts => {
    for (const m of muts) {
      for (const n of m.addedNodes) {
        if (!(n instanceof HTMLElement)) continue;
        if (isPopupish(n)) record(n, 'added');
        n.querySelectorAll?.('*').forEach(c => { if (isPopupish(c)) record(c, 'added-desc'); });
      }
    }
  });
  obs.observe(document.documentElement, { childList: true, subtree: true });

  // --- popup WINDOWS (Outlook opens about:blank then injects) ---------------
  const childWins = [];

  const probeWin = (w) => {
    // about:blank inherits the opener's origin, so this is normally readable
    try {
      if (!w || w.closed) return { closed: true };
      const d = w.document;
      const b = d.body;
      return {
        href: (() => { try { return w.location.href; } catch (e) { return '<blocked>'; } })(),
        readyState: d.readyState,
        title: d.title,
        outerW: w.outerWidth, outerH: w.outerHeight,
        innerW: w.innerWidth, innerH: w.innerHeight,
        bodyLen: b ? b.innerHTML.length : null,
        bodyKids: b ? b.childElementCount : null,
        bodyText: b ? (b.innerText || '').trim().slice(0, 120) : null,
        bodyBg: b ? getComputedStyle(b).backgroundColor : null,
        headLen: d.head ? d.head.innerHTML.length : null,
        scripts: d.scripts ? d.scripts.length : null,
      };
    } catch (e) {
      return { error: String(e) };   // cross-origin => real navigation happened
    }
  };

  const trackWin = (w, args) => {
    const rec = { at: new Date().toISOString(), why: 'window.open', args, timeline: [] };
    hits.push({ d: rec });
    childWins.push({ w, rec });
    let n = 0;
    const iv = setInterval(() => {
      const s = probeWin(w);
      rec.timeline.push({ tMs: n * 250, ...s });
      if (++n >= 40 || s.closed) {            // 10s
        clearInterval(iv);
        rec.final = probeWin(w);
        try { rec.finalHTML = w.document.documentElement.outerHTML; } catch (e) {}
        const empty = rec.timeline.filter(t => t.bodyLen === 0 || t.bodyKids === 0).length;
        rec.verdict = empty === rec.timeline.length ? 'NEVER POPULATED'
                    : empty ? 'populated late' : 'populated immediately';
        console.log(`%c[popcap] child window done: ${rec.verdict}`, 'color:#f60;font-weight:bold', rec);
      }
    }, 250);
  };

  const origOpen = window.open;
  window.open = function (...a) {
    const w = origOpen.apply(this, a);
    console.log('%c[popcap] window.open', 'color:#0af', a, w ? '(got window)' : '(BLOCKED/null)');
    trackWin(w, a);
    return w;
  };

  window.__popcap = {
    hits, childWins,
    dump: () => hits.map(h => h.d),
    blank: () => hits.filter(h => h.d.looksBlank).map(h => h.d),
    html: (i = 0) => hits[i]?.d.html,
    wins: () => hits.filter(h => h.d.why === 'window.open').map(h => h.d),
    probeNow: () => childWins.map(c => ({ args: c.rec.args, ...probeWin(c.w) })),
    grab: (i = 0) => { try { return childWins[i].w.document.documentElement.outerHTML; }
                       catch (e) { return String(e); } },
    save: () => {
      const blob = new Blob([JSON.stringify(hits.map(h => h.d), null, 2)], { type: 'application/json' });
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'popcap-' + Date.now() + '.json';
      a.click();
    },
    stop: () => { obs.disconnect(); window.open = origOpen; console.log('[popcap] stopped'); },
  };
  console.log('%c[popcap] installed — reproduce the popup, then run __popcap.save()', 'color:#0a0;font-weight:bold');
  return window.__popcap;
})();
