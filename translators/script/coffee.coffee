Coffee = require("coffee-script")

module.exports = (source, callback) ->
	js = Coffee.compile("return (#{ source })", bare: true)
	fn = new Function("__values", "with(__values || {}) { #{ js } }")
	callback(null, fn)