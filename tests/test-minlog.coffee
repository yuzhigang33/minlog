expect = require 'expect.js'
path = require 'path'
fs   = require 'fs'
os   = require 'options-stream'
moment = require 'moment'
minlog = require '../lib/minlog'

cwd = process.cwd()

describe 'minlog', ->
  options = null
  fileName = moment().format "[tests/test-]YYYY-MM-DD[.log]"
  beforeEach ->
    options =
      duration   : 5000
      buffLength : 1000
      fileName   : "[tests/test-]YYYY-MM-DD[.log]"

  afterEach (done)->
    fs.unlinkSync fileName if fs.existsSync fileName
    done()

  it 'write because buffLength', (done) ->
    mlog = minlog os options, {buffLength: 1}
    mlog.write 'msg\n'
    mlog.write 'msg\n'
    setTimeout ->
      str = fs.readFileSync fileName, 'utf-8'
      expect(str).to.be 'msg\nmsg\n'
      expect(mlog.buffer.length).to.be 0
      done()
    , 300

  it 'write because duration', (done) ->
    mlog = minlog os options, {duration: 100}
    mlog.write 'msg\n'
    mlog.write 'msg\n'
    setTimeout ->
      str = fs.readFileSync fileName, 'utf-8'
      expect(str).to.be 'msg\nmsg\n'
      expect(mlog.buffer.length).to.be 0
      done()
    , 300

  it 'log info', (done) ->
    mlog = minlog os options, {buffLength: 1}
    mlog.info 'msg'
    mlog.info 'msg'
    setTimeout ->
      str = fs.readFileSync fileName, 'utf-8'
      str = str.split '\n'
      expect(str.length).to.be 3
      expect(str[0].length).to.be '2015-01-15 14:28:16 msg'.length
      expect(mlog.buffer.length).to.be 0
      done()
    , 300

  # it 'log levels', (done) ->
  #   mlog = minlog os options, {buffLength: 1}
  #   mlog.info  'msg\n'
  #   mlog.debug 'msg\n'
  #   mlog.warn  'msg\n'
  #   mlog.error 'msg\n'
  #   setTimeout ->
  #     str = fs.readFileSync fileName, 'utf-8'
  #     str = str.split '\n'
  #     expect(/INFO msg/.test str[0]).to.be.ok
  #     expect(/DEBUG msg/.test str[2]).to.be.ok
  #     expect(/WARNING msg/.test str[4]).to.be.ok
  #     expect(/ERROR msg/.test str[6]).to.be.ok
  #     expect(mlog.buffer.length).to.be 0
  #     done()
  #   , 300

  it 'check file', (done) ->
    mlog = minlog os options, {buffLength: 1}
    mlog.log_day = '2014-01-01'
    mlog._checkFile()
    mlog.info 'msg'
    mlog.info 'msg'
    setTimeout ->
      str = fs.readFileSync fileName, 'utf-8'
      str = str.split '\n'
      expect(str.length).to.be 3
      expect(mlog.buffer.length).to.be 0
      done()
    , 300

  it 'stream on error occoured', (done) ->
    mlog = minlog os options, {fileName: '[/private/test]'}
    mlog.info  'msg\n'
    setTimeout ->
      exists = fs.existsSync '/private/test.log', 'utf-8'
      expect(exists).not.to.be.ok
      done()
    , 300
