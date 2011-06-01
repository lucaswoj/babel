(function() {
  var Babel, Fs, Path, Step, _;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Fs = require("fs");
  Path = require("path");
  Step = require("step");
  _ = require("underscore");
  module.exports = Babel = {
    template: function(file, callback) {
      return Babel.file("template", file, callback);
    },
    data: function(file, callback) {
      return Babel.file("data", file, callback);
    },
    script: function(file, callback) {
      return Babel.file("script", file, callback);
    },
    stylesheet: function(file, callback) {
      return Babel.file("stylesheet", file, callback);
    },
    file: function(type, file, callback) {
      var extension;
      extension = Path.extname(file).substr(1);
      return Path.exists(file, function(exists) {
        if (exists) {
          return Step(function() {
            Babel.translator(type, extension, this.parallel());
            return Fs.readFile(file, "utf8", this.parallel());
          }, function(err, translator, source) {
            if (err) {
              throw err;
            }
            if (translator) {
              return translator(source);
            } else {
              return null;
            }
          }, callback);
        } else {
          return callback(null, null);
        }
      });
    },
    translators: {},
    translatorsDir: Path.join(__dirname, "../translators"),
    translator: function(type, extension, callback) {
      var file, translator, _base, _ref;
            if ((_ref = (_base = this.translators)[type]) != null) {
        _ref;
      } else {
        _base[type] = {};
      };
      translator = this.translators[type][extension];
      if (translator !== void 0) {
        return callback(null, translator);
      } else {
        file = Path.join(this.translatorsDir, type, "" + extension + ".coffee");
        return Path.exists(file, __bind(function(exists) {
          translator = exists ? require(file) : false;
          this.translators[type][extension] = translator;
          return callback(null, translator);
        }, this));
      }
    },
    ignoreFiles: [".DS_Store", ".git"],
    dir: function(dir, iterator, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return Path.exists(dir, function(exists) {
        if (exists) {
          return Step(function() {
            return Fs.readdir(dir, this);
          }, function(err, files) {
            var file, group, _i, _len;
            if (err) {
              callback(err);
            }
            if (!files.length) {
              return this(null, []);
            }
            group = this.group();
            for (_i = 0, _len = files.length; _i < _len; _i++) {
              file = files[_i];
              if (!_.include(Babel.ignoreFiles, file)) {
                iterator(Path.join(dir, file), group());
              }
            }
            return;
          }, function(err, results) {
            return callback(err, _.compact(results));
          });
        } else {
          return callback(null, []);
        }
      });
    }
  };
}).call(this);
