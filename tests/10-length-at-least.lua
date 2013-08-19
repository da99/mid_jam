
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

describe("length min", function ()
  it("does not run if params is less than length", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length min', 3)
    :run(function ()
      _.push(o, 1)
    end)

    m:GET('/:name', function ()
      _.push(o, 2)
    end)

    m:RUN(GET('/te'))
    assert.same({2}, o)
  end)

  it("runs if param is at least specified length", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length min', 3)
    :run(function ()
      _.push(o, 1)
    end)

    m:RUN(GET('/ted'))
    assert.same({1}, o)
  end)

  it("runs if param is at more than specified length", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length min', 3)
    :run(function ()
      _.push(o, 1)
    end)

    m:RUN(GET('/teds'))
    assert.same({1}, o)
  end)

end)
