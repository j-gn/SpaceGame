diffLib = require("../lib/jsonDiff.js")
class Observer
	removeObject:( compareFunc ) ->
		self = @
		indexToRemove = "-1"
		Object.keys(self.existing).forEach((p)->
			if(compareFunc(self.existing[p].obj) == true)
				indexToRemove = p
		)
		if(indexToRemove != "-1") 
			self.removed.push(self.existing[parseInt(indexToRemove)])
			self.existing.splice(parseInt(indexToRemove), 1)
			return
		indexToRemove = "-1"
		Object.keys(self.added).forEach((p)->
			if(compareFunc(self.added[p].obj) == true)
				indexToRemove = p
		)
		if(indexToRemove != "-1") 
			self.removed.push(self.added[parseInt(indexToRemove)])
			self.added.splice(parseInt(indexToRemove), 1)


	addObject:( obj )->
		@added.push(
			obj: obj
			)

	getState:()->
		self = @
		deltaState = {}
		
		@existing.forEach((p)->
			d = self.diffTool.getDelta(p.lastState, p.obj)
			if(d != undefined)
				if(deltaState.existing == undefined) 
					deltaState.existing = []
				deltaState.existing.push(d)
				p.lastState = JSON.parse(JSON.stringify(p.obj))
		)
		@added.forEach((p)->
			d = self.diffTool.getDelta(p.lastState, p.obj)
			if(d != undefined)
				if(deltaState.added == undefined) 
					deltaState.added = []
				deltaState.added.push(d)
				p.lastState = JSON.parse(JSON.stringify(p.obj))
			self.existing.push(p)
		)
		@added = []

		@removed.forEach((p)->
			if(deltaState.removed == undefined) 
				deltaState.removed = []
			deltaState.removed.push(JSON.parse(JSON.stringify(p.obj)))
		)
		@removed = []

		if( Object.keys(deltaState).length == 0 )
			return null
		else 
			return deltaState
		
		
	constructor:()->
		@diffTool = new diffLib.JsonDiff()
		@added = []
		@existing = []
		@removed = []
		console.log("new observer!")

exports.Observer = Observer