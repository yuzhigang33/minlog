# minlog

A pretty simple and high performance logger for Node.js, especially used for access logging of web app.

# Installation

`npm install minlog`

## Usage

### Getting start

```javascript
const MinLog = require('minlog');
const mlog = MinLog({
  fileName : '[test-]YYYY-MM-DD[.log]'
});
```

available levels

* mlog.info
* mlog.warn
* mlog.debug
* mlog.error
* mlog.trace

## Buffer Log
you can buffer your access log if you have big visits (high qps).

```javascript
const mlog = MinLog({
  fileName : '[test-]YYYY-MM-DD[.log]'
  duration : 5000, // flush buffer time, default is 1000ms
  bufferLength : 1000 // set max buffer length, default is 0
});
```
