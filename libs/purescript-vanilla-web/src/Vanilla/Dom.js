"use strict";

exports.document = document;

exports.querySelector_ = function(elem, str) {
    return elem.querySelector(str);
}

exports.textContent = function(elem) {
    return elem.textContent;
}
