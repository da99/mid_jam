

local setmetatable = setmetatable
local print        = print
local select       = select
local error        = error
local string       = string
local unpack       = unpack

local _            = require("underscore")
local stringx      = require("pl.stringx")
local pretty       = require("pl.pretty")


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

function strip_whitespace_and_first_colon(str)
  return stringx.replace(stringx.strip(str), ':', '', 1)
end

function to_param_table(path)
  local tbl    = {}
  _.each(stringx.split(path, '/'), function (raw_v)
    local v = stringx.strip(raw_v)
    if stringx.at(v, 1) == ':' then
      tbl[strip_whitespace_and_first_colon(v)] = {}
    end
  end)
  return tbl
end

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
    return strip_whitespace_and_first_colon(v)
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

    if _.isEmpty(stringx.strip(actual)) then -- guards against ///path//
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
  Mid.meta[name] = function (self, raw_path, func)
    local path = stringx.strip(raw_path)

    local function run_func_if_match(req, resp, env)
      if path_match(req, name, path) then
        return func(req, resp, env)
      end
    end

    local fin = {
      params_table = to_param_table(path),
      path         = path,
      params       = function (self, name, action_name, ...)
        if not self.params_table[name] then
          error("Path has no param named: " .. name)
        end
        _.push(self.params_table, {action_name = action_name, args = {...} })
        return self
      end
    }

    if not func and _.isEmpty(fin.params_table) then
      error('Path requires named params when no function is given: ' .. path)
    end

    setmetatable(fin, {
      __call = function (tbl, ...)
        run_func_if_match(...)
      end
    })

    _.push(self.paths, fin)
    return fin
  end

  return Mid.meta[name]
end

Mid.meta:New_Method('HEAD')
Mid.meta:New_Method('GET')
Mid.meta:New_Method('POST')
Mid.meta:New_Method('PUT')
Mid.meta:New_Method('DELETE')


-- Finished actions -----------------------

function Mid.meta:RUN(req, resp, env)
  _.detect(self.paths, function (f)
    return f(req, resp, env)
  end)

  return req, resp
end


--  ----------------------------------------
--  Done
--  ----------------------------------------
return Mid






