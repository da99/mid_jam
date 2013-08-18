
local Mid  = require("mid_jam")
local _    = require("underscore")


describe("named args", function ()
  it("saves named args to params in req", function ()
    local m = Mid.new()
    local o = {}
    local f = m:GET("/:nAme", function (req, resp)
      _.push(o, req.params.nAme)
    end)

    f({REQUEST_METHOD='GET', PATH_INFO="/HOME"}, {})

    assert.same({'HOME'}, o)
  end)
end)


