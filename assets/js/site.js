/* ============================================================
   andrew-hoang-site — site.js. Vanilla, no deps, loaded defer.
   Two jobs: the theme toggle, and the scroll reveal.

   All of it is progressive enhancement. With JavaScript off the
   `js` class is never set, so no .reveal rule applies, nothing is
   hidden, the nav is a plain wrapping list of links, and the theme
   still follows the OS. The site is fully readable without this file.
   ============================================================ */

(function () {
  "use strict";

  var root = document.documentElement;

  /* ---- 1. Theme toggle -------------------------------------- */

  var btn = document.querySelector(".c-theme");

  function currentTheme() {
    var chosen = root.getAttribute("data-theme");
    if (chosen === "dark" || chosen === "light") return chosen;
    return window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function paintToggle(mode) {
    var dark = mode === "dark";
    btn.setAttribute("aria-pressed", dark ? "true" : "false");
    btn.setAttribute("aria-label", dark ? "Switch to light theme" : "Switch to dark theme");
    var text = btn.querySelector(".c-theme__text");
    if (text) text.textContent = dark ? "Light" : "Dark";
  }

  if (btn) {
    paintToggle(currentTheme());

    btn.addEventListener("click", function () {
      var next = currentTheme() === "dark" ? "light" : "dark";
      root.setAttribute("data-theme", next);
      /* localStorage throws in private mode — read and write both guarded. */
      try { localStorage.setItem("ah-theme", next); } catch (e) {}
      paintToggle(next);
    });
  }

  /* ---- 2. Scroll reveal ------------------------------------- */

  var targets = document.querySelectorAll(".reveal, .section__rule, .c-pair");
  var i;

  var reduce = window.matchMedia &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* Reduced motion, or no IntersectionObserver: show everything now and
     never build the observer. Nothing waits on a scroll event. */
  if (reduce || !("IntersectionObserver" in window)) {
    for (i = 0; i < targets.length; i++) targets[i].classList.add("is-in");
    return;
  }

  var io = new IntersectionObserver(function (entries) {
    for (var k = 0; k < entries.length; k++) {
      if (entries[k].isIntersecting) {
        entries[k].target.classList.add("is-in");
        io.unobserve(entries[k].target);
      }
    }
  }, { rootMargin: "0px 0px -10% 0px", threshold: 0 });

  /* A section rule is a 2px hairline, and a 2px-tall target is an
     unreliable observer subject: on a fast scroll it can be missed
     outright, silently deleting the page's main structural device.
     Each rule is observed through its container instead, which is
     hundreds of pixels tall and carries the class. */
  for (i = 0; i < targets.length; i++) {
    var t = targets[i];
    io.observe(t.classList.contains("section__rule") && t.parentElement
      ? t.parentElement : t);
  }
})();
