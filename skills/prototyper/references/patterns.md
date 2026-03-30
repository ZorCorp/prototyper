# Prototyper Code Patterns Reference

Detailed code patterns for generating `prototyper/` output. Read this when
you need implementation details beyond what SKILL.md covers.

## Table of Contents
1. [HTML Layout Template](#1-html-layout-template)
2. [CSS Architecture](#2-css-architecture)
3. [Data Module](#3-data-module)
4. [Icon Module](#4-icon-module)
5. [Screen Renderers](#5-screen-renderers)
6. [State Machine Controller](#6-state-machine-controller)
7. [Auto-Play Engine](#7-auto-play-engine)
8. [Demo Cursor & Effects](#8-demo-cursor--effects)
9. [Device Frames](#9-device-frames)
10. [Animation Library](#10-animation-library)

---

## 1. HTML Layout Template

### Single-Screen Layout
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Product Name] — Interactive Demo</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <div class="demo-container">
    <div class="demo-header">
      <div class="demo-header-left"><!-- Product logo --></div>
      <div class="demo-header-right">
        <span class="demo-badge">INTERACTIVE DEMO</span>
      </div>
    </div>
    <div class="demo-body">
      <div class="device-frame">
        <div class="device-header"><!-- App header replica --></div>
        <div class="device-content" id="main-screen"></div>
      </div>
    </div>
    <div class="control-bar" id="control-bar">
      <!-- Control buttons (see Section 7) -->
    </div>
  </div>
  <div id="demo-cursor">
    <svg width="36" height="36" viewBox="0 0 24 24" fill="none">
      <path d="M5 3L19 12L12 13L9 20L5 3Z" fill="#003366"
            stroke="#fff" stroke-width="1.5" stroke-linejoin="round"/>
    </svg>
  </div>
  <script src="js/data.js"></script>
  <script src="js/icons.js"></script>
  <script src="js/screens.js"></script>
  <script src="js/autoplay.js"></script>
  <script src="js/app.js"></script>
</body>
</html>
```

### Split-Screen Layout (Dual Device)
Add a phone wrapper alongside the main device:
```html
<div class="demo-body">
  <div class="device-frame primary"><!-- 65% width --></div>
  <div class="phone-wrapper"><!-- 35% width -->
    <div class="phone-frame">
      <div class="phone-notch"></div>
      <div class="phone-content" id="phone-screen"></div>
      <div class="phone-home-bar"></div>
    </div>
  </div>
</div>
```

---

## 2. CSS Architecture

### Color Variables
Extract from the product's CSS/Tailwind config/design tokens:
```css
:root {
  /* Brand - extract these from the source product */
  --brand-primary: #003366;
  --brand-primary-light: #004080;
  --brand-accent: #C4972F;
  --brand-accent-light: #D4A84A;
  --brand-bg: #F5F5F5;
  --brand-surface: #FFFFFF;
  --brand-text: #1A1A2E;

  /* System grays (usually same across products) */
  --gray-50: #f9fafb;  --gray-100: #f3f4f6;
  --gray-200: #e5e7eb;  --gray-300: #d1d5db;
  --gray-400: #9ca3af;  --gray-500: #6b7280;
  --gray-600: #4b5563;  --gray-800: #1f2937;
  --gray-900: #111827;

  /* Semantic */
  --green-500: #22c55e;  --green-50: #f0fdf4;
  --red-500: #ef4444;
}
```

### Font Stack
```css
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
    "Helvetica Neue", Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
}
```

### Base Layout
```css
.demo-container { display: flex; flex-direction: column; height: 100vh; }
.demo-header { height: 56px; background: #fff; border-bottom: 1px solid var(--gray-200); }
.demo-body { flex: 1; display: flex; overflow: hidden; gap: 16px; padding: 16px; }
.control-bar { height: 48px; background: #fff; border-top: 1px solid var(--gray-200); }
```

---

## 3. Data Module

```javascript
var DemoData = (function() {
  // Adapt these arrays to match the source product's domain
  var ITEMS = [
    { id: "item-1", name: "Item Name", price: 100, image: "assets/items/item-1.png" },
    // ...
  ];

  return {
    ITEMS: ITEMS,
    // Export everything that screens need
  };
})();
```

---

## 4. Icon Module

Extract SVG paths from the product's icon library (Lucide, Heroicons, etc.):

```javascript
var Icons = (function() {
  function svg(content, size, cls) {
    var s = size || 24;
    var c = cls || '';
    return '<svg xmlns="http://www.w3.org/2000/svg" width="' + s +
      '" height="' + s + '" viewBox="0 0 24 24" fill="none" ' +
      'stroke="currentColor" stroke-width="2" stroke-linecap="round" ' +
      'stroke-linejoin="round" class="' + c + '">' + content + '</svg>';
  }

  return {
    // Add icons as needed for each product
    check: function(s,c) { return svg('<path d="M20 6 9 17l-5-5"/>',s,c); },
    arrowLeft: function(s,c) { return svg('<path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>',s,c); },
    // ... extract all icons the product uses
  };
})();
```

---

## 5. Screen Renderers

Each screen is a pure function returning HTML:

```javascript
var Screens = (function() {
  var D = DemoData;
  var I = Icons;

  function renderItemList() {
    var cards = '';
    D.ITEMS.forEach(function(item) {
      cards += '<button class="card" data-item="' + item.id + '">' +
        '<img src="' + item.image + '" alt="' + item.name + '">' +
        '<h3>' + item.name + '</h3>' +
        '<span class="price">$' + item.price + '</span>' +
        '</button>';
    });
    return '<div class="item-grid">' + cards + '</div>';
  }

  function renderDetail(item) {
    return '<div class="detail-screen">' +
      '<img src="' + item.image + '">' +
      '<h2>' + item.name + '</h2>' +
      '<button data-action="buy">Buy Now</button>' +
      '</div>';
  }

  // ... more screens

  return {
    renderItemList: renderItemList,
    renderDetail: renderDetail,
  };
})();
```

**Important:** Use `data-*` attributes for interactive elements so the state
machine and autoplay engine can target them.

---

## 6. State Machine Controller

```javascript
(function() {
  var el = document.getElementById('main-screen');
  var state = { screen: null, data: {} };

  function setScreen(screen, data) {
    data = data || {};
    state = { screen: screen, data: data };
    var html = '';
    switch(screen) {
      case 'loading':     html = Screens.renderSkeleton(); break;
      case 'list':        html = Screens.renderItemList(); break;
      case 'detail':      html = Screens.renderDetail(data.item); break;
      // ... all screens
    }
    el.innerHTML = html;
    el.classList.add('fade-enter');
    setTimeout(function() { el.classList.remove('fade-enter'); }, 300);
    bindEvents();
  }

  function bindEvents() {
    // Bind click handlers based on current screen
    el.querySelectorAll('[data-item]').forEach(function(card) {
      card.addEventListener('click', function() {
        var id = card.getAttribute('data-item');
        var item = DemoData.ITEMS.find(function(i) { return i.id === id; });
        Autoplay.pause(); // Pause autoplay on manual interaction
        setScreen('detail', { item: item });
      });
    });
    // ... more event bindings
  }

  // Initialize
  Autoplay.start(setScreen);
})();
```

---

## 7. Auto-Play Engine

```javascript
var Autoplay = (function() {
  var cursor, playing = true, paused = false, speed = 1;
  var currentStep = 0, aborted = false, timers = [];
  var onSetScreen = null;

  var steps = [
    { label: 'Loading', run: function(done) {
      onSetScreen('loading');
      wait(1500, done);
    }},
    { label: 'Show list', run: function(done) {
      onSetScreen('list');
      wait(2000, done);
    }},
    { label: 'Click item', run: function(done) {
      var target = document.querySelector('[data-item="item-1"]');
      showCursor();
      moveCursorTo(target, function() {
        clickEffect(target);
        wait(500, function() {
          hideCursor();
          onSetScreen('detail', { item: DemoData.ITEMS[0] });
          done();
        });
      });
    }},
    // ... more steps, ending with a loop-back
  ];

  function wait(ms, cb) {
    var t = setTimeout(function() { if (!aborted) cb(); }, ms / speed);
    timers.push(t);
  }

  function showCursor() {
    if (!cursor) cursor = document.getElementById('demo-cursor');
    cursor.classList.add('visible');
  }
  function hideCursor() {
    if (cursor) cursor.classList.remove('visible');
  }
  function moveCursorTo(target, cb) {
    if (!cursor) cursor = document.getElementById('demo-cursor');
    var rect = target.getBoundingClientRect();
    cursor.style.left = (rect.left + rect.width/2 - 4) + 'px';
    cursor.style.top = (rect.top + rect.height/2 - 4) + 'px';
    wait(850, cb);
  }
  function clickEffect(target) {
    if (cursor) { cursor.classList.add('clicking');
      setTimeout(function() { cursor.classList.remove('clicking'); }, 150); }
    var rect = target.getBoundingClientRect();
    var ripple = document.createElement('div');
    ripple.className = 'click-ripple';
    ripple.style.left = (rect.left + rect.width/2 - 20) + 'px';
    ripple.style.top = (rect.top + rect.height/2 - 20) + 'px';
    document.body.appendChild(ripple);
    setTimeout(function() { ripple.remove(); }, 600);
  }

  function runStep(i) {
    if (aborted || i >= steps.length) { currentStep = 0; runStep(0); return; }
    currentStep = i;
    updateDisplay();
    if (paused) {
      var check = setInterval(function() {
        if (!paused) { clearInterval(check); steps[i].run(function() { runStep(i+1); }); }
      }, 100);
      return;
    }
    steps[i].run(function() { runStep(i+1); });
  }

  function updateDisplay() {
    var el = document.getElementById('ctrl-step');
    if (el) el.textContent = 'Step ' + (currentStep+1) + ' / ' + steps.length;
  }

  return {
    start: function(setFn) { onSetScreen = setFn; runStep(0); },
    pause: function() { paused = true; },
    resume: function() { paused = false; },
    togglePause: function() { if (paused) this.resume(); else this.pause(); },
    skip: function() {
      aborted = true;
      timers.forEach(function(t) { clearTimeout(t); });
      timers = [];
      hideCursor();
      setTimeout(function() { aborted = false; runStep(currentStep+1); }, 100);
    },
    reset: function(setFn) {
      aborted = true;
      timers.forEach(function(t) { clearTimeout(t); });
      timers = [];
      hideCursor();
      setTimeout(function() { this.start(setFn || onSetScreen); }.bind(this), 100);
    },
    setSpeed: function(s) { speed = s; },
  };
})();
```

### Control Bar HTML
```html
<div class="control-bar">
  <button class="ctrl-btn active" id="btn-play-pause">⏸ Pause</button>
  <span class="ctrl-step" id="ctrl-step">Step 1 / 15</span>
  <select class="ctrl-speed" id="ctrl-speed">
    <option value="0.5">0.5x</option>
    <option value="1" selected>1x</option>
    <option value="2">2x</option>
  </select>
  <button class="ctrl-btn" id="btn-skip">⏭ Skip</button>
  <button class="ctrl-btn" id="btn-reset">↻ Reset</button>
</div>
```

---

## 8. Demo Cursor & Effects

```css
#demo-cursor {
  position: fixed;
  width: 36px; height: 36px;
  pointer-events: none;
  z-index: 99999;
  opacity: 0;
  transition: left 0.8s cubic-bezier(0.4,0,0.2,1),
              top 0.8s cubic-bezier(0.4,0,0.2,1), opacity 0.3s;
  filter: drop-shadow(2px 3px 3px rgba(0,0,0,0.35));
}
#demo-cursor.visible { opacity: 1; }
#demo-cursor.clicking { transform: scale(0.8); }

.click-ripple {
  position: fixed; width: 40px; height: 40px;
  border-radius: 50%;
  background: rgba(196,151,47,0.3);
  pointer-events: none; z-index: 99998;
  animation: ripple-out 0.6s ease-out forwards;
}
@keyframes ripple-out {
  0% { transform: scale(0); opacity: 1; }
  100% { transform: scale(2); opacity: 0; }
}

.demo-annotation {
  position: fixed;
  padding: 8px 16px;
  background: var(--brand-primary);
  color: #fff; font-size: 13px; font-weight: 500;
  border-radius: 8px; z-index: 99997;
  pointer-events: none;
  animation: fade-in-up 0.3s ease-out;
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
}
```

---

## 9. Device Frames

### Phone Frame
```css
.phone-frame {
  width: 320px;
  aspect-ratio: 9 / 19.5;
  border: 6px solid #1a1a1a;
  border-radius: 40px;
  overflow: hidden;
  background: #000;
  box-shadow: 0 20px 60px rgba(0,0,0,0.25), inset 0 0 0 2px #333;
  display: flex; flex-direction: column;
}
.phone-notch {
  width: 120px; height: 28px;
  background: #1a1a1a;
  border-radius: 0 0 16px 16px;
  margin: 0 auto;
}
.phone-home-bar {
  width: 100px; height: 4px;
  background: #666; border-radius: 2px;
  margin: 6px auto;
}
```

### Desktop/Tablet Frame
```css
.device-frame {
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 8px 40px rgba(0,0,0,0.12);
  display: flex; flex-direction: column;
}
```

---

## 10. Animation Library

### Skeleton Shimmer
```css
.skeleton {
  background: linear-gradient(90deg, #e5e7eb 25%, #f3f4f6 50%, #e5e7eb 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
@keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }
```

### Spinner (Dual Ring)
```css
.spinner-outer { border: 4px solid transparent; border-top-color: var(--brand-primary);
  border-radius: 50%; animation: spin 1s linear infinite; }
.spinner-inner { border: 4px solid transparent; border-top-color: var(--brand-accent);
  border-radius: 50%; animation: spin 1.5s linear infinite reverse; }
@keyframes spin { to { transform: rotate(360deg); } }
```

### Bouncing Dots
```css
.bounce-dots span { width: 8px; height: 8px; border-radius: 50%;
  background: var(--brand-primary); animation: bounce 1s ease-in-out infinite; }
.bounce-dots span:nth-child(2) { animation-delay: 150ms; }
.bounce-dots span:nth-child(3) { animation-delay: 300ms; }
@keyframes bounce { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-8px); } }
```

### Pulse Dot
```css
.pulse-dot { width: 8px; height: 8px; border-radius: 50%;
  animation: pulse 2s cubic-bezier(0.4,0,0.6,1) infinite; }
@keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.5; } }
```

### Success Checkmark with Ping
```css
.success-icon { width: 96px; height: 96px; border-radius: 50%;
  background: var(--green-500); display: flex; align-items: center; justify-content: center;
  box-shadow: 0 8px 24px rgba(34,197,94,0.3); }
.success-ping { position: absolute; inset: -12px; border: 2px solid rgba(34,197,94,0.2);
  border-radius: 50%; animation: ping 1s cubic-bezier(0,0,0.2,1) infinite; }
@keyframes ping { 75%,100% { transform: scale(2); opacity: 0; } }
```

### Fade Enter
```css
.fade-enter { animation: fade-in 0.3s ease-out; }
@keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }
```

### Zoom Fade In (for success screens)
```css
@keyframes zoom-fade-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
```

### Progress Bar
```css
.progress-bar { height: 6px; background: var(--gray-100); border-radius: 999px; overflow: hidden; }
.progress-fill { height: 100%; background: var(--brand-primary); border-radius: 999px;
  transition: width 0.1s; }
```

### SVG Circle Progress
```javascript
// Animate stroke-dasharray from 0 to 226 (circumference of r=36 circle)
function updateProgress(percent) {
  var circle = document.querySelector('.progress-circle');
  if (circle) circle.setAttribute('stroke-dasharray', (percent * 2.26) + ' 226');
}
```
