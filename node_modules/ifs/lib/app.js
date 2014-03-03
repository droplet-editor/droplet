/*
 * file: 			app.js
 * description: 	main instant-server code file. Parses arguments, selects file system agent, and starts accepting requests.
 * author: 			Aaron Stannard
 * created: 		8/12/2013
 * last-modified: 	8/12/2013
 */

"use strict";
require('./util/string');
var InstantServerApp = require('./server/server').App,
	FileSysAgent = require('./filesys/fileSysAgent').FileSysAgent,
	Logger = require('./logging/consoleLogger.js').Logger;

var options = require('./util/args')(process.argv.slice(2));


console.log("starting instant-server on {0}:{1} for directory {2}".format(options.host || "0.0.0.0", options.port, options.dir));

var logger = new Logger({verbose:true});
options.logger = logger;
var fsAgent = new FileSysAgent(options);
var app = new InstantServerApp(options, fsAgent);
app.listen();