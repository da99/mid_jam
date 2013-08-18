

local setmetatable = setmetatable
local print        = print
local select       = select
local error        = error
local string       = string
local unpack       = unpack

local _            = require("underscore")
local stringx      = require("pl.stringx")


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

  -- Do the match in method?
  if not (req['REQUEST_METHOD'] == meth) then
    return false
  end

  local up_path = string.upper(path)
  local up_info = string.upper(req.PATH_INFO)

  -- Do uppercase path and path_info match?
  if up_path == up_info then
    return true
  end

  local patterns   = stringx.split(up_path, '/')
  local orig_names = _.map(stringx.split(path, '/'), function (v)
    return stringx.replace(stringx.strip(v), ':', '', 1)
  end)
  local args       = stringx.split(up_info, '/')

  -- Do they match in length?
  if not (#patterns == #args) then
    return false
  end

  local match = false
  local names = {}

  local results = _.map(patterns, function (raw, i)
    local v = stringx.strip(raw)
    local actual = args[i] -- we do not strip the value passed by user.

    if v == actual then
      return true
    end

    if _.empty(stringx.strip(actual)) then -- guards against ///path//
      return false
    end

    if stringx.at(v, 1) ~= ':' then -- if not name, return
      return false
    end

    if stringx.strip(actual) ~= actual then -- whitespace in path piece
      return false
    end

    names[orig_names[i]] = actual
    return true
  end)

  local u = _.uniq(results)

  if #u == 1 and u[1] == true then
    req.params = _.extend(req.params or {}, names)
    return true
  end

  return false
end

-- -----------------------------------------
-- "instance" functions
-- -----------------------------------------

-- HTTP Methods-----------------------------

function Mid.meta:New_Method(name)
  Mid.meta[name] = function (self, path, func)
    local strip = stringx.strip(path)
    if path ~= strip then
      error("Path has whitespace: \"" .. path .. '"')
    end

    if _.isEmpty(path) then
      error("Path is empty for: " .. name)
    end

    local function f(req, resp, env)
      if path_match(req, name, path) then
        return func(req, resp, env)
      end
    end

    _.push(self.paths, f)
    return f
  end

  return Mid.meta[name]
end

Mid.meta:New_Method('HEAD')
Mid.meta:New_Method('GET')
Mid.meta:New_Method('POST')
Mid.meta:New_Method('PUT')
Mid.meta:New_Method('DELETE')


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






