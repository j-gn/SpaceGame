class window.App
	setState:( state )->
		if(@currentState != null)
			@currentState.end()
		@currentState = state
		if(@currentState != null)
			@currentState.begin()

	initPostprocessing:()->
		postprocessing = @postprocessing
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

	constructor:->
		self = this
		@currentState = null
		@postprocessing = {}
		@initPostprocessing()
		@scene = new THREE.Scene()
		@camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1,5000)
		renderer = new THREE.WebGLRenderer(antialias: true)
		renderer.shadowMapEnabled = true;
		renderer.shadowMapSoft = true;
		renderer.setSize(window.innerWidth, window.innerHeight)
		document.body.appendChild(renderer.domElement)
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
		@scene.add( skybox )
		@camera.position.z = 5
		@setState(new FreeFlightState(this))
		draw = ()->
			postprocessing = self.postprocessing
			#update state
			if(self.currentState != null)
				self.currentState.update(1/60) #hacked deltatime
				
			requestAnimationFrame(draw)
			skybox.position = self.camera.position
			renderer.clear();
			# Render scene into texture
			self.scene.overrideMaterial = null;
			renderer.render(self.scene, self.camera, postprocessing.rtTextureColor, true );
			#Render depth into texture
			self.scene.overrideMaterial = material_depth;
			renderer.render(self.scene, self.camera, postprocessing.rtTextureDepth, true );
			# Render bokeh composite
			renderer.render( postprocessing.scene, postprocessing.camera );
			#renderer.render(scene, camera)
		draw()
