module.exports = (source) ->
	new Function("__values", "with(__values || {}) { #{ source } }")