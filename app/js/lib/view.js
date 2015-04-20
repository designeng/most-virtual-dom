var Promise, Task, ViewState, createElement, diff, enqueue, patch, runPatch, runTasks, tasks;

diff = require('virtual-dom/diff');

patch = require('virtual-dom/patch');

createElement = require('virtual-dom/create-element');

Promise = require('when').Promise;

runPatch = function(el, patches, newTree) {
  return new ViewState(patch(el, patches), newTree);
};

ViewState = function(el, tree) {
  this.el = el;
  return this.tree = tree;
};

Task = function(f, x, y, z, resolve) {
  this.f = f;
  this.x = x;
  this.y = y;
  this.z = z;
  return this.resolve = resolve;
};

enqueue = function(f, x, y, z) {
  return new Promise(function(resolve) {
    if (tasks.length === 0) {
      requestAnimationFrame(runTasks);
    }
    return tasks.push(new Task(f, x, y, z, resolve));
  });
};

runTasks = function() {
  var i, l, q, tasks, _results;
  q = tasks;
  tasks = [];
  i = 0;
  l = q.length;
  _results = [];
  while (i < l) {
    q[i].run();
    _results.push(++i);
  }
  return _results;
};

module.exports = function(render, updates, el) {
  console.debug("VIEW::::::::::::::::::::");
  return updates.scan(function(state, store) {
    return state.then(function(state) {
      store.map(function(data) {
        var newEl, newTree, patches;
        newTree = render(data);
        if (state.tree === null) {
          newEl = createElement(newTree);
          el.parentNode.replaceChild(newEl, el);
          state = new ViewState(newEl, newTree);
        } else {
          patches = diff(state.tree, newTree);
          state = enqueue(runPatch, state.el, patches, newTree);
        }
        return data;
      });
      return state;
    });
  }, Promise.resolve(new ViewState(el, null)));
};

tasks = [];

Task.prototype.run = function() {
  var f;
  f = this.f;
  return this.resolve(f(this.x, this.y, this.z));
};
