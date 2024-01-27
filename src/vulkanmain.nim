import vulkan
import staticglfw

var window: Window
const validationLayers = ["VK_LAYER_LUNARG_standard_validation"]

proc initWindow
proc mainLoop
proc cleanup
proc initVulkan
proc checkValidLayerSupport(): bool
proc getRequiredExtensions(): seq[cstring]

var enableValidationLayers: bool

when not defined(debug):
  enableValidationLayers = false
else:
  enableValidationLayers = true

proc run =
  initWindow()
  initVulkan()
  mainLoop()
  cleanup()
  echo checkValidLayerSupport()
  

proc initWindow =
  if init() == 0:
    raise newException(Exception, "Failed to Initialize GLFW")
  window = createWindow(800,600, "GLFW MOMENT", nil, nil)
  windowHint(CLIENT_API, NO_API)
  windowHint(RESIZABLE, FALSE)
  
proc mainLoop =
  while windowShouldClose(window) == 0:
    pollEvents()

proc cleanup =
  window.destroyWindow()
  terminate()


proc initVulkan = 
  var appInfo = VkApplicationInfo(
    sType: VkStructureType.applicationInfo,
    pNext: nil,
    pApplicationName: "Triangle Instance",
    applicationVersion: vkMakeVersion(1,0,0),
    pEngineName: "Molecule",
    engineVersion: 1,
    apiVersion: vkVersion10)

  if enableValidationLayers and not checkValidLayerSupport():
    var exception: ref ValueError
    exception.msg = "validation layers were requested, but not available."
    raise exception



  var extensions = getRequiredExtensions()
  var instanceCreateInfo = VkInstanceCreateInfo(
    sType: VkStructureType.instanceCreateInfo,
    pNext: nil,
    flags: 0,
    pApplicationInfo: addr appInfo,
    enabledLayerCount: (if enableValidationLayers: validationLayers.len else: 0),
    enabledExtensionCount: uint32 extensions.len,
    ppEnabledExtensionNames: cast[cstringArray](extensions[0]))

  


# create an instance
  var instance: vulkan.VkInstance
  var result = vkCreateInstance(addr instanceCreateInfo, nil, addr instance)
  if result == vulkan.VkResult.errorIncompatibleDriver:
    quit "Cannot find a compatible Vulkan ICD"
  elif result != vulkan.VkResult.success:
    quit "Failed to create instance: " & $result
  else:
    echo "Success"

  var extensionCount: cuint
  var name: cstring
  var properties: VkExtensionProperties
  extensionCount = 0
  var extentionProperties = vkEnumerateInstanceExtensionProperties(nil, addr extensionCount, nil)
  

# clean up
  vkDestroyInstance(instance, nil)

proc checkValidLayerSupport(): bool =
  var layerCount: cuint
  var layerProperties = vkEnumerateInstanceLayerProperties(addr layerCount, nil)
  var layerSequence = newSeq[VkLayerProperties](layerCount)
  layerProperties = vkEnumerateInstanceLayerProperties(addr layercount, addr layerSequence[0])

  
  for layerName in validationLayers:
    var layerFound = false

    for layerProperties in layerSequence: 
      if layerName == layerProperties.layerName:
        layerFound = true
        break 
    if not layerFound:
      result = false
    

  result = true


proc getRequiredExtensions(): seq[cstring] = 
  var
     glfwExtensionCount: cuint = 0
     glfwExtensions = (getRequiredInstanceExtensions(addr glfwExtensionCount))
  
  result.add(cast[cstring](glfwExtensions))

  if enableValidationLayers:
    result.add((vkExtDebugReportExtensionName))






run()