// Event handlers for hover, mouseleave & mousemove & on-click
// The page must define a `#actionmap-info-box` div with `.d-none`
exports.handleMapMouseEvents = (jQueryTargets, hoverHtmlProvider, clickCallback) => {
    const infoBox = $('#actionmap-info-box');
    jQueryTargets.hover((e) => {
        infoBox.html(hoverHtmlProvider($(e.currentTarget)));
        infoBox.css('display', 'block');
    });
    jQueryTargets.mouseleave(() => infoBox.css('display', 'none'));
    $(document).mousemove((elem) => {
        infoBox.css('top', elem.pageY - infoBox.height() - 30);
        infoBox.css('left', elem.pageX - infoBox.width() / 2);
    }).mouseover();
    jQueryTargets.click((e) => {
        clickCallback($(e.currentTarget));
    });
};

exports.zeroPad = (number, numZeros) => {
    let s = String(number);
    while (s.length < (numZeros || 1)) { s = `0${s}`; }
    return s;
};
