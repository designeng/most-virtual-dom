most = require "most"
h = require "virtual-dom/h"

model = require('lib/model')
view = require('lib/view')

console.debug "model:::", model
console.debug "view:::", view

exports.main = ->
    appWrapper = document.getElementById('application')

    actions = createController(appWrapper)

createController = (el) ->



# Action to add a todo given
# @param e
# @returns {Function}
addTodo = (e) ->
    description = e.target.elements.description.value
    e.target.reset()

    return (todos) ->
        return todos.concat Todo.create(description)