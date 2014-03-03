/*
 * file: 			args.js
 * description: 	used to process command-line arguments for instant-server
 * author: 			Aaron Stannard
 * created: 		8/12/2013
 * last-modified: 	8/13/2013
 */

"use strict";
var ArgumentParser = require("argparse").ArgumentParser;
var parser = new ArgumentParser({
	version: "0.1.11",
	addHelp: true,
	description: 'instant-fileserver (ifs)'
});

parser.addArgument(
	['-d','--dir'],
	{
		help: 'the root directory for the server to service its requests',
		nargs: 1,
		required: false,
		defaultValue: process.cwd()
	}
);

parser.addArgument(
	['-r','--readonly'],
	{
		help: 'run the server in read-only mode',
		nargs: 0,
		required: false,
		defaultValue:false
	}
);

parser.addArgument(
	['-p','--port'],
	{
		help: 'specify which port to use for handling incoming requests',
		nargs: 1,
		required: false,
		type:'int',
		defaultValue: 1337
	}
);

parser.addArgument(
	['-H','--hostname'],
	{
		help: 'specify a hostname for inbound requests',
		nargs: 1,
		required: false
	}
);
var parse = module.exports = function parse(args){ return parser.parseArgs(args); }