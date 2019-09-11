/* vfx-navigation: translate hash-changes in address to section visibility */

function pathChange() {
    const id = location.hash;
    if( id && document.querySelector(`main > section${id}`) != null )
        return;

    location.hash = document.querySelector("main > section[id]").getAttribute("id");
}

pathChange();
window.addEventListener('hashchange', () => pathChange(), false);
