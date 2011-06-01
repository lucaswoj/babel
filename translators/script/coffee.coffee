Coffee = require("coffee-script")

module.exports = (source) ->
	js = Coffee.compile("return (#{ source })", bare: true)
	new Function("__values", "with(__values || {}) { #{ js } }")