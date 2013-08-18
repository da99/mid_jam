local S    = require("pl.stringx")
local _    = require("underscore")

function GET(path)
  return {REQUEST_METHOD='GET', PATH_INFO=path}, {}, {}
end

function get_error_msg(str)
  local temp = S.split(str, ':')
  _.shift(temp)
  _.shift(temp)
  return S.strip(table.concat(temp, ':'))
end


