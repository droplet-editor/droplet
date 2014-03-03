/*
 * file: 			router.js
 * description: 	used to route HTTP commands to specific files
 * author: 			Aaron Stannard
 * created: 		8/12/2013
 * last-modified: 	8/13/2013
 */

 var url = require('url');
 require('../util/string');
 var formidable = require('formidable'); //used for processing multi-part file uploads

 /*
  * Router prototype
  */
Router = function (options, fs){
	this.dir = options.dir;
	this.readonly = options.readonly;
	this.logger = options.logger;
	this.fs = fs; //file-system agent
}

 /*
  * Path method - parses the relative file path from the request
  */
Router.prototype.parsePath = function(req){
	return decodeURI(url.parse(req.url).pathname);
}

 /*
  * Output method - writes output to the filestream based on what {fs} returns
  */
Router.prototype.output = function(err, data, res){
	var self = this;
	if(err){
		res.writeHead(err.code, {'Content-Type':'text/plain'});
		var message = JSON.stringify(err.message);
		self.logger.log('HTTP {0} {1}'.format(err.code, message));
		res.end(message);
		return;
	}

	if(data){
		self.logger.log('HTTP {0}'.format(data.code));
		res.writeHead(data.code, {'Content-Type':data.contentType});
		res.end(data.data);
	}
}

 /*
  * parseFile method - used to handle file uploads from multipart form POSTs
  */
Router.prototype.parseFile = function(req, fn){
	var self = this;
	var form = new formidable.IncomingForm();
	self.logger.verbose('parsing request for file content...');

	form.parse(req, function(error, fields, files){
		if(error){ 
			self.logger.verbose('failed to parse file upload. Error: {0}'.format(JSON.stringify(error)));
			return fn(error);
		}

		var file = {};

		for(var prop in files) {
			if(files.hasOwnProperty(prop))
        		file = files[prop];
		}

		self.logger.verbose(
			'successfully parsed upload for file {0}; saved to temporary location {1}'.format(
				file.name,
				file.path
			)
		);

		return fn(null, file);
	});
}

 /*
  * Listen method - used to handle incoming requests
  */
Router.prototype.listen = function(req, res){
	var self = this;
	var path = self.parsePath(req);

	//cut out the noise from favicon
	if(path.indexOf("favicon.ico") > 0){
		res.writeHead(200);
		res.end();
		return;
	}

	self.logger.log("received {0} request for {1} from {2} ({3})".format(req.method, path, req.headers.host, req.headers['user-agent']));
	if(req.method == "GET"){
		return self.fs.read(path, req, function(err, data){
			self.output(err, data, res);
		});
	}

	//Don't process any other methods if we're running in read-only mode
	if(self.readonly){
		var errorMessage = "server is in ready-only mode. {0} to path {1} is unauthorized.".format(req.method, path);
		self.logger.log(errorMessage);
		res.writeHead("401", {"Content-Type":"text/plain"});
		res.end(errorMessage);
		return;
	}

	if(req.method == "POST"){
		return self.parseFile(req, function(err, file){
			var serverErr = {
					code: 500,
					message: JSON.stringify(err)
			};
			if(err) return self.output(serverErr, null, res);
			self.fs.write(path, req, file, function(err, data){
				self.output(err, data, res);
			});
		});
		
	}

	if(req.method == "PUT"){
		res.writeHead(501);
		res.end();
		return;
	}

	if(req.method == "DELETE"){
		return self.fs.delete(path, req, function(err, data){
			self.output(err, data, res);
		});
	}
}

module.exports.Router = Router;
