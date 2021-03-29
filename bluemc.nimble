# Package

version       = "0.0.3"
author        = "Joshua Cohen"
description   = "A free, open-source clone of Minecraft"
license       = "MIT"
srcDir        = "src"
bin           = @["bluemc"]


# Dependencies

requires "nim >= 1.4.4"
requires "opengl >= 1.1.9"


# Tasks

task buildmc, "Build the package":
  exec "nimble build --threads:on"