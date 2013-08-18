
local Mid  = require("mid_jam")
local _    = require("underscore")


describe(":DELETE", function ()
  it("returns a function that runs on matched path", function ()
    local m = Mid.new()
    local o = {}
    local f = m:DELETE("/DELETE", function ()
      _.push(o, 1)
    end)

    f({REQUEST_METHOD='DELETE', PATH_INFO="/DELETE"}, {})

    assert.same({1}, o)
  end)
end)


