"use strict";

exports.window = window;

exports.setCustomAttribute_ = function(name, val) {
    window[name] = val;
}
exports.getCustomAttribute_ = function(name) {
    return window[name];
}
