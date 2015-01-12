# minlog

minlog , A pretty simple logger for Node.js, especially used for access logging for web app.

# Installation

`npm install minlog`

## Usage

### Getting start

```javascript
var log = minlog({
  fileName : '[test-]YYYY-MM-DD[.log]'
});
```

available levels

* minlog.info
* minlog.debug
* minlog.warn
* minlog.error

## Buffer Log
you can buffer your access log if you have big visits.

```javascript
var log = minlog({
  fileName : '[test-]YYYY-MM-DD[.log]'
  duration : 5000, // flush buffer time, default is 2000
  bufferLength : 1000 // max buffer length, default is 0
});
```
