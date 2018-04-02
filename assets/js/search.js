'use strict';
var search = function(needle, haystack) {
  var keys = [];
  for(var key in haystack) {
    for(var field in haystack[key]) {
      if(null === haystack[key][field]) {
        continue;
      }
      var field_ic = haystack[key][field].toUpperCase();
      var needle_ic = needle.toUpperCase();
      if(field_ic.includes(needle_ic)) {
        keys.push(key);
        // we have a match, don't bother going through fields
        break;
      }
    }
  }
  return keys;
}

exports.search = search;
