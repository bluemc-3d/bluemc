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
    proc fullscreen_toggle_esc(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
        if action == GLFWPress:
            var tempMonitorCount: int32
            var tempMonitors = glfwGetMonitors(tempMonitorCount.addr)
            var myxpos, myypos: int32 = 50
            if tempMonitorCount >= 2:
                myxpos = 1800
                myypos = -150
            var videoMode = tempMonitors[0].getVideoMode()
            var monwidth: int32 = videoMode.width
            var monheight: int32 = videoMode.height
            if key == int(GLFWKey.F11):
                setWindowMonitor(window, tempMonitors[0], 0, 0, monwidth, monheight, 0)
            elif key == int(GLFWKey.N):
                setWindowMonitor(window, nil, myxpos, myypos, 800, 600, 0)
            elif key == int(GLFWKey.Escape):
                window.setWindowShouldClose(true)
    discard window.setKeyCallback(GLFWKeyFun(fullscreen_toggle_esc))
    while not window.windowShouldClose():
        glfwPollEvents()
        glClearColor(GLFloat(172.0/255.0), GLFloat(246.0/255.0), GLFloat(246.0/255.0), GLFloat(0.98))
        glClear(GL_COLOR_BUFFER_BIT)
        for b in blocks.split(";"):
            drawAndParseBlock(b)
        window.swapBuffers()
    window.destroyWindow
    glfwTerminate()
main()