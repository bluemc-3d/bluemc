# unfinished
import nimgl/[glfw, opengl]
import dataprotocol
import strutils, json
proc main() =
    let blocks = open("blocks.bmc").readAll
    const blockSize = 45.0
    proc `*`(arg1: float, arg2: Vector) : Vector =
        newVector(arg1*arg2.x, arg1*arg2.y, arg1*arg2.z)
    proc `+`(arg1: float, arg2: Vector) : Vector =
        newVector(arg1+arg2.x, arg1+arg2.y, arg1+arg2.z)
    doAssert glfwInit()
    glfwWindowHint(GLFWContextVersionMajor, 3)
    glfwWindowHint(GLFWContextVersionMinor, 3)
    glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
    glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
    glfwWindowHint(GLFWResizable, GLFW_FALSE)
    let window = glfwCreateWindow(800, 600, "BlueMC") # Making a window
    doAssert window != nil
    window.makeContextCurrent
    doAssert glInit()
    proc esc_close(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
        if key == int(GLFWKey.Escape) and action == GLFWPress:
            window.setWindowShouldClose(true)
    discard window.setKeyCallback(GLFWKeyFun(esc_close))
    proc drawCube(vector1: Vector, vector2: Vector, texture: Texture) : void =
      echo(vector1, vector2, texture)
    proc drawBlock(b: Block) : void =
        drawCube(blockSize*b.position, blockSize*(1.0+b.position), b.texture)
    for b in blocks.split(";"):
        drawBlock(parseBlock(b))
    while not window.windowShouldClose():
        window.swapBuffers()
        glClear((GL_COLOR_BUFFER_BIT) or (GL_DEPTH_BUFFER_BIT))
        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        glEnable(GL_DEPTH_TEST)
        glTranslatef(1.5f, 0.0f, -7.0f)
        glBegin(GL_QUADS)
        glColor3f(0.0f, 1.0f, 0.0f)     # Green
        glVertex3f(1.0f, 1.0f, -1.0f)
        glVertex3f(-1.0f, 1.0f, -1.0f)
        glVertex3f(-1.0f, 1.0f, 1.0f)
        glVertex3f(1.0f, 1.0f, 1.0f)

        # Bottom face (y = -1.0f)
        glColor3f(1.0f, 0.5f, 0.0f)     # Orange
        glVertex3f(1.0f, -1.0f, 1.0f)
        glVertex3f(-1.0f, -1.0f, 1.0f)
        glVertex3f(-1.0f, -1.0f, -1.0f)
        glVertex3f(1.0f, -1.0f, -1.0f)

        # Front face  (z = 1.0f)
        glColor3f(1.0f, 0.0f, 0.0f)     # Red
        glVertex3f(1.0f, 1.0f, 1.0f)
        glVertex3f(-1.0f, 1.0f, 1.0f)
        glVertex3f(-1.0f, -1.0f, 1.0f)
        glVertex3f(1.0f, -1.0f, 1.0f)

        # Back face (z = -1.0f)
        glColor3f(1.0f, 1.0f, 0.0f)     # Yellow
        glVertex3f(1.0f, -1.0f, -1.0f)
        glVertex3f(-1.0f, -1.0f, -1.0f)
        glVertex3f(-1.0f, 1.0f, -1.0f)
        glVertex3f(1.0f, 1.0f, -1.0f)

        # Left face (x = -1.0f)
        glColor3f(0.0f, 0.0f, 1.0f)     # Blue
        glVertex3f(-1.0f, 1.0f, 1.0f)
        glVertex3f(-1.0f, 1.0f, -1.0f)
        glVertex3f(-1.0f, -1.0f, -1.0f)
        glVertex3f(-1.0f, -1.0f, 1.0f)

        # Right face (x = 1.0f)
        glColor3f(1.0f, 0.0f, 1.0f)     # Magenta
        glVertex3f(1.0f, 1.0f, -1.0f)
        glVertex3f(1.0f, 1.0f, 1.0f)
        glVertex3f(1.0f, -1.0f, 1.0f)
        glVertex3f(1.0f, -1.0f, -1.0f)
        glEnd()  # End of drawing color-cube
        glFlush()
        glfwPollEvents()
    window.destroyWindow
    glfwTerminate()
main()