
local setmetatable = setmetatable
local print        = print
local select       = select
local error        = error
local require      = require
local tonumber     = tonumber
local string       = string
local unpack       = unpack

local _            = require("underscore")
local stringx      = require("pl.stringx")
local pretty       = require("pl.pretty")


-- -----------------------------------------
-- Clear globals. --------------------------
-- -----------------------------------------
local ENV = {}
setfenv(1, ENV)
-- -----------------------------------------
require('mid_jam._helper').to(ENV)

local Mid = {
  meta = {},
  Rules = {}
}

function Mid.new()
  local m = {}
  setmetatable(m, {__index = Mid.meta})
  m.paths = {}
  return m
end

function Mid.new_rule(name, func)
  Mid.Rules[name] = func
  return Mid
end

Mid.new_rule("length min", function(args, req, resp, env)
  local val = req.params[args[1]]
  return #val >= args[2]
end)

Mid.new_rule("length max", function(args, req, resp, env)
  local val = req.params[args[1]]
  return (#val <= args[2])
end)

Mid.new_rule("length between", function(args, req, resp, env)
  local val = req.params[args[1]]
  return (#val > args[2] and #val < args[3])
end)

Mid.new_rule("is number", function(args, req, resp, env)
  return not(not(tonumber(req.params[args[1]])))
end)

Mid.new_rule("a number between", function(args, req, resp, env)
  if not Mid.Rules["is number"](args, req) then
    return false
  end

  local num = tonumber(req.params[args[1]])
  return num > args[2] and num < args[3]
end)

Mid.new_rule("matches", function(args, req, resp, env)
  return not(not string.match(req.params[args[1]], args[2]))
end)

Mid.new_rule("does not match", function(args, req, resp, env)
  return not string.match(req.params[args[1]], args[2])
end)

-- ----------------------------------------
-- Helpers
-- ----------------------------------------

-- -----------------------------------------
-- "instance" functions
-- -----------------------------------------

-- HTTP Methods-----------------------------

function Mid.meta:New_Method(name)
  Mid.meta[name] = function (self, raw_path, func)
    local path = stringx.strip(raw_path)

    -- Start setting up the callable table
    local fin = {
      Mid          = Mid,
      params_table = to_param_table(path),
      params_rule_array = {},
      path         = path,
      func         = func,
      params       = function (self, name, action_name, ...)
        if not self.params_table[name] then
          error("Path has no param named: " .. name)
        end

        -- Save the rule.
        local rule = {...}
        _.unshift(rule, action_name)
        _.unshift(rule, name)
        _.push(self.params_rule_array, rule)

        return self
      end,

      run         = function (self, func)
        self.func = func
        return self
      end
    }

    -- Create the function that checks rules before calling
    --   the user-defined callback function.
    local function run_func_if_match(req, resp, env)
      if not path_match(req, name, path) then
        return
      end

      if not params_fulfill_rules(fin, req, resp, env) then
        return
      end

      return fin.func(req, resp, env)
    end

    -- Make sure params are set if no callback function is used.
    if not func and _.isEmpty(fin.params_table) then
      error('Path requires named params when no function is given: ' .. path)
    end

    -- Make table  callable.
    setmetatable(fin, {
      __call = function (tbl, ...)
        local f = tbl.func or func
        run_func_if_match(...)
      end
    })

    -- Finally, save and return the route.
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

--  ----------------------------------------

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






