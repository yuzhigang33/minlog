/*!
 * minlog: index.js
 * Authors  : 枫弦 <fengxian.yzg@alibaba-inc.com> (https://github.com/yuzhigang33)
 * Create   : 2015-11-04 21:32:55
 * CopyRight 2015 (c) Alibaba Group
 */

'use strict';
const fs = require('fs');
const path = require('path');
const _ = require('lodash');
const moment = require('moment');

const stdout = require('./stdout');

const cwd = process.cwd();
const baseName = path.basename(path.basename(process.argv[1], '.js'), '.coffee');
const defaultLogFile = `[${cwd}/logs/${baseName}-]YYYY-MM-DD[.log]`;

function MinLog(options) {
  this.options = _.assign({
    duration: 2000,
    bufferLength: 1000,
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
    return console.error('log stream occur error', e);
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

// MinLog.prototype._timeFormat = function () {
//   const now = new Date();
//   const y = now.getFullYear();
//   let m = now.getMonth();
//   m = m < 9 ? '0' + (m + 1) : m + 1;
//   let d = now.getDate();
//   d = d < 10 ? '0' + d : d;
//   const time = now.toLocaleTimeString();
//   return y + '-' + m + '-' + d + ' ' + time;
// };

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

MinLog.prototype._log = function (str, level) {
  // const formatedTime = this._timeFormat();
  const formatedTime = moment().format('YYYY-MM-DD hh:mm:ss');
  this.write(formatedTime + ` ${level} ` + str + '\n');
};

MinLog.prototype.info = function (str) {
  this._log(str, '[INFO]');
};

MinLog.prototype.warn = function (str) {
  this._log(str, '[WARN]');
};

MinLog.prototype.debug = function (str) {
  this._log(str, '[DEBUG]');
};

MinLog.prototype.error = function (str) {
  this._log(str, '[ERROR]');
};

MinLog.prototype.trace = function (str) {
  this._log(str, '');
};

module.exports = function (options) {
  if (_.isEmpty(options) || options.stdout) {
    return stdout;
  }
  return new MinLog(options);
};
