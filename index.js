/*!
 * minlog: index.js
 * Authors  : 枫弦 <fengxian.yzg@alibaba-inc.com> (https://github.com/yuzhigang33)
 * Create   : 2015-11-04 21:32:55
 * CopyRight 2015 (c) Alibaba Group
 */

'use strict';
const fs = require('fs');
const _ = require('lodash');
const path = require('path');
const moment = require('moment');

const cwd = process.cwd();
const baseName = path.basename(path.basename(process.argv[1], '.js'), '.coffee');
const defaultLogFile = `[${cwd}/logs/${baseName}-]YYYY-MM-DD[.log]`;

function MinLog(options) {
  this.options = _.assign({
    duration: 2000,
    bufferLength: 0,
    fileName: defaultLogFile
  }, options);
  const fileName = moment().format(this.options.fileName);
  this.stream = this._newStream(fileName);
  this.logDate = moment().format('YYYY-MM-DD');
  this.buffer = [];
  this._checkFile();
  this._checkBuffer();
}

MinLog.prototype._newStream = function (fileName) {
  this.logDate = moment().format('YYYY-MM-DD');
  let stream = fs.createWriteStream(fileName, { flags: 'a' });
  stream.on('error', function (e) {
    return console.error('log stream occur error: ', e);
  });
  stream.on('open', function() {});
  stream.on('close', function() {});
  return this.stream = stream;
};

MinLog.prototype.write = function (str) {
  this.buffer.push(str);
  if (this.buffer.length > this.options.bufferLength) {
    this.stream.write(this.buffer.join(''));
    this.buffer.length = 0;
  }
};

MinLog.prototype._checkFile = function () {
  const now = new Date();
  const timeout = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1) - now;
  setTimeout(this._checkFile.bind(this), timeout);
  if (this.logDate !== moment().format('YYYY-MM-DD')) {
    this.stream.end();
    this.stream = null;
    this._newStream(moment().format(this.options.fileName));
  }
};

MinLog.prototype._checkBuffer = function () {
  if (this.buffer.length !== 0) {
    this.stream.write(this.buffer.join(''));
    this.buffer.length = 0;
  }
  setTimeout(this._checkBuffer.bind(this), this.options.duration);
};

MinLog.prototype._log = function (args, level) {
  const formatedTime = moment().format('YYYY-MM-DD hh:mm:ss');
  this.write(formatedTime + ` ${level} ` + args.join('') + '\n');
};

MinLog.prototype.info = function () {
  const args = Array.prototype.slice.call(arguments);
  this._log(args, '[INFO]');
};

MinLog.prototype.warn = function () {
  const args = Array.prototype.slice.call(arguments);
  this._log(args, '[WARN]');
};

MinLog.prototype.debug = function () {
  const args = Array.prototype.slice.call(arguments);
  this._log(args, '[DEBUG]');
};

MinLog.prototype.error = function () {
  const args = Array.prototype.slice.call(arguments);
  this._log(args, '[ERROR]');
};

MinLog.prototype.trace = function () {
  const args = Array.prototype.slice.call(arguments);
  this._log(args, '');
};

module.exports = function (options) {
  if (_.isEmpty(options) || options.stdout) {
    return require('./stdout');
  }
  return new MinLog(options);
};
