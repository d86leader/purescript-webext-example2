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
