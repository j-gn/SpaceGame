THREE = require('../lib/THREEMath.js').THREE 

class SpaceShip
	constructor:()->
		@matrix = new THREE.Matrix4()

spaceLib = require("../lib/space.js")
exports['create space ship'] = ( test ) ->
	space = new spaceLib.Space()
	ship = space.addObject(new SpaceShip())
	test.done()