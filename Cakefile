ChildProcess = require("child_process")

exec = (command, callback) ->

	ChildProcess.exec command, (err, stderr, stdout) ->
		throw err if err
		console.log(stdout) if stdout
		console.log(stderr) if stderr
		
task "test", ->
	exec("vows test/*.coffee")
	
task "doc", ->
	exec("docco src/*.coffee")
	
task "build", ->
	exec("coffee -o lib -c src/*.coffee")
	invoke("test")