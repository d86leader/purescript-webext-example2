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
exports.unsafeAppendChild_ = function(p, c) {
    console.error("appending child", c.innerHTML);
    return p.appendChild(c);
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
exports.traverseNodeList_ = function(ret, func, list) {
    for (var i = 0; i < list.length; ++i) {
        func(list[i]);
    }
    return ret;
}

exports.unsafeQuerySelector_ = function(q, node) {
    return node.querySelector(q);
}
exports.unsafeQuerySelectorAll_ = function(q, node) {
    return node.querySelectorAll(q);
}
