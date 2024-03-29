// Generated by CoffeeScript 1.4.0
(function() {
  var eventlib, lobbylib, obsLib, userlib;

  userlib = require("../lib/user.js");

  eventlib = require('events');

  lobbylib = require("../lib/lobby.js");

  obsLib = require("../lib/observer.js");

  exports['new object'] = function(test) {
    var actor, observer, state;
    actor = {
      name: "some bloke",
      x: 10,
      y: 0,
      z: 3,
      deep: {
        asd: 100
      }
    };
    observer = new obsLib.Observer();
    state = observer.getState();
    console.log("state : -->" + JSON.stringify(state) + "<--");
    test.equals(state, null);
    observer.addObject(actor);
    state = observer.getState();
    test.equals(JSON.stringify(state), JSON.stringify({
      added: [actor]
    }));
    console.log("state : -->" + JSON.stringify(state) + "<--");
    state = observer.getState();
    test.equals(state, null);
    console.log("state : -->" + JSON.stringify(state) + "<--");
    actor.x = -100;
    actor.deep.asd = "quake";
    state = observer.getState();
    test.equals(JSON.stringify(state), JSON.stringify({
      existing: [
        {
          x: -100,
          deep: {
            asd: "quake"
          }
        }
      ]
    }));
    observer.removeObject(function(t) {
      return t.deep.asd === "quake";
    });
    state = observer.getState();
    test.equals(JSON.stringify(state), JSON.stringify({
      removed: [actor]
    }));
    console.log("state : -->" + JSON.stringify(state) + "<--");
    return test.done();
  };

}).call(this);
