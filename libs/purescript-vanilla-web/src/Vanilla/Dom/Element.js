"use strict";

exports.innerText = function(elem) {
    if (elem.innerText == undefined) {
        return ""
    } else {
        return elem.innerText;
    }
}
exports.innerHtml = function(elem) {
    return elem.innerHTML;
}
exports.classList = function(elem) {
    return elem.classList;
}
exports.setAttribute_ = function(name, elem, value) {
    elem.setAttribute(name, value);
}
exports.remove = function(elem) {
    return function() { // Effect Unit
        elem.remove();
    }
}
exports.getStyle = function(s) {
    return function(elem) {
        return elem.style[s];
    }
}
exports.setStyle_ = function(s, elem, x) {
    elem.style[s] = x;
}

exports.fromEventTarget_ = function(just, nothing, anyTarget) {
    if (anyTarget instanceof Element) {
        return just(anyTarget);
    } else {
        return nothing;
    }
}
exports.fromNode_ = function(just, nothing, anyNode) {
    if (anyNode instanceof Element) {
        return just(anyNode);
    } else {
        return nothing;
    }
}
