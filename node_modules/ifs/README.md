ifs
=======

instant file server (ifs) turns any directory into an instant file server, and it runs directly from your command line. Install it once per machine and then run it in as many directories as you'd like.

## HTTP Conventions

* __GET__ - reads the contents a file from the specified path
* __POST__ - overwrite or create a file
* __PUT__ - update the contents of a file (__not implemented__)
* __DELETE__ - delete a file from the system

## Installation
instant-server can be installed via [Node Package Manager][0].

Best results when you install globally using the `-g` flag on NPM.

````
$ npm install -g ifs
$ (instant-server is added to your PATH; go anywhere on your system)
$ instant-server -help
$ instant-server [arguments...]
... starting
````

 [0]: http://npmjs.org/