
Mid\_Jam
========

*NOTE:* This is still not ready. Many, if not most,
  would consider it a toy. Purely for esoteric reasons.


Usage
=====

```lua
  local Mid_Jam = require("mid_jam")
  local mj      = Mid_Jam.new()

  some_rack_clone.use(
    mj:GET("/my/:name/:obj")
      :param("name", "length at least", 1)
      :param("name", "length at most", 20)
      :param("obj",  "within", {'pet', 'candy', 'snowball'})
      :then(function (req, resp, next)
        -- do something magical
      end)
  )
```

Installation
============


Haha.... good luck with that!


More to come...
============

Later.
