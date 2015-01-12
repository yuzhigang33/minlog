expect = require 'expect.js'
path = require 'path'
fs   = require 'fs'
os   = require 'options-stream'
moment = require 'moment'
minlog = require '../lib/minlog'

cwd = process.cwd()

describe 'minlog', ->
  options = null
  fileName = moment().format "[test/test-]YYYY-MM-DD[.log]"
  beforeEach ->
    options =
      duration   : 5000
      buffLength : 1000
      fileName   : "[test/test-]YYYY-MM-DD[.log]"

  afterEach (done)->
    fs.unlinkSync fileName
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
    mlog = minlog os options, {duration: 1}
    mlog.write 'msg\n'
    setTimeout ->
      mlog.write 'msg\n'
      str = fs.readFileSync fileName, 'utf-8'
      expect(str).to.be 'msg\nmsg\n'
      expect(mlog.buffer.length).to.be 0
      done()
    , 300

  it 'info level', (done) ->
    mlog = minlog os options, {buffLength: 1}
    mlog.info  'msg\n'
    mlog.debug 'msg\n'
    mlog.warn  'msg\n'
    mlog.error 'msg\n'
    setTimeout ->
      str = fs.readFileSync fileName, 'utf-8'
      str = str.split '\n'
      expect(/INFO msg/.test str[0]).to.be.ok
      expect(/DEBUG msg/.test str[2]).to.be.ok
      expect(/WARNING msg/.test str[4]).to.be.ok
      expect(/ERROR msg/.test str[6]).to.be.ok
      expect(mlog.buffer.length).to.be 0
      done()
    , 300

  it 'check file', (done) ->
    mlog = minlog os options, {buffLength: 1}
    mlog.log_day = '2014-01-01'
    mlog._checkFile()
    mlog.info  'msg\n'
    mlog.debug 'msg\n'
    mlog.warn  'msg\n'
    mlog.error 'msg\n'
    setTimeout ->
      str = fs.readFileSync fileName, 'utf-8'
      str = str.split '\n'
      expect(/INFO msg/.test str[0]).to.be.ok
      expect(/DEBUG msg/.test str[2]).to.be.ok
      expect(/WARNING msg/.test str[4]).to.be.ok
      expect(/ERROR msg/.test str[6]).to.be.ok
      expect(mlog.buffer.length).to.be 0
      done()
    , 300
