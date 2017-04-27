# Luacheck Love

Generates the `love_standard.lua` file necessary to provide support for [LÖVE](https://love2d.org/) in [Luacheck](https://github.com/mpeterv/luacheck) using the [love-api](https://github.com/love2d-community/love-api) tables.

## Run
To run you need Lua (5.1 or higher) or LuaJIT, then you should clone the repository and submodules:
```bash
git clone --recursive git@github.com:Positive07/luacheck-love.git
```
After that you cd to `luacheck-love` and run:
```bash
lua generate.lua
```
Where `lua` is the command you need to use to execute your Lua interpreter.

## License
**MIT License** - Copyright (c) 2017 Pablo A. Mayobre ([Positive07](https://github.com/Positive07))

This is the same license as Luacheck.

The `love_standard.lua` file belongs to the Luacheck repository and follows their own Copyright and License.
