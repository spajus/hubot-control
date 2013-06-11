// Depends on coffeelint.js from http://www.coffeelint.org/

CodeMirror.coffeeValidator = function(text) {
  var found = [];
  parseError = function(err) {
    var loc = err.lineNumber;
    found.push({from: CodeMirror.Pos(loc-1, 0),
                to: CodeMirror.Pos(loc, 0),
                message: err.message});
  };
  try {
    var res = coffeelint.lint(text);
    for(i = 0; i < res.length; i++) {
      parseError(res[i]);
    }
  } catch(e) {
    found.push({from: CodeMirror.Pos(e.location.first_line, 0),
                to: CodeMirror.Pos(e.location.last_line, e.location.last_column),
                message: e.message});
  }
  return found;
};
