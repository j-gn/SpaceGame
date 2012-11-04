class Space
	constructor:( ) ->
		@objects = []
	addObject:( p ) ->
		@objects.push(p)
	update:( pDeltaTime ) ->
		for o in @objects
			if o.update != undefined then o.update(pDeltaTime)
exports.Space = Space


