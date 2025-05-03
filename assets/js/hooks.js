// assets/js/hooks/clipboard.js
const Clipboard = {
  
  mounted() {
    this.el.addEventListener("click", async () => {
      const copyId = this.el.dataset.copyId;
      const el = document.getElementById(copyId);
      if (!el) return;

      const html = el.innerHTML;

      if (navigator.clipboard && window.ClipboardItem) {
        try {
          const blob = new Blob([html], { type: "text/html" });
          const item = new ClipboardItem({ "text/html": blob });
          await navigator.clipboard.write([item]);
          console.log("Copied to clipboard.");
        } catch (err) {
          console.error("Clipboard API failed:", err);
        }
      } else {
        // Fallback for older browsers
        const range = document.createRange();
        range.selectNodeContents(el);
        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
        document.execCommand("copy");
        selection.removeAllRanges();
      }
    });
  }
};

export default Clipboard;
