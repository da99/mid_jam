
local Mid  = require("mid_jam")
local _    = require("underscore")


describe(":PUT", function ()
  it("returns a function that runs on matched path", function ()
    local m = Mid.new()
    local o = {}
    local f = m:PUT("/PUT", function ()
      _.push(o, 1)
    end)

    f({REQUEST_METHOD='PUT', PATH_INFO="/PUT"}, {})

    assert.same({1}, o)
  end)
end)


