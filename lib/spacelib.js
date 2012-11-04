var veclib = require("../lib/vector3.js");
var diclib = require("../lib/dictionary.js");
function Space(){
	this.sectors = new diclib.Dictionary();
	this.sectors.defaultValue = function(v3){ return {sector:v3, units:[]} };
}
Space.prototype.getSector = function( v3 ){
	return this.sectors.fetch(v3);
}

exports.Space = Space;