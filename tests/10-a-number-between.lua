
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

describe("a number between", function ()
  it("does not run if param is less than min", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'a number between', 10, 20)
    :run(function ()
      _.push(o, 5)
    end)

    m:GET('/:num', function ()
      _.push(o, 1)
    end)

    m:RUN(GET('/9'))
    assert.same({1}, o)
  end)

  it("does not run if param > max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'a number between', 10, 20)
    :run(function ()
      _.push(o, 21)
    end)

    m:GET('/:num', function ()
      _.push(o, 21)
    end)

    m:RUN(GET('/21'))
    assert.same({21}, o)
  end)

  it("does not run if param = min", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'a number between', 10, 20)
    :run(function ()
      _.push(o, 10)
    end)

    m:GET('/:num', function ()
      _.push(o, 10)
    end)

    m:RUN(GET('/10'))
    assert.same({10}, o)
  end)

  it("does not run if param = max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'a number between', 10, 20)
    :run(function ()
      _.push(o, 20)
    end)

    m:GET('/:num', function ()
      _.push(o, 20)
    end)

    m:RUN(GET('/20'))
    assert.same({20}, o)
  end)

  it("runs if param is < min, > max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'a number between', 5, 10)
    :run(function ()
      _.push(o, 6)
    end)

    m:RUN(GET('/6'))
    assert.same({6}, o)
  end)

end)
