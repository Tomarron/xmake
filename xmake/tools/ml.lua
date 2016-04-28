--!The Automatic Cross-platform Build Tool
-- 
-- XMake is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
-- 
-- XMake is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
-- 
-- You should have received a copy of the GNU Lesser General Public License
-- along with XMake; 
-- If not, see <a href="http://www.gnu.org/licenses/"> http://www.gnu.org/licenses/</a>
-- 
-- Copyright (C) 2015 - 2016, ruki All rights reserved.
--
-- @author      ruki
-- @file        ml.lua
--

-- imports
import("utils.vsenv")

-- init it
function init(shellname)
   
    -- save name
    _g.shellname = shellname or "ml.exe"

    -- init asflags
    _g.asflags = { "-nologo", "-Gd", "-MP4", "-D_MBCS", "-D_CRT_SECURE_NO_WARNINGS"}

    -- init flags map
    _g.mapflags = 
    {
        -- optimize
        ["-O0"]                     = "-Od"
    ,   ["-O3"]                     = "-Ot"
    ,   ["-Ofast"]                  = "-Ox"
    ,   ["-fomit-frame-pointer"]    = "-Oy"

        -- symbols
    ,   ["-g"]                      = "-Z7"
    ,   ["-fvisibility=.*"]         = ""

        -- warnings
    ,   ["-Wall"]                   = "-W3" -- = "-Wall" will enable too more warnings
    ,   ["-W1"]                     = "-W1"
    ,   ["-W2"]                     = "-W2"
    ,   ["-W3"]                     = "-W3"
    ,   ["-Werror"]                 = "-WX"
    ,   ["%-Wno%-error=.*"]         = ""

        -- vectorexts
    ,   ["-mmmx"]                   = "-arch:MMX"
    ,   ["-msse"]                   = "-arch:SSE"
    ,   ["-msse2"]                  = "-arch:SSE2"
    ,   ["-msse3"]                  = "-arch:SSE3"
    ,   ["-mssse3"]                 = "-arch:SSSE3"
    ,   ["-mavx"]                   = "-arch:AVX"
    ,   ["-mavx2"]                  = "-arch:AVX2"
    ,   ["-mfpu=.*"]                = ""

        -- others
    ,   ["-ftrapv"]                 = ""
    ,   ["-fsanitize=address"]      = ""
    }

end

-- get the property
function get(name)

    -- get it
    return _g[name]
end

-- make the define flag
function define(macro)

    -- make it
    return "-D" .. macro:gsub("\"", "\\\"")
end

-- make the undefine flag
function undefine(macro)

    -- make it
    return "-U" .. macro
end

-- make the includedir flag
function includedir(dir)

    -- make it
    return "-I" .. dir
end

-- make the complie command
function compcmd(srcfile, objfile, flags, logfile)

    -- redirect
    local redirect = ""
    if logfile then redirect = format(" > %s 2>&1", logfile) end

    -- make it
    return format("%s -c %s -Fo%s %s%s", _g.shellname, flags, objfile, srcfile, redirect)
end

-- run command
function run(...)

    -- enter vs envirnoment
    vsenv.enter()

    -- run it
    os.run(...)

    -- leave vs envirnoment
    vsenv.leave()
end

-- check the given flags 
function check(flags)

    -- enter vs envirnoment
    vsenv.enter()

    -- make an stub source file
    local objfile = path.join(os.tmpdir(), "xmake.ml.obj")
    local srcfile = path.join(os.tmpdir(), "xmake.ml.asm")
    io.write(srcfile, "end")

    -- check it
    os.run("%s -c %s -Fo%s %s", _g.shellname, ifelse(flags, flags, ""), objfile, srcfile)

    -- remove files
    os.rm(objfile)
    os.rm(srcfile)

    -- leave vs envirnoment
    vsenv.leave()
end
