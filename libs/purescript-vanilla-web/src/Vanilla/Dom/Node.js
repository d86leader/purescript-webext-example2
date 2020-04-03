"use strict";

exports.unsafeTextContent = function(node) {
    var cont = node.textContent;
    if (cont == null) {
        return "";
    } else {
        return cont;
    }
}
exports.unsafeChildNodes = function(node) {
    return node.childNodes;
}

exports.nodeListLength = function(list) {
    return list.length;
}
exports.nodeListItem_ = function(index, list) {
    if (index < 0 || index >= list.length) {
        throw new ReferenceError("Accessing NodeList item out of bounds");
    }
    return list.item(index);
}

exports.unsafeQuerySelector_ = function(q, node) {
    return node.querySelector(q);
}
