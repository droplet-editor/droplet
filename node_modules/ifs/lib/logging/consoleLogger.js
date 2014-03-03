/*
 * file: 			consoleLogger.js
 * description: 	Logs all output to STDOUT
 * author: 			Aaron Stannard
 * created: 		8/12/2013
 * last-modified: 	8/12/2013
 */

 Logger = function(options){
 	this.useVerbose = options.verbose;
 }

 Logger.prototype.log = function(logStr){
 	console.log("{0}: {1}".format(new Date().toISOString(), logStr));
 }

 Logger.prototype.verbose = function(logStr){
 	if(this.useVerbose)
 		this.log(logStr);
 }

 module.exports.Logger = Logger;