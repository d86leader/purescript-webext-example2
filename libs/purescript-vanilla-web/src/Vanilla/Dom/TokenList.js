"use strict";

exports.tokenListHas_ = function(str, clist) {
    return clist.contains(str);
}
exports.tokenListAdd_ = function(str, clist) {
    clist.add(str);
}
exports.tokenListRemove_ = function(str, clist) {
    clist.remove(str);
}
