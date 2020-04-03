"use strict";

exports.document = document;

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
