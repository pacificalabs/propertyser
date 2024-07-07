$(document).ready(function() {
    // Size of browser viewport.
    window.viewport = {
        height: window.innerHeight,
        width: window.innerWidth,
        ratio: window.devicePixelRatio
    }
    document.cookie = "viewPort=" + JSON.stringify(window.viewport);
})