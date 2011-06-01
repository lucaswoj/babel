# Babel

Babel puts a soft cushion between a web application and the many cool new 
technologies developed for node.js such as CoffeeScript, SASS, and Jade. 
With Babel, you will be able to seamlessly load from many different types of 
files into clean, simple, and standardized data structures without having to
worry about the many APIs involved.

## Examples

### Loading a Stylesheet

Loading a stylesheet of *any* format is easy with Babel. If you had a file at
`layout.scss` which contained

	#primary-nav {
		li {
			color: #fff;
		}
	}
	
you could load the file and and convert it to CSS with
	
	Babel.template(pathToFile, function(err, css) {
		// ...
	});
	
With the same ease, you can load data files (JSON, YAML, etc), script files 
(CoffeeScript, JavaScript, etc), and templates (Embedded JavaScript, Jade, etc)

### Loading a Directory of Templates

If you you have a folder full of templates

	stylesheets/
		body.html
		post.jade
		header.eco
		footer.ejs
		
you could load all the templates and convert each to a simple `render(values)`
function with

	Babel.dir(dir, Babel.template, function(err, templates) {
		// ...
	});

where `templates` looks like

	{
		body: function(values) { ... },
		post: function(values) { ... },
		header: function(values) { ... },
		footer: function(values) { ... }
	}

## Methods

### Babel.template(file, callback)

A template defines 

#### Supported Formats

 + [Jade Templates](https://github.com/visionmedia/jade) (*.jade)
 + [Embedded Coffeescript](https://github.com/sstephenson/eco) (*.eco)

### Babel.data(file, callback)

A data file contains a static serialized representation of a JavaScript object.
These are generally used for configuration, not actual data storage.

#### Supported Formats

 + [Coffee Script](http://jashkenas.github.com/coffee-script/) (*.coffee)
 + JSON (*.json)

### Babel.stylesheet(file, callback)

A stylesheet is any file that defines the visual appearance of a HTML document
that can be translated into CSS.

#### Supported Formats

 + CSS (*.css)

### Babel.plain(file, callback)

### Babel.dir(file, iterator, callback)

## Translators

Translators contain the instructions for converting a specific file format 
into a standardized data structure.

More specifically, a translator is function invoked by Babel as `translator(source)`, 
where `source` is the raw text of the file being translated. This function
is run synchronously to convert the source into a data structure as defined 
per file type in the sections below.

The code for the translators is located at 
`./translators/<type>/<extension>.coffee` where `<extension>` refers to the 
literal file extension of a file of that type. For example, the JSON data 
translator is located at `./translators/data/json.coffee`

### Data

Data translators return a JavaScript object representation of the source data

### Script

A script translator returns a function of the signature `run(values)`
where `values` is an object to be used as the local scope when rendering the 
script (presumably inside a `with(values) { ... }` block). This function
should also support being invoked as `run.call(context, values)`. 

Values returned in the script's execution by `return` statements should be 
returned from the `run(values)` function.

### Stylesheet

A stylesheet translator should return a string of W3C valid CSS3 rules.

### Template

Template translator returns a function of the signature `render(values)`
where `values` is an object to be used as the local scope when rendering the 
template (presumably inside a `with(values) { ... }` block). This function
should also support being invoked as `render.call(context, values)`.

Take care not to break the `.toString()` compatibility of the function.