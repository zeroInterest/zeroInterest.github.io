(() => {
  // Theme switch
  const body = document.body;
  const lamp = document.getElementById("mode");

  const toggleTheme = (state) => {
     if (state === "dark") {
      localStorage.setItem("theme", "light");
      body.removeAttribute("data-theme");
      if(document.querySelector('iframe') !== null){
        var message = {
          type: 'set-theme',
          theme: 'github-light'
        };
        var utterances = document.querySelector('iframe');
        utterances.contentWindow.postMessage(message, 'https://utteranc.es');
      }
    } else if (state === "light") {
      localStorage.setItem("theme", "dark");
      body.setAttribute("data-theme", "dark");
      if(document.querySelector('iframe') !== null){
        var message = {
          type: 'set-theme',
          theme: 'github-dark'
        };
        var utterances = document.querySelector('iframe');
        utterances.contentWindow.postMessage(message, 'https://utteranc.es');
      }
    } else {
      initTheme(state);
    }
  };

  lamp.addEventListener("click", () =>
    toggleTheme(localStorage.getItem("theme"))
  );

  // Blur the content when the menu is open
  const cbox = document.getElementById("menu-trigger");

  cbox.addEventListener("change", function () {
    const area = document.querySelector(".wrapper");
    this.checked
      ? area.classList.add("blurry")
      : area.classList.remove("blurry");
  });
})();


window.onload = function() {
    var startTheme = body.getAttribute("data-theme")
    if (startTheme == "dark") {
      setTimeout(function(){
        var message = {
        type: 'set-theme',
        theme: 'github-dark'
        };
        var utterances = document.querySelector('iframe');
        utterances.contentWindow.postMessage(message, 'https://utteranc.es');
      }, 750);
    }
}





