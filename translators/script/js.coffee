module.exports = (source, callback) ->
	fn = new Function("__values", "with(__values || {}) { #{ source } }")
	callback(null, fn)