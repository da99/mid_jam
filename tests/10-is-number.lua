
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

describe("is number", function ()
  it("does not run if param contains letters", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'is number')
    :run(function ()
      _.push(o, 5)
    end)

    m:GET('/:num', function ()
      _.push(o, 'ruteger')
    end)

    m:RUN(GET('/123x123'))
    assert.same({'ruteger'}, o)
  end)

  it("runs if param only contains numbers", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:num')
    :param('num', 'is number')
    :run(function ()
      _.push(o, 1)
    end)

    m:RUN(GET('/123'))
    assert.same({1}, o)
  end)

end)
