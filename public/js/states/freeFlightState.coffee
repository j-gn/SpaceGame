
class window.FreeFlightState
	constructor:( app )->
		@app = app
		@camera = app.camera
		@scene = app.scene
		@renderItems = []

	addItem: ( i ) ->
		@renderItems.push(i)		
		@scene.add(i)

	addRemoveItem: ( i ) ->
		index = @renderItems.indexOf( i );
		if ( index != - 1 )
			@renderItems.splice( index, 1 );
			@scene.remove(i)

	begin:->
		##setup some lights
		directionalLight = new THREE.DirectionalLight(0xffffff,1)
		directionalLight.position.set( 0.5, 1, 1 )
		@addItem( directionalLight )
		directionalLight = new THREE.DirectionalLight(0x778899,0.4)
		directionalLight.position.set( -0.5, -1, 1 )
		@addItem( directionalLight )

		##add a few cubes
		geometry = new THREE.CubeGeometry(1, 1, 1)
		material = new THREE.MeshLambertMaterial(color: 0x334455)
		for i in[0 ... 25]
			cube = new THREE.Mesh(geometry, material)
			@scene.add(cube)
			cube.position.y = Math.random() * 3
			cube.position.z = Math.random() * 3
			cube.position.x = Math.random() * 3
			@addItem(cube)

	end:->
		self = @
		self.renderItems.forEach((i) ->
			self.scene.remove(i)
		)

	update:(deltaTime)->
		self =@
		i = 0
		for c in self.renderItems
			c.rotation.x += 0.01 + (i+=0.0003)
			c.rotation.y += 0.01+ (i+=0.00003)
			c.rotation.z += 0.01+ (i+=0.00003)
			c.position.x += 0.01+ (Math.sin(i+=0.00003))
			c.position.y += 0.01+ (Math.sin(i+=0.00003))
			c.position.z += 0.01+ (Math.sin(i+=0.00003))

