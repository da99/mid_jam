
local Mid      = require("mid_jam")
local _        = require("underscore")
local S        = require("pl.stringx")
local describe = describe
local it       = it
local ENV      = {}
local require  = require
local pcall    = pcall
local assert   = assert
local error    = error
local table    = table

setfenv(1, ENV)
require('mid_jam.test_dsl').to(ENV)

describe("named args:params", function ()
  it("returns error if no name args", function ()
    local m = Mid.new()
    local o = {}
    local val, msg = pcall(function ()
      local f = m:GET("/nAme")
      :params(":nAme", "length min", 1)
      :run(function () end)
    end)

    local target ="Path requires named params when no function is given: /nAme"
    assert.same(target, get_error_msg(msg))
  end)

  it("runs func if path fulfills requirements", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', "length min", 1)
    :run(function (req, resp, env)
      _.push(o, 1)
    end)
    m:RUN(GET('/my_puppy'))

    assert.same({1}, o)
  end)

  it("does not run func if path does not fulill requirements", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', 'length min', 5)
    :run(function ()
      error("This should not be reached.")
    end)

    m:GET('/:name')
    :params('name', 'length min', 3)
    :run(function ()
      _.push(o, 1)
    end)

    m:RUN(GET('/ted'))

    assert.same({1}, o)
  end)
end)




