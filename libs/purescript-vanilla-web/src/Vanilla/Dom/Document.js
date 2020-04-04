"use strict";

exports.document = document;
exports.body = document.body;

exports.createElement_ = function(name) {
    return document.createElement(name);
}

exports.fromEventTarget_ = function(just, nothing, anyTarget) {
    if (anyTarget instanceof Document) {
        return just(anyTarget);
    } else {
        return nothing;
    }
}
exports.fromNode_ = function(just, nothing, anyNode) {
    if (anyNode instanceof Document) {
        return just(anyNode);
    } else {
        return nothing;
    }
}
