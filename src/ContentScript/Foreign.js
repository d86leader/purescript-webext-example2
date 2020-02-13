"use strict";

exports.setProperty_ = function(x, s, v) {
    x[s] = v;
}


// Effectful
exports.scriptHasRun = function() {
    return window.hasRun;
}
exports.setScriptHasRun = function() {
    window.hasRun = true;
}
exports.createElement_ = function(name) {
    return document.createElement(name);
}
exports.setElementAttribute_ = function(name, value, elem) {
    elem.setAttribute(name, value);
}
exports.appendBodyElement_ = function(elem) {
    document.body.appendChild(elem);
}
exports.removeMatchingElements_ = function(q) {
    var matching = document.querySelectorAll(q);
    for (var i = 0; i < matching.length; ++i) {
        matching[i].remove();
    }
}
exports.setElementStyle_ = function(s, x, elem) {
    elem.style[s] = x;
}
exports.addMessageListener_ = function(cb) {
    browser.runtime.onMessage.addListener(cb);
}
