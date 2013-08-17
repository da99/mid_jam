
local Mid  = require("mid_jam")
local _    = require("underscore")


describe(":GET", function ()
  it("returns a function that runs on matched path", function ()
    local m = Mid.new()
    local o = {}
    local f = m:GET("/home", function ()
      _.push(o, 1)
    end)

    f({PATH_INFO="/home"}, {})

    assert.same({1}, o)
  end)
end)


