MulticastSource = require('most/lib/source/MulticastSource')
Stream = require('most/lib/Stream')

module.exports = (actions, store) ->
    updates = actions.scan (store, action) ->
        return store.map action
    , store

    return new Stream(new MulticastSource(updates.source))