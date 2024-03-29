var Dictionary = function() {
  this.keys = {};
  this.length = 0;

};

Dictionary.prototype.store = function(key, value) {
  this.keys[key] = value;
  this.length++;
};

Dictionary.prototype.fetch = function(key) {
  var value = this.keys[key];

  if (value) {
    return value;
  } else {
    return this.defaultValue( key );
  }
};

Dictionary.prototype.hasKey = function(key) {
  for (var k in this.keys) {
    if (key == k) {
      return true;
    } else {
      return false;
    }
  };
  return false;
};

Dictionary.prototype.remove = function(key) {
  if (this.keys[key]) {
    delete this.keys[key];
    this.length--;
  }
};

Dictionary.prototype.reject = function(callback) {
  for (var k in this.keys) {
    if (callback(k, this.keys[k])) {
      delete this.keys[k];
    }
  }
};

Dictionary.prototype.random = function() {
  var keys = [];

  for (var k in this.keys) {
    keys.push(k);
  }

  return keys[Math.floor(Math.random() * keys.length)];
};

Dictionary.prototype.defaultValue = function( key ){
  return null;
};

exports.Dictionary = Dictionary;