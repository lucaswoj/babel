# Babel

Babel puts a soft cushion between a web application and the many cool new 
file formats developed for use with node.js such as CoffeeScript, SASS, and 
Jade. With Babel, you will be able to seamlessly load from many different 
types of files without having to worry about the many APIs involved.

## Methods

### Babel.template(file, callback)

A template defines a reusable snippet of HTML which can be rendered many times
with different sets of values.

`file` is an absolute path to the template file and `callback` is a function 
which will be invoked as `callback(err, render)`. The `render` function passed
to `callback` can be used to render the template with any values or context.

#### Example

If you had a embedded CoffeeScript file

	<h1><%= @greeting %> <%= planet %></h1>
	
you could load it with

	Babyl.template("hello.eco", function(err, render) {
		// ...
	});
	
and then render it with

	var context = { greeting: "Hello" };
	var values = { planet: "world" };

	var output = render.call(context, values);
	
Now, `output` will equal `<h1>hello world</h1>`

#### Supported Formats

 + [Jade Templates](https://github.com/visionmedia/jade) (*.jade)
 + [Embedded Coffeescript](https://github.com/sstephenson/eco) (*.eco)

### Babel.data(file, callback)

A data file contains a static serialized representation of a JavaScript object.
These are generally used for configuration, not actual data storage.

#### Example

If you had a JSON file

	{
		"username": "root",
		"password": "asdf"
	}
	
you could load it with

	Babyl.data("accounts.json", function(err, data) {
		// ...
	});
	
now `data` will equal `{ username: "root", "password": "asdf" }`

#### Supported Formats

 + [Coffee Script](http://jashkenas.github.com/coffee-script/) (*.coffee)
 + JSON (*.json)

### Babel.script(file, callback)

A script is a file containing some form of code which can be run multiple times
with different values. The script has the ability to accept values and a context.

#### Example

If you had a CoffeeScript file

	x for x in [@min..max] by 2

you could load it with

	Babyl.data("evens.coffee", function(err, script) {
		// ...
	});

and run the script with

	var events = script.call({ min: 0 }, { max: 10 });
	
now `evens` will equal `[ 0, 2, 4, 6, 8, 10 ]`

#### Supported Formats

 + JavaScript (*.js)
 + CoffeeScript (*.coffee)

### Babel.stylesheet(file, callback)

A stylesheet is any file that defines the visual appearance of a HTML document
that can be translated into CSS.

#### Example

If you had a SCSS stylesheet

	.blog-post {
		h2 { color: red; }
	}
	
you could load it with

	Babyl.data("blog.scss", function(err, css) {
		// ...
	});
	
now `css` will equal `".blog-post h2 { color: red }"`

#### Supported Formats

 + CSS (*.css)



### Babel.dir(dir, iterator, callback)

Utility method to load a directory full of files in one step. For a use case,
see the **Loading a Directory of Templates** example above.

This method will call `iterator` for each file found in `dir` as 
`iterator(file, callback)`. The iterator the asynchronously loads the file and
calls its `callback` with the result.

All results are gathered into a JavaScript object as `{ fileNames: result, ... }`
and passed to `callback`

#### Example

If you you have a folder full of templates

	stylesheets/
		body.html
		post.jade
		header.eco
		footer.ejs
		
you could load and convert each template to a `render(values)` function in
one step with

	Babel.dir(dir, Babel.template, function(err, templates) {
		// ...
	});

`templates` will look like

	{
		body: function(values) { ... },
		post: function(values) { ... },
		header: function(values) { ... },
		footer: function(values) { ... }
	}

## Translators

Translators contain the instructions for converting a specific file format 
into a standardized data structure.

More specifically, a translator is function invoked by Babel as
`translator(source, callback)`, where `source` is the raw text of the file 
being translated. This function is run asynchronously to convert the source 
into a data structure as defined per file type in the sections below.

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