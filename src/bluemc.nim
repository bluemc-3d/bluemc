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
    setWindowMonitor(window, nil, windowxpos, windowypos, 800, 600, 0)
    doAssert window != nil
    window.makeContextCurrent
    doAssert glInit()
    proc esc_close(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
        if key == int(GLFWKey.Escape) and action == GLFWPress:
            window.setWindowShouldClose(true)
    proc fullscreen_toggle(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
        if action == GLFWPress:
            var tempMonitorCount: int32
            var tempMonitors = glfwGetMonitors(tempMonitorCount.addr)
            var myxpos, myypos: int32 = 50
            if tempMonitorCount >= 2:
                myxpos = 1800
                myypos = -150
            if key == int(GLFWKey.F11):
                setWindowMonitor(window, tempMonitors[0], myxpos, myypos, 800, 600, 0)
            elif key == int(GLFWKey.N):
                setWindowMonitor(window, nil, myxpos, myypos, 800, 600, 0)
    discard window.setKeyCallback(GLFWKeyFun(fullscreen_toggle))
    discard window.setKeyCallback(GLFWKeyFun(esc_close))
    while not window.windowShouldClose():
        window.swapBuffers()
        glClearColor(GLFloat(172.0), GLFloat(246.0), GLFloat(246.0), GLFloat(0.98))
        for b in blocks.split(";"):
            drawAndParseBlock(b)
        glfwPollEvents()
    window.destroyWindow
    glfwTerminate()
main()