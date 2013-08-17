

local setmetatable = setmetatable
local print        = print
local select       = select
local error        = error
local unpack       = unpack

local _            = require("underscore")


-- -----------------------------------------
-- Clear globals. --------------------------
-- -----------------------------------------
setfenv(1, {})
-- -----------------------------------------

local Mid = {
  meta = {}
}

function Mid.new()
  local m = {}
  setmetatable(m, {__index = Mid.meta})
  m.paths = {}
  return m
end


-- -----------------------------------------
-- "instance" functions
-- -----------------------------------------

function Mid.meta:GET(path, func)
  local f
  function f(req, resp)
    if req['PATH_INFO'] == path then
      return func(env, req, resp)
    end
  end

  _.push(self.paths, f)
  return f
end -- func

function Mid.meta:RUN(req, resp)
  _.detect(self.paths, function (f)
    return f(req, resp)
  end)

  return req, resp
end
--  ----------------------------------------
--  Done
--  ----------------------------------------
return Mid
