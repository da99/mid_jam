
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

describe("custom param rules", function ()
  it("does not run callback when function returns false", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :param('name', function ()
      return false
    end)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 2)
    end)

    m:RUN(GET('/te'))
    assert.same({2}, o)
  end)

  it("runs callback when function returns true", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :param('name', function ()
      return true
    end)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 2)
    end)

    m:RUN(GET('/te'))
    assert.same({1, 2}, o)
  end)

  it("passes a table of values to callback: {param_name, args...}", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :param('name', 4, 5, 6, 7, function (args, req, resp, env)
      _.push(o, args)
      return false
    end)
    :run(function ()
      _.push(o, 1)
    end)

    m:RUN(GET('/te'))
    assert.same({{'name', 4, 5, 6, 7}}, o)
  end)
end)











