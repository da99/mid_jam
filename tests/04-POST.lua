
local Mid  = require("mid_jam")
local _    = require("underscore")


describe(":POST", function ()
  it("returns a function that runs on matched path", function ()
    local m = Mid.new()
    local o = {}
    local f = m:POST("/post", function ()
      _.push(o, 1)
    end)

    f({REQUEST_METHOD='POST', PATH_INFO="/post"}, {})

    assert.same({1}, o)
  end)
end)


