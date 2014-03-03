/*
 * file: 			deleteFile.js
 * description: 	unit tests to ensure that our file-deleting capabilities work as expected
 * author: 			Aaron Stannard
 * created: 		8/13/2013
 * last-modified: 	8/13/2013
 */

var assert = require('assert'),
	should = require('should'),
	fs = require('fs'),
	path = require('path'),
	wrench = require('wrench');

var FileSysAgent = require('../lib/filesys/fileSysAgent').FileSysAgent,
	Logger = require('../lib/logging/consoleLogger.js').Logger;

var logger = new Logger({verbose:true});

var fsAgent = new FileSysAgent({
	dir: process.cwd(),
	logger: logger
});


var testFile = "helloworld";
var fileName = "helloworld.txt";
var directory = "magicFolder";
var subDirectory = "miniMagic";

var absoluteDirPath = path.join(process.cwd(), directory);
var absoluteFilePath = path.join(absoluteDirPath, fileName);

var relativeFilePath = path.join(directory, fileName);

function initialize(){
	//create our target files
	fs.mkdirSync(absoluteDirPath);
	fs.writeFileSync(absoluteFilePath, testFile);
}

function cleanup(){
	if(fs.existsSync(absoluteFilePath)){
		fs.unlinkSync(absoluteFilePath);
	}

	if(fs.existsSync(absoluteDirPath)){
		wrench.rmdirSyncRecursive(absoluteDirPath, false);
	}
}

/**
 * Tests
 */

describe('filesys agent', function(){

	/**
 	 * Setup
 	 */
 	before(function(done){
 		try{
			cleanup();			
			return done();
		} catch(err){
			return done(err);
		}
 	});

	beforeEach(function(done){
		try{
			initialize();
			return done();
		} catch(err){
			return done(err);
		}
		
	});

	/**
 	 * Teardown
 	 */
	afterEach(function(done){
		try{
			//remove our target files
			cleanup();			
			return done();
		} catch(err){
			return done(err);
		}
	});

	describe('delete file', function(){
		it('should return a 404 when file does not exist', function(done){
			var req = {};
			fsAgent.delete('/fakepath/fake.txt', req, function(err, data){
				if(err){
					err.code.should.equal(404);
					done();
				} else{
					done({message:"test failed - expected an error"});
				}
			});
		});

		it('should return a 204 if the file does exist and has been deleted', function(done){
			var req = {};
			fsAgent.delete(relativeFilePath, req, function(err, data){
				if(err){
					return done(err);
				} else{
					data.code.should.equal(204);
					data.contentType.should.equal("text/html");
					fs.existsSync(absoluteFilePath).should.equal(false);
					done();
				}
			});
		});
	});

	describe('delete directory', function(){
		it('should return a 404 when a directory does not exist', function(done){
			var req = {};
			fsAgent.delete('/fakepath', req, function(err, data){
				if(err){
					err.code.should.equal(404);
					done();
				} else{
					done({message:"test failed - expected an error"});
				}
			});
		});

		it('should return a 204 if the directory does exist and has been deleted', function(done){
			var req = {};
			fsAgent.delete(directory, req, function(err, data){
				if(err){
					return done(err);
				} else{
					data.code.should.equal(204);
					data.contentType.should.equal("text/html");
					fs.existsSync(absoluteDirPath).should.equal(false);
					done();
				}
			});
		});

		it('should return a 204 if the directory does exist, HAS SUB-FOLDERS, and has been deleted', function(done){
			var req = {};
			var subDirPath = path.join(absoluteDirPath, subDirectory);
			fs.mkdirSync(subDirPath);
			fs.existsSync(subDirPath).should.equal(true);
			fsAgent.delete(directory, req, function(err, data){
				if(err){
					return done(err);
				} else{
					data.code.should.equal(204);
					data.contentType.should.equal("text/html");
					fs.existsSync(absoluteDirPath).should.equal(false);
					done();
				}
			});
		});
	});
});
