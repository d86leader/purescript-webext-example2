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
exports.classListHas = function(clist, str) {
    return clist.contains(str);
}
exports.extensionGetUrl = browser.runtime.getURL;
exports.tabId = function(tab) {
    return tab.id;
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


// Promise based
exports.tabsQuery = browser.tabs.query;
exports.insertTabCss = browser.tabs.insertCSS;
exports.removeTabCss = browser.tabs.insertCSS;
exports.sendTabMessage_ = browser.tabs.sendMessage;
exports.injectContentScript = function(path) {
    return browser.tabs.executeScript({file: path});
}
