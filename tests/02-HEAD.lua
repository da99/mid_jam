
local Mid  = require("mid_jam")
local _    = require("underscore")


describe(":HEAD", function ()
  it("returns a function that runs on matched path", function ()
    local m = Mid.new()
    local o = {}
    local f = m:HEAD("/HEAD", function ()
      _.push(o, 1)
    end)

    f({REQUEST_METHOD='HEAD', PATH_INFO="/HEAD"}, {})

    assert.same({1}, o)
  end)
end)


