path = require 'path'
fs   = require 'fs'
os   = require 'options-stream'
moment = require 'moment'

cwd = process.cwd()

defaultAccessLogFile = "[#{cwd}/logs/#{path.basename (path.basename process.argv[1] , '.js'), '.coffee'}-]YYYY-MM-DD[.log]"

class MinLog
  constructor: (options) ->
    @options = os {
      duration   : 2000
      buffLength : 0
      fileName   : defaultAccessLogFile
    }, options

    @log_day = moment().format 'YYYY-MM-DD'
    @lastCheckTime = Date.now()
    @buffer = []
    fileName = moment().format @options.fileName
    @stream = @newStream fileName
    @_checkFile()

  newStream: (fileName) ->
    @log_day = moment().format 'YYYY-MM-DD'
    stream = fs.createWriteStream fileName, {flags: 'a'}
    stream.on 'error', (e) -> console.error 'log stream ocur error', e
    stream.on 'open', ->
    stream.on 'close', ->
    @stream = stream

  write: (str) ->
    @buffer.push str
    if @buffer.length > @options.buffLength
      @stream.write( @buffer.join '' )
      @buffer.length = 0
      return

    now = Date.now()
    if now - @lastCheckTime > @options.duration
      @stream.write( @buffer.join '' )
      @lastCheckTime = now
      @buffer.length = 0

  info: (str) ->
    @write '[' + new Date + '] ' + 'INFO ' +  str + '\n'

  debug: (str) ->
    @write '[' + new Date + '] ' + 'DEBUG ' +  str + '\n'

  warn: (str) ->
    @write '[' + new Date + '] ' + 'WARNING ' +  str + '\n'

  error: (str) ->
    @write '[' + new Date + '] ' + 'ERROR ' +  str + '\n'

  #检查日志文件的日期，不是当天的，就新建一个文件。
  _checkFile: ->
    now = new Date
    timeout = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1) - now
    setTimeout @_checkFile.bind(@), timeout
    if @log_day isnt moment().format 'YYYY-MM-DD'
      @stream.end() # end stream
      @stream = null # clear object
      @newStream moment().format @options.fileName


module.exports = (options) ->
  new MinLog options
