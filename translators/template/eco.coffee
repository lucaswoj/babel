Coffee = require("coffee-script")
EcoPreprocessor = require("eco/preprocessor")

module.exports = (source, callback) ->
	
	fn = new Function("__values", Coffee.compile("""
		
		_output = []

		_safe = (value) ->
			_output.push '' + value if value
			null

		_print = (value) ->
			if value
				_safe (('' + value)
				   .replace(/&/g, '&amp;')
		           .replace(/</g, '&lt;')
		           .replace(/>/g, '&gt;')
		           .replace(/\x22/g, '&quot;'))
			null
			
		`with (__values) {` 
		#{ EcoPreprocessor.preprocess(source) } 
		`}`
		
		return _output.join("")
			
	""", bare: true))
	
	callback(null, fn)