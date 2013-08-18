
local Mid  = require("mid_jam")
local _    = require("underscore")


describe(":RUN", function ()
  it("runs all functions that match req/env", function ()
    local m = Mid.new()
    local o = {}
    local f = m:GET("/home", function ()
      _.push(o, 1)
    end)

    local f = m:GET("/home", function ()
      _.push(o, 1)
    end)

    local f = m:GET("/home", function ()
      return "done"
    end)

    m:RUN({REQUEST_METHOD='GET', PATH_INFO="/home"}, {}, {})

    assert.same({1,1}, o)
  end)
end)


