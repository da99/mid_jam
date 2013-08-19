
package = "mid_jam"
version = "0.1-0"
source = {
  url = "http://github.com/jam-lua/mid_jam.git",
  tag = "2d42d50",
  dir = "."
}
description = {
  summary = "A DSL to create middleware (ie functions/closures.",
  detailed = [[
    Don't use this. You won't like it.
  ]],
  homepage = "http://github.com/jam-lua/mid_jam",
  license = "MIT/X11",
  maintainer = "da99@da99"
}
dependencies = {
  "lua >= 5.1",
  "penlight >= 0.1",
  "underscore >= 0.1"
}
build = {
  type = "builtin",
  modules = {
    ['mid_jam'] = 'lib/mid_jam.lua',
    ['mid_jam.test_dsl'] = 'lib/test_dsl.lua',
    ['mid_jam._helper']  = 'lib/_helper.lua'
  }
}
