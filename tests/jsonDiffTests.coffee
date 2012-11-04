lib = require('../lib/jsonDiff.js')

compareObjects = (oA, oB, test) ->
	a = JSON.stringify(oA)
	b = JSON.stringify(oB)
	console.log("expected: " + a)	
	console.log("provided: " + b)	
	return test.equal(a,b)

exports['basic diff'] = (test)->
	countryA =
		name: "Argentina"
		music: "Jazz"
	countrB =
		name: "Sweden"
		music: "Jazz"
		fun:(qwe,ewq)-> #should ignore functions
			console.log(qwe)
	expectedDelta = 
		name: "Sweden"

	d = new lib.JsonDiff()
	delta = d.getDelta(countryA, countrB)
	compareObjects(expectedDelta, delta, test)
	test.done()

exports['nested objects'] = (test)->
	countryA =
		name: "Argentina"
		music: 
			song_length:10
			song_name:"sad song"
	countrB =
		name: "Sweden"
		music: 
			song_length:4
			song_name:"sad song"

	expectedDelta = 
		name: "Sweden"
		music:
			song_length:4

	d = new lib.JsonDiff()
	delta = d.getDelta(countryA, countrB)
	compareObjects(expectedDelta, delta, test)
	test.done()

exports['arrays size change'] = (test)->
	countryA =
		name: "Argentina"
		music: 
			song_length:4
			song_name:"sad song"
			tracks:[1,3,5]
	countrB =
		name: "Sweden"
		music: 
			song_length:4
			song_name:"sad song"
			tracks:[1,5]

	expectedDelta = 
		name: "Sweden"
		music:
			tracks:[1,5]

	d = new lib.JsonDiff()
	delta = d.getDelta(countryA, countrB)
	compareObjects(expectedDelta, delta, test)
	test.done()
exports['arrays value change'] = (test)->
	countryA =
		name: "Argentina"
		music: 
			song_length:4
			song_name:"sad song"
			tracks:[1,0,5]
	countrB =
		name: "Sweden"
		music: 
			song_length:4
			song_name:"sad song"
			tracks:[1,0,6]

	expectedDelta = 
		name: "Sweden"
		music:
			tracks:
				__isArray: true
				__updates:[
					k:"2"
					v:6
				]
				

	d = new lib.JsonDiff()
	delta = d.getDelta(countryA, countrB)
	compareObjects(expectedDelta, delta, test)
	merged = d.merge(countryA, expectedDelta)
	compareObjects(countrB, merged, test)
	test.done()

exports['Vector3'] = (test)->
	THREE = require('../lib/THREEMath.js').THREE
	countryA = new THREE.Vector3(1,2,3)
	countrB = new THREE.Vector3(0,2,1)
	expectedDelta = 
		x:0
		z:1
	d = new lib.JsonDiff()
	delta = d.getDelta(countryA, countrB)
	compareObjects(expectedDelta, delta, test)
	test.done()

exports['complex array'] = (test)->
	stateA =[1,3,5,{x:10,b:[10,3]}]
	stateB =[1,2,5,{x:10,b:[10,2]}]

	expectedDelta = {
		__isArray:true,
		__updates:[
			{k:"1", v:2},
			{k:"3", v:{
					b:{
						__isArray:true, __updates:[{k:"1",v:2}]
					}
				}
			}
		]
	}

	d = new lib.JsonDiff()
	delta = d.getDelta(stateA, stateB)
	compareObjects(expectedDelta, delta, test)
	merged = d.merge(stateA, delta)
	compareObjects(stateB, merged, test)
	test.done()
