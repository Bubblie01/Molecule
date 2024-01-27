# Package Info

version     = "1.0.0"
author      = "Bubblie"
description = "Nim vulkan test"
license     = "MPL"
srcDir      = "src"

#Deps

requires "https://github.com/nimious/vulkan.git#09e02a0339ed6132ae34b9a4d35c22375cea55d5"
requires "staticglfw"

bin = @["vulkanmain"]