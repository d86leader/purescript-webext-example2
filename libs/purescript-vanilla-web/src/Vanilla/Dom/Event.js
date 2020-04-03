"use strict";

exports.eventTarget = function(e) {
    return e.target;
}

exports.addListener = function(eventType, cb, target) {
    target.addEventListener(eventType, cb);
}
exports.removeListener = function(eventType, cb, target) {
    target.removeEventListener(eventType, cb);
}
exports.dispatch = function(eventType, target) {
    return target.dispatchEvent(eventType, cb);
}
