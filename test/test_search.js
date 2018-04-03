var expect = require('expect.js')
var search = require('../assets/js/search.js');

describe('search', function() {
  it('returns empty array when no matches', function() {
    var actual = search.search('', {});
    expect(actual).to.have.length(0);
  });

  it('matches title', function() {
    var haystack = {
      'key': {
        title: 'wibble foo blah'
      }
    };
    var actual = search.search('foo', haystack);
    expect(actual).to.have.length(1);
    expect(actual[0]).to.equal('key');
  });

  it('matches within word', function() {
    var haystack = {
      'key': {
        title: 'wibblefoobar'
      }
    };
    var actual = search.search('foo', haystack);
    expect(actual).to.have.length(1);
    expect(actual[0]).to.equal('key');
  });

  it('is not case sensitive', function() {
    var haystack = {
      'lower': {
        title: 'foo'
      },
      'upper': {
        title: 'FOO'
      },
      'mixed': {
        title: 'fOo'
      }
    };
    var actual = search.search('FOO', haystack);
    expect(actual).to.have.length(3);
    expect(actual[0]).to.equal('lower');
    expect(actual[1]).to.equal('upper');
    expect(actual[2]).to.equal('mixed');
  });

  it('matches multiple keys', function() {
    var haystack = {
      'key0': {
        title: 'chef: How I Cooked Something'
      },
      'key1': {
        description: 'Building something with chef 13'
      }
    };
    var actual = search.search('chef', haystack);
    expect(actual).to.have.length(2);
    expect(actual[0]).to.equal('key0');
    expect(actual[1]).to.equal('key1');
  });

  it('does not break on null results ', function() {
    var haystack = {
      'key0': {
        title: null
      },
      'key1': {
        description: 'Building something with chef 13'
      }
    };
    var actual = search.search('chef', haystack);
    expect(actual).to.have.length(1);
    expect(actual[0]).to.equal('key1');
  });

  it('searches for each space-delimited word indivudually', function() {
    var haystack = {
      'key': {
        another_key: 'This is a long sentence in order'
      }
    };
    var actual = search.search('long foo', haystack);
    expect(actual).to.have.length(1);
    expect(actual[0]).to.equal('key');
  });
});

