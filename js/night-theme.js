/* before interacting with the DOM always wait for it to be fully parsed */
document.addEventListener( "DOMContentLoaded", () => {

    /* querySelector works by getting the first match of a CSS path */
    document.querySelector( "header button[name='night-mode']" ).addEventListener( "click", (evt) => {
        /* the click handler toggles the theme-night class, all else is done by CSS */
        document.body.classList.toggle("theme-night");
    });
});
