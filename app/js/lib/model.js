var MulticastSource, Stream;

MulticastSource = require('most/lib/source/MulticastSource');

Stream = require('most/lib/Stream');

module.exports = function(actions, store) {
  var updates;
  updates = actions.scan(function(store, action) {
    return store.map(action);
  }, store);
  return new Stream(new MulticastSource(updates.source));
};
