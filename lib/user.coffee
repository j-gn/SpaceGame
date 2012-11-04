class User
	parseMessage: (m) ->
		if m.credentials != undefined then @credentials = m.credentials
		else console.log("got unhandled message of type " + m.type)
	quit: (data) ->
		@lobby.remove(this)

	constructor: (name, @lobby, @stream) ->
		self = this;
		@credentials = name:name
		@stream.on('json',(data) -> self.parseMessage(data))
		@stream.on('disconnect', -> self.quit())

exports.User = User