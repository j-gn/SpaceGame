userlib = require("../lib/user.js")
eventlib = require('events');
lobbylib = require("../lib/lobby.js")


exports['create User'] = (test) ->
	testSocket = new eventlib.EventEmitter()
	l = new lobbylib.Lobby()
	user = l.createUser(testSocket)
	console.log("created user: %s", user.credentials.name )
	testSocket.emit('json',	
		credentials: 
			name:"johannes"
			password:"rotten eggs"
		)
	console.log("changed name to: %s", user.credentials.name )
	test.equals(l.users.length, 1)
	testSocket.emit('disconnect', "asd")
	test.equals(l.users.length, 0)
	test.done()

