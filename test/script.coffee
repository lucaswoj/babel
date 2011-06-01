Vows = require("vows")
assert = require("assert")
Babel = require("../src/babel")
Path = require("path")

ScriptTest = (file) ->
	
	topic: ->
		Babel.script(file, @callback)
		
	"can access a context": (err, script) ->	
		throw err if err
	
		context = context: false
		script.call(context)
		assert.isTrue(context.context)
	
	"can access locals": (err, script) ->
		throw err if err
		
		locals = local: false
		script(locals)
		assert.isTrue(locals.local)
	
	"can return a value": (err, script) ->
		throw err if err

		assert.isTrue(script())

Vows.describe("The Script Loader").addBatch(

	"A loaded .js script": ScriptTest(
		Path.join(__dirname, "fixtures/script/test.js")
	)
	
	"A loaded .coffee script": ScriptTest(
		Path.join(__dirname, "fixtures/script/test.coffee")
	)

).export(module)