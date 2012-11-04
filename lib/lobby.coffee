userlib = require("../lib/user.js")
class Lobby
	users: []
	i: 0
	createUser: (stream) ->
		u = new userlib.User("user_" + @i, this, stream)
		@users.push(u)
		@i += 1
		return u
	remove: (user) ->
		@users.splice(@users.indexOf(user), 1)
exports.Lobby = Lobby