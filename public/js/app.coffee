postprocessing = {}
initPostprocessing = ()->

	postprocessing.scene = new THREE.Scene()
	postprocessing.camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2,  window.innerHeight / 2, window.innerHeight / - 2, -10000, 10000 )
	postprocessing.camera.position.z = 100
	postprocessing.scene.add( postprocessing.camera )
	pars = { minFilter: THREE.LinearFilter, magFilter: THREE.LinearFilter, format: THREE.RGBFormat }
	postprocessing.rtTextureDepth = new THREE.WebGLRenderTarget( window.innerWidth, window.innerHeight, pars )
	postprocessing.rtTextureColor = new THREE.WebGLRenderTarget( window.innerWidth, window.innerHeight, pars )
	bokeh_shader = THREE.BokehShader
	postprocessing.bokeh_uniforms = THREE.UniformsUtils.clone( bokeh_shader.uniforms )
	postprocessing.bokeh_uniforms[ "tColor" ].value = postprocessing.rtTextureColor
	postprocessing.bokeh_uniforms[ "tDepth" ].value = postprocessing.rtTextureDepth
	postprocessing.bokeh_uniforms[ "focus" ].value = 1.05
	postprocessing.bokeh_uniforms[ "aspect" ].value = window.innerWidth / window.innerHeight
	postprocessing.materialBokeh = new THREE.ShaderMaterial( {
		uniforms: postprocessing.bokeh_uniforms,
		vertexShader: bokeh_shader.vertexShader,
		fragmentShader: bokeh_shader.fragmentShader
	} )

	postprocessing.quad = new THREE.Mesh( new THREE.PlaneGeometry( window.innerWidth, window.innerHeight ), postprocessing.materialBokeh );
	postprocessing.quad.position.z = - 500;
	postprocessing.scene.add( postprocessing.quad );

initPostprocessing()
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1,5000)
renderer = new THREE.WebGLRenderer(
	antialias: true
	)
renderer.shadowMapEnabled = true;
renderer.shadowMapSoft = true;
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

cubes = []
material_depth = new THREE.MeshDepthMaterial();
#Cubemap
r = "/img/skybox/"
urls = [ r + "4.png", r + "2.png", r + "6.png", r + "5.png", r + "1.png", r + "3.png" ]
materialArray = []
materialArray.push(new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture(urls.pop()) }))
materialArray.push(new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture(urls.pop()) }))
materialArray.push(new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture(urls.pop()) }))
materialArray.push(new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture(urls.pop()) }))
materialArray.push(new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture(urls.pop()) }))
materialArray.push(new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture(urls.pop()) }))
skyboxGeom = new THREE.CubeGeometry( -4000, -4000, -4000, 1, 1, 1, materialArray )
skybox = new THREE.Mesh( skyboxGeom, new THREE.MeshFaceMaterial() )
skybox.flipSided = true;
scene.add( skybox )
cubes.push(skybox)
###
textureCube = THREE.ImageUtils.loadTextureCube( urls, new THREE.CubeRefractionMapping() )

shader = THREE.ShaderUtils.lib[ "cube" ]

shader.uniforms[ "tCube" ].texture = textureCube

material = new THREE.ShaderMaterial( {
	fragmentShader: shader.fragmentShader,
	vertexShader: shader.vertexShader,
	uniforms: shader.uniforms
} )

mesh = new THREE.Mesh( new THREE.CubeGeometry( 100, 100, 100 ), material )
mesh.flipSided = true
###
geometry = new THREE.CubeGeometry(1, 1, 1)
material = new THREE.MeshLambertMaterial({
	color: 0x334455
})

for i in[0 ... 25]
	cube = new THREE.Mesh(geometry, material)
	scene.add(cube)
	cube.position.y = Math.random() * 3
	cube.position.z = Math.random() * 3
	cube.position.x = Math.random() * 3
	cubes.push(cube)

directionalLight = new THREE.DirectionalLight( 0xffffff,1 )
directionalLight.position.set( 0.5, 1, 1 )
scene.add( directionalLight )
directionalLight = new THREE.DirectionalLight( 0x778899,0.4 )
directionalLight.position.set( -0.5, -1, 1 )
scene.add( directionalLight )
camera.position.z = 5
draw =->
	requestAnimationFrame(draw)
	i = 0
	for c in cubes
		c.rotation.x += 0.01 + (i+=0.0003)
		c.rotation.y += 0.01+ (i+=0.00003)
		c.rotation.z += 0.01+ (i+=0.00003)
		c.position.x += 0.01+ (Math.sin(i+=0.00003))
		c.position.y += 0.01+ (Math.sin(i+=0.00003))
		c.position.z += 0.01+ (Math.sin(i+=0.00003))

	#cameraCube.rotation.y += 0.01+ (i+=0.003)
	skybox.position = camera.position
	renderer.clear();

	# Render scene into texture

	scene.overrideMaterial = null;
	renderer.render( scene, camera, postprocessing.rtTextureColor, true );

	#Render depth into texture

	scene.overrideMaterial = material_depth;
	renderer.render( scene, camera, postprocessing.rtTextureDepth, true );

	# Render bokeh composite

	renderer.render( postprocessing.scene, postprocessing.camera );
	#renderer.render(scene, camera)
	
draw()
