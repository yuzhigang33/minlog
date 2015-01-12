if (require.extensions['.coffee']) {
  module.exports = require('./lib/minlog.coffee');
} else {
  module.exports = require('./out/release/lib/minlog.js');
}
