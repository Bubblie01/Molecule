switch("debugger", "native")
switch("path", "../src")

when defined(windows):
  switch("passL", r"-LD:\Vulkan-API\Lib")
  switch("passL", "-lvulkan-1")
elif defined(linux):
  switch("passL", r"/usr/lib/libvulkan.so.1")