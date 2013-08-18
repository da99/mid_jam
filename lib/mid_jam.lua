

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

-- ----------------------------------------
-- Helpers
-- ----------------------------------------

function path_match(req, meth, path)
  return req['REQUEST_METHOD'] == meth and req['PATH_INFO'] == path
end

-- -----------------------------------------
-- "instance" functions
-- -----------------------------------------

-- HTTP Methods-----------------------------

function Mid.meta:HEAD(path, func)
  local f
  function f(req, resp)
    if path_match(req, 'HEAD', path) then
      return func(env, req, resp)
    end
  end

  _.push(self.paths, f)
  return f
end -- func

function Mid.meta:GET(path, func)
  local f
  function f(req, resp)
    if path_match(req, 'GET', path) then
      return func(env, req, resp)
    end
  end

  _.push(self.paths, f)
  return f
end -- func

function Mid.meta:POST(path, func)
  local f
  function f(req, resp)
    if path_match(req, 'POST', path) then
      return func(env, req, resp)
    end
  end

  _.push(self.paths, f)
  return f
end -- func

function Mid.meta:PUT(path, func)
  local f
  function f(req, resp)
    if path_match(req, 'PUT', path) then
      return func(env, req, resp)
    end
  end

  _.push(self.paths, f)
  return f
end -- func

function Mid.meta:DELETE(path, func)
  local f
  function f(req, resp)
    if path_match(req, 'DELETE', path) then
      return func(env, req, resp)
    end
  end

  _.push(self.paths, f)
  return f
end -- func

-- Finished actions -----------------------

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






