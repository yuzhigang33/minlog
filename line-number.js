/*!
 * minlog: line-number.js
 * Authors  : 枫弦 <fengxian.yzg@alibaba-inc.com> (https://github.com/yuzhigang33)
 * Create   : 2016-04-15 11:37:49
 * CopyRight 2016 (c) Alibaba Group
 */
'use strict';
const path = require('path');

module.exports.getLineNumber = function () {
  const stacklist = (new Error()).stack.split('\n').slice(3);
  const stackReg = /at\s+(.*)\s+\((.*):(\d*):(\d*)\)/gi;
  const stackReg2 = /at\s+()(.*):(\d*):(\d*)/gi;
  const s = stacklist[0];
  const sp = stackReg.exec(s) || stackReg2.exec(s);
  let data = {};
  if (sp && sp.length === 5) {
    data.method = sp[1];
    data.path = sp[2];
    data.line = sp[3];
    data.pos = sp[4];
    data.file = path.basename(data.path);
    data.stack = stacklist.join('\n');
  }
  console.log(data);
};
