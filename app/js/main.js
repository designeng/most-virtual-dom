var addTodo, createController, h, model, most, view;

most = require("most");

h = require("virtual-dom/h");

model = require('lib/model');

view = require('lib/view');

console.debug("application", model);

exports.main = function() {
  var actions, appWrapper;
  appWrapper = document.getElementById('application');
  return actions = createController(appWrapper);
};

createController = function(el) {};

addTodo = function(e) {
  var description;
  description = e.target.elements.description.value;
  e.target.reset();
  return function(todos) {
    return todos.concat(Todo.create(description));
  };
};
