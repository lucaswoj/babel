Vows = require("vows")
assert = require("assert")
Babel = require("../src/babel")
Path = require("path")

PlainTest = (file, expected) ->
	
	topic: ->
		Babel.plain(file, @callback)
		
	"produces the proper output": (err, text) ->
		throw err if err	
		assert.equal(text, expected)

Vows.describe("The Plain Text Loader").addBatch(

	"A sample text file": PlainTest(
		Path.join(__dirname, "fixtures/plain/test.txt"),
		"test"
	)
	
	"An empty text file": PlainTest(
		Path.join(__dirname, "fixtures/plain/empty.txt"),
		""
	)
	
	"A nonexistant text file": PlainTest(
		Path.join(__dirname, "fixtures/plain/nonexistant.txt"),
		""
	)

).export(module)