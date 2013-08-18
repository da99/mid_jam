
local Mid  = require("mid_jam")
local _    = require("underscore")


describe("named args:params", function ()
  it("returns error if no name args", function ()
    local m = Mid.new()
    local o = {}
    local val, msg = pcall(function ()
      local f = m:GET("/nAme")
      :params(":nAme", "length at least", 1)
      :run(function () end)
    end)

    assert.same("Path has no named params: /nAme", msg)
  end)
end)


