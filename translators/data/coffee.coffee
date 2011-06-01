Coffee = require("coffee-script")

module.exports = (source) ->
	js = Coffee.compile("return (#{ source })", bare: true)
	fn = Function("__values", "with(__values || {}) { #{ js } }")
	fn()