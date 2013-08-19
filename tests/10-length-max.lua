
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

describe("length max", function ()
  it("does not run if param length is more than max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :param('name', 'length max', 5)
    :run(function ()
      _.push(o, 5)
    end)

    m:GET('/:name', function ()
      _.push(o, 6)
    end)

    m:RUN(GET('/123123'))
    assert.same({6}, o)
  end)

  it("runs if param length is max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :param('name', 'length max', 3)
    :run(function ()
      _.push(o, 3)
    end)

    m:RUN(GET('/ted'))
    assert.same({3}, o)
  end)

  it("runs if param length is less than max", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :param('name', 'length max', 5)
    :run(function ()
      _.push(o, 4)
    end)

    m:RUN(GET('/teds'))
    assert.same({4}, o)
  end)

end)
