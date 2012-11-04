userlib = require("../lib/user.js")
eventlib = require('events');
lobbylib = require("../lib/lobby.js")
obsLib = require("../lib/observer.js")

exports['new object'] = (test) ->
	actor = 
		name: "some bloke"
		x: 10
		y: 0
		z: 3
		deep:
			asd:100

	observer = new obsLib.Observer()
	
	#get null state
	state = observer.getState()
	console.log("state : -->" + JSON.stringify(state) + "<--")
	test.equals(state, null)
	observer.addObject(actor)
	
	#get new item state
	state = observer.getState()
	test.equals(JSON.stringify(state), JSON.stringify({added:[actor]}))
	console.log("state : -->" + JSON.stringify(state) + "<--")
	
	##get null state
	state = observer.getState()
	test.equals(state, null)
	console.log("state : -->" + JSON.stringify(state) + "<--")
	
	#get x changed state
	actor.x = -100
	actor.deep.asd = "quake"
	state = observer.getState()
	test.equals(JSON.stringify(state), JSON.stringify({existing:[{x:-100, deep:{asd:"quake"}}]}))

	#remove and object
	observer.removeObject( (t) -> t.deep.asd == "quake" )
	state = observer.getState()
	test.equals(JSON.stringify(state), JSON.stringify({removed:[actor]}))
	console.log("state : -->" + JSON.stringify(state) + "<--")
	test.done()



