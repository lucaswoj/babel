Fs = require("fs")
Path = require("path")
Step = require("step")
_ = require("underscore")

module.exports = Babel =

	# ## Load Typed File

	# ### Babel.template( file, callback )
	#
	# Load the template file at `file`, process it, then invoke `callback` as
	# `callback( err, template )`. The template will be put into a function as
	# `render(locals)`, where `locals` is an object to serve as the local 
	# scope of the template during rendering. The context of the template can 
	# also be easily changed also by calling `render.call(context, locals)`
	
	template: (file, callback) ->
		Babel.typedFile("template", file, callback)
	
	# ### Babel.data( file, callback )
	#
	# Load the data file at `file`, process it, then invoke `callback` as
	# `callback( err, data )`. The data will be returned as a JavaScript object.
	
	data: (file, callback) ->
		Babel.typedFile("data", file, callback)
	
	# ### Babel.data( file, callback )
	#
	# Load the script file at `file`, process it, then invoke `callback` as
	# `callback( err, data )`. The script will be put into a function as
	# `script(locals)`, where `locals` is an object to serve as the local 
	# scope of the script during execution. The context of the script can 
	# also be easily changed also by calling `script.call(context, locals)`
	
	script: (file, callback) ->
		Babel.typedFile("script", file, callback)
	
	# ### Babel.stylesheet( file, callback )
	#
	# Load the stylesheet at `file`, process it, then invoke `callback` as
	# `callback( err, css )`. The stylesheet will be returned as a string 
	# containing CSS rules.
	
	stylesheet: (file, callback) ->
		Babel.typedFile("stylesheet", file, callback)
	
	# ### Babel.typedFile( type, file, callback )
	# 
	# Load a typed file and the appropriate translator. Translate the file's
	# source and return the result.

	typedFile: (type, file, callback) ->
		
		extension = Path.extname(file).substr(1)
				
		Step ->
			Babel.translator(type, extension, @parallel())
			Babel.plain(file, @parallel())
			
		, (err, translator, source) ->
			callback(err, translator(source))
			
	# ## Load Plain Text
	#
	# Load the plain text of a file and return the result. If the file
	# does not exist, return an empty string.
	
	plain: (file, callback) ->				
		Fs.readFile file, "utf8", (err, source) ->
			callback(null, if !err then source else "")
	
	# ## Load Translator
	
	translators: {}
	
	translatorsDir: Path.join(__dirname, "../translators")
	
	# ### Babel.translator( type, extension, callback )
	#
	# Load a translator function from its file at 
	# `../translators/<type>/<extension>.coffee`. This file exports a function
	# which is cached then in the `@translators[type]` object. If a translator
	# for a requested file type does not exist, create a closure
	# that always returns null in its place.
	
	translator: (type, extension, callback) ->
		
		@translators[type] ?= {}
		translator = @translators[type][extension]

		if translator != undefined
			callback(null, translator)

		else
			file = Path.join(@translatorsDir, type, "#{extension}.coffee")
			Path.exists file, (exists) =>
				translator = if exists then require(file) else (-> null)
				@translators[type][extension] = translator
				callback(null, translator)
			
	
	# ## Load Directory		

	ignoreFiles: [ ".DS_Store", ".git" ]
	
	# ### Babel.dir( file, callback )
	#
	# Run an iterator function for each file in a directory, allowing each
	# iterator to run its own async loader. The results of these loaders are
	# placed into an object by the file's basname
	
	dir: (dir, iterator, callback = ->) ->
			
		Step ->
			# Get a list of files in the directory
			Fs.readdir(dir, @)
					
		, (err, files = []) ->
			# If the directory doesn't exist, set `files` to an empty array
			if err then files = []
			
			@parallel()(null, files)
		
			# Run the iterator on each (non-ignored) file
			group = @group() if (files.length)
			for file in files
				if !_.include(Babel.ignoreFiles, file)
					iterator(Path.join(dir, file), group())
			
			undefined
			
		, (err, files = [], results = []) ->
			callback(err) if err
			
			# Match each result with its file path and build the final object
			object = {}
			for touple in _.zip(files, results)
				[file, result] = touple
				name = Path.basename(file).split(".")[0]
				object[name] = result
		
			callback(null, object)