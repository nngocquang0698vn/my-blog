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

      var found = false;
      var needle_split = needle_ic.split(' ');
      for(var word in needle_split) {
        if(field_ic.includes(needle_split[word])) {
          found = true;
          break;
        }
      }

      if(found) {
        keys.push(key);
        // we have a match, don't bother going through fields
        break;
      }
    }
  }
  return keys;
}

var show = function show(element, showBool) {
  if (showBool) {
    element.classList.remove('hidden');
  } else {
    element.classList.add('hidden');
  }
}

var showMatches = function showMatches(matches, container, noMatchesElement) {
  show(noMatchesElement, (0 == matches.length));

  var len = container.children.length;
  for (var i = 0; i < len; i++) {
    show(container.children[i], (matches.includes(container.children[i].id)));
  }
}

var onSearchInput = function onSearchInput(haystack, searchInput, container, noMatchesElement) {
  var matches = search(searchInput.value, haystack);
  // where we have no search, show everything
  if('' === searchInput.value) {
    var len = container.children.length;
    for (var i = 0; i < len; i++) {
      show(container.children[i], true);
    }
    // except the "no matches"
    show(noMatchesElement, false);
  } else {
    // otherwise, only show our matches
    showMatches(matches, container, noMatchesElement);
  }
}

exports.search = search;
exports.showMatches = showMatches;
exports.onSearchInput = onSearchInput;
