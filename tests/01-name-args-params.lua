
local Mid  = require("mid_jam")
local _    = require("underscore")
local S    = require("pl.stringx")

function get_error_msg(str)
  local temp = S.split(str, ':')
  _.shift(temp)
  _.shift(temp)
  return S.strip(table.concat(temp, ':'))
end

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
end)


