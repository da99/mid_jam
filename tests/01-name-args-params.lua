
local Mid  = require("mid_jam")
local _    = require("underscore")
local S    = require("pl.stringx")
require("mid_jam.test_dsl")

describe("named args:params", function ()
  it("returns error if no name args", function ()
    local m = Mid.new()
    local o = {}
    local val, msg = pcall(function ()
      local f = m:GET("/nAme")
      :params(":nAme", "length at least", 1)
      :run(function () end)
    end)

    local target ="Path requires named params when no function is given: /nAme"
    assert.same(target, get_error_msg(msg))
  end)

  it("runs func if path fulfills requirements", function ()
    local m = Mid.new()
    local o = {}
    m:GET('/:name')
    :params('name', "length at least", 1)
    :run(function (req, resp, env)
      _.push(o, 1)
    end)
    m:RUN(GET('/my_puppy'))

    assert.same({1}, o)
  end)
end)




