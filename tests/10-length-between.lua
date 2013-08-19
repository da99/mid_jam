
local Mid      = require("mid_jam")
local _        = require("underscore")
local S        = require("pl.stringx")
local describe = describe
local it       = it
local ENV      = {}
local require  = require
local pcall    = pcall
local assert   = assert
local table    = table

setfenv(1, ENV)
require('mid_jam.test_dsl').to(ENV)

describe("length between", function ()
  it("does not run if param length < min", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length between', 4, 6)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 3)
    end)

    m:RUN(GET('/ted'))
    assert.same({3}, o)
  end)

  it("does not run if param length > max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length between', 4, 6)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 7)
    end)

    m:RUN(GET('/tedted7'))
    assert.same({7}, o)
  end)

  it("does not run if param length = min", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length between', 4, 6)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 4)
    end)

    m:RUN(GET('/ted1'))
    assert.same({4}, o)
  end)

  it("does not run if param length = max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length between', 4, 6)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 6)
    end)

    m:RUN(GET('/ted123'))
    assert.same({6}, o)
  end)

  it("runs if param length, l > min, l < max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length between', 4, 6)
    :run(function ()
      _.push(o, 5)
    end)

    m:RUN(GET('/tedds'))
    assert.same({5}, o)
  end)

  it("runs if param length < max, l > min", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length between', 4, 6)
    :run(function ()
      _.push(o, 5)
    end)

    m:RUN(GET('/ted12'))
    assert.same({5}, o)
  end)

end)
