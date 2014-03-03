/*
 * file: 			writeFile.js
 * description: 	unit tests to ensure that our file-writing capabilities work as expected
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
var fileName = "helloworld.log";
var directory = "otherFolder";

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

	describe('create file to path used in URL', function(){
		it('should return a 201 and create file if folder already exists', function(done){
			var req = {};
			var targetPath = path.join(directory, 'newFile.txt');
			var finalPath = path.join(absoluteDirPath, 'newFile.txt');
			var fileData = {
					name: fileName,
					path: absoluteFilePath
			};

			fsAgent.write(targetPath, req, fileData, function(err, data){
				if(err) return done(err);

				data.code.should.equal(201);
				data.contentType.should.equal("text/html");
				fs.existsSync(finalPath).should.equal(true);
				done();
			});
		});

		it('should return a 201 and create file if folder DOES NOT exist', function(done){
			var req = {};
			var targetPath = path.join('newDirectory', 'newFile.txt');
			var finalPath = path.join(process.cwd(), 'newDirectory', 'newFile.txt');
			var fileData = {
					name: fileName,
					path: absoluteFilePath
			};

			fsAgent.write(targetPath, req, fileData, function(err, data){
				if(err) return done(err);

				data.code.should.equal(201);
				data.contentType.should.equal("text/html");
				fs.existsSync(finalPath).should.equal(true);
				done();
			});
		});
	});

describe('create file to path used in URL and filename in upload', function(){
		it('should return a 201 and create file if folder already exists', function(done){
			var req = {};
			var targetPath = directory;
			var finalPath = path.join(absoluteDirPath, fileName);
			var fileData = {
					name: fileName,
					path: absoluteFilePath
			};

			fsAgent.write(targetPath, req, fileData, function(err, data){
				if(err) return done(err);

				data.code.should.equal(201);
				data.contentType.should.equal("text/html");
				fs.existsSync(finalPath).should.equal(true);
				done();
			});
		});

		it('should return a 201 and create file if folder DOES NOT exist', function(done){
			var req = {};
			var targetPath = 'newDirectory';
			var finalPath = path.join(process.cwd(), 'newDirectory', fileName);
			var fileData = {
					name: fileName,
					path: absoluteFilePath
			};

			fsAgent.write(targetPath, req, fileData, function(err, data){
				if(err) return done(err);

				data.code.should.equal(201);
				data.contentType.should.equal("text/html");
				fs.existsSync(finalPath).should.equal(true);
				done();
			});
		});
	});
});

