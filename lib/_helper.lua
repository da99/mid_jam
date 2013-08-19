local setmetatable = setmetatable
local print        = print
local select       = select
local error        = error
local tonumber     = tonumber
local string       = string
local unpack       = unpack

local _            = require("underscore")
local stringx      = require("pl.stringx")
local pretty       = require("pl.pretty")

local ENV          = {}
setfenv(1, ENV)

local The_Rules = {}

function canon_rule_name (str)
  return string.lower( (stringx.strip(str)):gsub("%s+", " ") )
end

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

function params_fulfill_rules(tbl, req, resp, env)
  local The_Rules = tbl.Mid.Rules
  local is_fail = _.detect(tbl.params_rule_array, function (rule)
    local clone = _.clone(rule)

    local f = _.last(clone)

    if _.isFunction(f) then
      _.pop(clone)
      return not f(clone, req, resp, env)
    end

    local param_name = _.shift(clone)
    local rule_name  = canon_rule_name(_.shift(clone))

    local f = The_Rules[rule_name]
    if not f then
      error("No rule defined for: " .. rule_name)
    end

    return not f({name = param_name, val=req.params[param_name], args=clone}, req, resp, env)
  end)

  return not is_fail
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


return {
  ENV = ENV,
  to  = function (e)
    return _.extend(e, ENV)
  end
}

