Fs = require("fs")
Path = require("path")
Step = require("step")
_ = require("underscore")

module.exports = Babel =

	# ## Load Typed File

	# ### Babel.template( file, callback )
	#
	# Load and convert a template file
	
	template: (file, callback) ->
		Babel.typedFile("template", file, callback)
	
	# ### Babel.data( file, callback )
	#
	# Load and convert a data file
	
	data: (file, callback) ->
		Babel.typedFile("data", file, callback)
	
	# ### Babel.data( file, callback )
	#
	# Load and convert a script file
	
	script: (file, callback) ->
		Babel.typedFile("script", file, callback)
	
	# ### Babel.stylesheet( file, callback )
	#
	# Load and convert a stylesheet
	
	stylesheet: (file, callback) ->
		Babel.typedFile("stylesheet", file, callback)
	
	# ### Babel.typedFile( type, file, callback )
	# 
	# Load a file of a specific type (determined by the file extension)
	# and load the appropriate translator. Run the file's contents through the
	# translator and return the result.
	#
	# If the file does not exist, pass an empty string into the translator to
	# get a "default" value
	#
	# If the translator doesn't exist, return null

	typedFile: (type, file, callback) ->
		
		extension = Path.extname(file).substr(1)
				
		Step ->
			Babel.translator(type, extension, @parallel())
			Babel.plain(file, @parallel())
			
		, (err, translator, source) ->
			translator(source, @)
			
		, callback
			
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
	# Lazyload translators as they are needed. If a translator
	# for a requested file type does not exist, use a function
	# that always returns null in its place.
	
	translator: (type, extension, callback) ->
		
		@translators[type] ?= {}
		translator = @translators[type][extension]

		if translator != undefined
			callback(null, translator)

		else
			file = Path.join(@translatorsDir, type, "#{extension}.coffee")
			translator = require(file)
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