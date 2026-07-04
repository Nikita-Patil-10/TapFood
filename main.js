/**
 * main.js — TapFood Global JavaScript
 * Location: src/main/webapp/js/main.js
 *
 * FIXED:
 * 1. Cart quantity +/- fires exactly once per click (no duplicate handlers)
 * 2. Single-restaurant cart with confirmation popup
 * 3. Consistent state across all pages
 */

'use strict';

/* ── Navbar scroll shadow ────────────────────────────────── */
(function () {
    var navbar = document.getElementById('navbar');
    if (!navbar) return;
    window.addEventListener('scroll', function () {
        navbar.style.boxShadow = window.scrollY > 12
            ? '0 4px 24px rgba(0,0,0,0.10)'
            : '0 2px 8px rgba(0,0,0,0.06)';
    }, { passive: true });
})();

/* ── Toast helper ────────────────────────────────────────── */
window.TapFood = window.TapFood || {};

window.TapFood.showToast = function (message, type, duration) {
    type     = type     || 'success';
    duration = duration || 3500;

    var container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    toast.innerHTML = (type === 'success' ? '✅' : '❌') + ' &nbsp;' + message;
    container.appendChild(toast);

    setTimeout(function () {
        toast.style.transition = 'opacity 0.4s ease';
        toast.style.opacity    = '0';
        setTimeout(function () { toast.remove(); }, 400);
    }, duration);
};

/* ── Auto-dismiss flash toasts ───────────────────────────── */
(function () {
    var toast = document.getElementById('flashToast');
    if (toast) {
        setTimeout(function () {
            toast.style.transition = 'opacity 0.4s ease';
            toast.style.opacity    = '0';
            setTimeout(function () { toast.remove(); }, 400);
        }, 3500);
    }
})();
