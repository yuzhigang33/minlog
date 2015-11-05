/*!
 * minlog: stdout.js
 * Authors  : 枫弦 <fengxian.yzg@alibaba-inc.com> (https://github.com/yuzhigang33)
 * Create   : 2015-11-05 08:00:59
 * CopyRight 2015 (c) Alibaba Group
 */
'use strict';

function _log(type, color) {
  return function () {
    const args = Array.prototype.slice.call(arguments);
    args.unshift('\x1B[' + color + 'm' + type + '\x1B[0m');
    console.log.apply(this, args);
  };
}

// colors: 31 red,  32 green, 33 yellow, 34 blue, 35 purple, 36 cyan, 37 white
let log = {
  warn: _log('[WARN]', 33),
  info: _log('[INFO]', 32),
  error: _log('[ERROR]', 31),
  debug: _log('[DEBUG]', 36),
  trace: _log('[TRACE]', 34)
};

module.exports = log;
