
local Mid  = require("mid_jam")
local _    = require("underscore")


describe("path match", function ()
  it("matches path despite capitalization", function ()
    local m = Mid.new()
    local o = {}
    local f = m:GET("/hOmE", function ()
      _.push(o, 1)
    end)

    f({REQUEST_METHOD='GET', PATH_INFO="/HOME"}, {})

    assert.same({1}, o)
  end)
end)


