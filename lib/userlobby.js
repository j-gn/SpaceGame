var events = require('events');
var util = require('util');

//CLASS USER
function User(lobby, stream, username, room){
	var self = this;
	//public properties
	self.name = username;
	self.room = room;
	self.lobby = lobby;
	self.stream = null;
	self.setStream(stream);
};

User.prototype.setStream = function( s ){
	var self = this;
	var buffer = "";
	var jsonDepth = 0;
	self.stream = s;
	self.stream.on('end', function(m){self.quit(m);});
	self.stream.on('close', function(m){self.quit(m);});
	self.stream.on('error', function(m){self.quit(m);});
	self.stream.on('data', function(str)
	{
		
		if(str.charAt == undefined)
		{
			return;
			console.log("#undefined!");
		}
			

		for(var i = 0; i < str.length; i++){
			var c = str.charAt(i);
			switch(c){
				case '}':
				case ']':
					jsonDepth--;
				break;
				case '[':
				case '{':
					jsonDepth++;
				break;
				default:break;
			}
			buffer += c;
			if(jsonDepth === 0)
			{	
				var m;
				try{
					m = JSON.parse(buffer);
				}
				catch(e){
					m = null;
					console.log("#PARSE ERROR" + buffer);
				}

				 
				buffer = "";
				if(m!=null){
					//console.log("#> " + str);
					switch(m.func){
						case "set_room":
							self.joinRoom(m['name']);
						break;
						default:
							m.user = self.name;
							self.sendToOthers(m);
						break;
					}
				}
			}
		}
	});
};
User.prototype.joinRoom = function( roomname ){
	var self = this;
	self.room = roomname;
	for(var i = 0; i < self.lobby.logs[roomname].length; i++){
		self.send(self.lobby.logs[roomname][i]);
	}


	self.sendToOthers({
		func:"user_join",
		room:roomname,
	 	user:self.name,
	 });
};
User.prototype.quit = function( message ){
	var self = this;
	self.lobby.removeUser(self);
	self.sendToOthers({func:"user_quit", user:self.name});
	console.log("user quit " + self.name);
};
User.prototype.send = function( object ){
	var self = this;
	self.stream.write(JSON.stringify(object));
};
User.prototype.sendToOthers = function( message){
	var self = this;
	self.lobby.users.forEach( function(user){ 
		if(user !== self && user.room == self.room)
			user.send(message);
	});
	self.lobby.logs[self.room].push(message);
}
exports.User = User;

function Lobby(){
	var self= this;
	self.users = [];
	self.logs = {};
	self.logs.default_room = [];
	self.usercount = 0;
}

Lobby.prototype.createUser = function( stream ){
	var self = this;
	var newname = "user" + self.usercount++;
	var user = new User(this,stream,newname, "default_room");
	user.send({
		func: "credentials",
		user: newname,
		room: user.room,
		message: "welcome to the server here is your handle"
	});
	self.users.push(user);
	user.joinRoom(user.room);
  	console.log("user connected " + newname);
}
Lobby.prototype.removeUser = function( user )
{
	var self = this;
	self.users.splice(self.users.indexOf(user),1);
}
exports.Lobby = Lobby;