class JsonDiff
	##warning this method changes oA
	merge:(oA, oB)->
		self = this
		if(typeof oB is "object")
			if(oB.__isArray == undefined)
				for k in Object.keys(oB)
					oA[k] = self.merge(oA[k], oB[k])
				return oA
			else
				for item in oB.__updates
					oA[item.k] = self.merge(oA[item.k],item.v)
				return oA
		else
			return oB

	getDelta:(oA, oB)->
		self = @
		delta = undefined
		if(oA == undefined)
			delta = oB
		else if(typeof oB is "object")
			if(Array.isArray(oB))
				if(oB.length != oA.length)
					return delta = oB
				Object.keys(oB).forEach((key) ->
					d = self.getDelta(oA[key], oB[key])
					if(d != undefined) #if key has diff, add diff
						if(delta == undefined)
							delta = new Object()
							delta.__isArray = true
							delta.__updates = []
						delta.__updates.push({k:key,v:d})
				)
			else
				Object.keys(oB).forEach((key) ->
					d = self.getDelta(oA[key], oB[key])
					if(d != undefined)
						if(delta == undefined)
								delta = new Object()
						delta[key] = d
				)
		else if(oA != oB)
			delta = oB

		return delta
exports.JsonDiff = JsonDiff