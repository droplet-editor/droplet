/*
 * file: 			fileSysAgent.js
 * description: 	used to translate HTTP requests into filesystem commands
 					can be sub-classed to work with other types of file systems, like Amazon S3.

 * author: 			Aaron Stannard
 * created: 		8/12/2013
 * last-modified: 	8/13/2013
 */

var fs = require('fs'),
	path = require('path'); //built-in filesystem

var mmm = require('mmmagic'), //MIME-type detection
  Magic = mmm.Magic;

var magic = new Magic(mmm.MAGIC_MIME_TYPE | mmm.MAGIC_MIME_ENCODING);
var wrench = require('wrench'); //recursive folder delete and other file utilities

require('../util/string');

FileSysAgent = function (options){
	this.dir = options.dir;
	this.readonly = options.readonly;
	this.logger = options.logger;
}

FileSysAgent.prototype.formatPath = function(relPath){
	var absPath = path.join(this.dir, relPath);
	console.log('requesting absolute path {0}'.format(absPath));
	return absPath;
}

FileSysAgent.prototype.readFileResponse = function(absolutePath, fn){
	var self = this;
	self.logger.verbose('determining MIME type for {0}'.format(absolutePath));
	magic.detectFile(absolutePath, function(err, result){
		if(err){
			self.logger.verbose('Exception! unable to determine MIME type for {0}'.format(absolutePath));
			return fn(err);
		} 
		var encoding = result.substr(result.indexOf("charset=") + "chartset=".length); 
		fs.readFile(absolutePath, function(err, data){
			if(err){
				var serverErr = {
					code: 500,
					message: err
				};
				self.logger.verbose('Exception! Unable to open {0} for reads'.format(absolutePath));
				return fn(serverErr);
			}

			self.logger.verbose('Opened {0} for reads successfully'.format(absolutePath));
			var serverResponse = {
				code: 200,
				message: "OK",
				contentType: result,
				data: data
			};

			return fn(null, serverResponse);
		});
	});
}

FileSysAgent.prototype.deleteFileResponse = function(absolutePath, fn){
	var self = this;
	self.logger.verbose('deleting file {0}'.format(absolutePath));

	fs.unlink(absolutePath, function (err) {
  		if (err){
  			var serverErr = {
				code: 500,
				message: JSON.stringify(err)
			};

			return fn(serverErr);
  		}

  		var serverResponse = {
				code: 204,
				message: "OK",
				contentType: "text/html",
				data: '{0} deleted'.format(absolutePath)
		};
		self.logger.log(serverResponse.data);

		return fn(null, serverResponse);
	});
}

FileSysAgent.prototype.writeFileResponse = function(absolutePath, file, fn){
	var self = this;
	self.logger.verbose('creating file {0}'.format(absolutePath));

	var readStream = fs.createReadStream(file.path);
	var writeStream = fs.createWriteStream(absolutePath);

	readStream.pipe(writeStream);
	readStream.on('end',function(err) {
		if(err){
			var serverErr = {
					code: 500,
					message: err
				};
			self.logger.verbose('Exception! Unable to move uploaded file from {0} to {1}'.format(file.path, absolutePath));
			return fn(serverErr);
		}

	    

	    var serverResponse = {
				code: 201,
				message: "CREATED",
				contentType: "text/html",
				data: "successfully uploaded file to {0}".format(absolutePath)
		};
		self.logger.log(serverResponse.data);
		fs.unlink(file.path);

		return fn(null, serverResponse);
	});
}

FileSysAgent.prototype.readDirectoryResponse = function(absolutePath, relativePath, fn){
	var self = this;
	self.logger.verbose('generating directory listing for {0}'.format(absolutePath));
	fs.readdir(absolutePath, function(err, files){
		if(err){
			var serverErr = {
					code: 500,
					message: err
				};
				self.logger.verbose('Exception! Unable to read files from directory {0}'.format(relativePath));
				return fn(serverErr);
		}

		var response = "<html><head><title>Contents of {0}</title></head><body>".format(relativePath);
		response += "<h1>Contents of {0}</h1>".format(relativePath);

		//If there's a parent folder above this one...
		if(relativePath != "/"){
			response += '<p><a href="../">...parent</a></p>';
		}

		response += "<ul>";
		files.forEach(function(file){
			var fileName = path.join(relativePath, file);
			var filePath = fileName.replace(/[\ ]/gi, '%20');
			response += '<li><a href="{0}">{1}</li>'.format(filePath,fileName);
		});
		response += "</ul></body></html>";

		var serverResponse = {
				code: 200,
				message: "OK",
				contentType: "text/html",
				data: response
		};

		return fn(null, serverResponse);
	});
}

FileSysAgent.prototype.deleteDirectoryResponse = function(absolutePath, fn){
	var self = this;
	self.logger.verbose('deleting directory for {0}'.format(absolutePath));
	try{
		wrench.rmdirSyncRecursive(absolutePath, false);

		var serverResponse = {
				code: 204,
				message: "OK",
				contentType: "text/html",
				data: '{0} deleted'.format(absolutePath)
		};
		self.logger.log(serverResponse.data);

		return fn(null, serverResponse);
	} catch(err){
		var serverErr = {
				code: 500,
				message: JSON.stringify(err)
		};

		return fn(serverErr);
	}	
}

FileSysAgent.prototype.exists = function(absolutePath, fn){
	fs.exists(absolutePath, function(exists){
		fn(exists);
	});
}

FileSysAgent.prototype.isDirectory = function(absolutePath, fn){
	var fStats = fs.statSync(absolutePath);
	return fn(fStats.isDirectory());
}

FileSysAgent.prototype.read = function(relPath, req, fn){
	var self = this;
	var absolutePath = self.formatPath(relPath);
	self.logger.verbose('receiving file read request for {0}'.format(absolutePath));

	self.exists(absolutePath, function(exists){
		if(exists == true){
			self.isDirectory(absolutePath, function(isDir){
				if(isDir){
					self.logger.verbose('directory {0} found on disk'.format(absolutePath));
					return self.readDirectoryResponse(absolutePath, relPath, fn);
				}
				else{
					self.logger.verbose('file {0} found on disk'.format(absolutePath));
					return self.readFileResponse(absolutePath, fn);
				}
			});
			
		} else {
			self.logger.verbose('file {0} not found on disk. HTTP: 404'.format(absolutePath));
			var serverErr = {
				code: 404,
				message: "could not find file {0}".format(absolutePath)
			};

			return fn(serverErr);
		}
	});
}

FileSysAgent.prototype.delete = function(relPath, req, fn){
	var self = this;
	var absolutePath = self.formatPath(relPath);
	self.logger.verbose('receiving file delete request for {0}'.format(absolutePath));

	self.exists(absolutePath, function(exists){
		if(exists == true){
			self.isDirectory(absolutePath, function(isDir){
				if(isDir){
					self.logger.verbose('directory {0} found on disk'.format(absolutePath));
					return self.deleteDirectoryResponse(absolutePath, fn);
				}
				else{
					self.logger.verbose('file {0} found on disk'.format(absolutePath));
					return self.deleteFileResponse(absolutePath, fn);
				}
			});
			
		} else {
			self.logger.verbose('file {0} not found on disk. HTTP: 404'.format(absolutePath));
			var serverErr = {
				code: 404,
				message: "could not find file {0}".format(absolutePath)
			};

			return fn(serverErr);
		}
	});
}

FileSysAgent.prototype.write = function(relPath, req, fileData, fn){
	var self = this;
	var absolutePath = self.formatPath(relPath);
	self.logger.verbose('receiving file write request for {0}'.format(absolutePath));

	self.exists(absolutePath, function(exists){
		if(exists == true){
			self.isDirectory(absolutePath, function(isDir){
				if(isDir){
					self.logger.verbose('directory {0} found on disk - using uploaded filename ({1}) for absolute file path'.format(absolutePath, fileData.name));
					absolutePath = path.join(absolutePath, fileData.name); //use the name of the upload if none specified in path
				}

				return self.writeFileResponse(absolutePath, fileData, fn);
			});			
		}

		return self.writeFileResponse(absolutePath, fileData, fn);
	});
}

module.exports.FileSysAgent = FileSysAgent;