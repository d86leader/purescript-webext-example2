"use strict";

// Pure functions
exports.document = document;
exports.eventTarget = function(e) {
    return e.target;
}
exports.elementTextContent = function(elem) {
    return elem.textContent;
}
exports.elementClassList = function(elem) {
    return elem.classList;
}
exports.classListHas_ = function(clist, str) {
    return clist.contains(str);
}


// Simple Effect
exports.addEventListener_ = function(target, eventType, cb) {
    target.addEventListener(eventType, cb);
}
exports.classListAdd_ = function(clist, str) {
    clist.add(str);
}
exports.classListRemove_ = function(clist, str) {
    clist.remove(str);
}
exports.querySelector_ = function(elem, str) {
    return elem.querySelector(str);
}
