function autoHideFlash() {
  document.querySelectorAll('.custom-alert, .custom-notice').forEach((flash) => {
    setTimeout(() => {
      flash.style.transition = 'opacity 0.5s ease';
      flash.style.opacity = '0';
      setTimeout(() => flash.remove(), 500);
    }, 3000);
  });
}

['DOMContentLoaded', 'turbo:load', 'turbo:render'].forEach(evt =>
  document.addEventListener(evt, autoHideFlash)
);
