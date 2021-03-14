# unfinished
import nimgl/[glfw, opengl]
import dataprotocol, renderer/render, camera, inventory, controller
import strutils, json
proc main() =
    let blocks = open("blocks.bmc").readAll
    doAssert glfwInit()
    glfwWindowHint(GLFWContextVersionMajor, 3)
    glfwWindowHint(GLFWContextVersionMinor, 3)
    glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
    glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
    glfwWindowHint(GLFWResizable, GLFW_FALSE)
    var monitorCount: int32
    var monitors = glfwGetMonitors(monitorCount.addr)
    var windowxpos: int32 = 50
    var windowypos: int32 = 50
    if monitorCount >= 2:
        windowxpos = 1800
        windowypos = -150
    let window = glfwCreateWindow(800, 600, "BlueMC") # Making a window
    var windowisfullscreen = false
    setWindowMonitor(window, nil, windowxpos, windowypos, 800, 600, 0)
    doAssert window != nil
    window.makeContextCurrent
    doAssert glInit()
    proc esc_close(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
        if key == int(GLFWKey.Escape) and action == GLFWPress:
            window.setWindowShouldClose(true)
    proc fullscreen_toggle(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
        if key == int(GLFWKey.F11) and action == GLFWPress:
            windowisfullscreen = not windowisfullscreen
    discard window.setKeyCallback(GLFWKeyFun(fullscreen_toggle))
    var monitorparam: GLFWMonitor = nil
    while not window.windowShouldClose():
        window.swapBuffers()
        if windowisfullscreen and monitorparam == nil:
            monitorparam = monitors[0]
        elif (not windowisfullscreen) and (monitorparam != nil):
            monitorparam = nil
        setWindowMonitor(window, monitorparam, windowxpos, windowypos, 800, 600, 0)
        glClearColor(172.0, 246.0, 246.0, 0.92)
        for b in blocks.split(";"):
            drawAndParseBlock(b)
        glfwPollEvents()
    window.destroyWindow
    glfwTerminate()
main()