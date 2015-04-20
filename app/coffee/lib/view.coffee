diff = require('virtual-dom/diff')
patch = require('virtual-dom/patch')
createElement = require('virtual-dom/create-element')
Promise = require('when').Promise

runPatch = (el, patches, newTree) ->
    new ViewState(patch(el, patches), newTree)

ViewState = (el, tree) ->
    @el = el
    @tree = tree

Task = (f, x, y, z, resolve) ->
    @f = f
    @x = x
    @y = y
    @z = z
    @resolve = resolve

enqueue = (f, x, y, z) ->
    new Promise (resolve) ->
        if tasks.length == 0
            requestAnimationFrame runTasks
        tasks.push new Task(f, x, y, z, resolve)

runTasks = ->
    q = tasks
    tasks = []
    i = 0
    l = q.length
    while i < l
        q[i].run()
        ++i

module.exports = (render, updates, el) ->
    return updates.scan (state, store) ->
        return state.then (state) ->
            store.map (data) ->
                newTree = render(data)
                if state.tree == null
                    newEl = createElement(newTree)
                    el.parentNode.replaceChild newEl, el
                    state = new ViewState(newEl, newTree)
                else
                    patches = diff(state.tree, newTree)
                    state = enqueue(runPatch, state.el, patches, newTree)
                return data
            return state
    , Promise.resolve(new ViewState(el, null))

tasks = []

Task::run = ->
    f = @f
    @resolve f(@x, @y, @z)