/*
 * file: 			server.js
 * description: 	HTTP server
 * author: 			Aaron Stannard
 * created: 		8/12/2013
 * last-modified: 	8/12/2013
 */
var http = require("http");
var Router = require("./router").Router;


/*
 * Server prototype
 */
App = function(options, fs){
	this.port = options.port;
	this.dir = options.dir;
	this.hostname = options.hostname;
	this.readonly = options.readonly;
	this.fs = fs;
	this.router = new Router(options, fs);
	this.logger = options.logger;
}

/*
 * Listen method - starts the server
 */
App.prototype.listen = function(){
 	var self = this;
 	self.logger.log("server started.")
 	var server = http.createServer(function(req, res){
 		self.router.listen(req, res);
 	});
 	server.listen(parseInt(self.port,10), self.hostname);

 	server.on("close", function(socket){
 		self.logger.log("server closed.");
 	});
 }

module.exports.App = App;