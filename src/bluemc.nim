import nimgl, nimgl/[opengl, glfw]
import strutils, os
import camera, controller, dataprotocol, inventory

proc drawAll(xpos: float, ypos: float, zpos: float, window: GLFWWindow): void =
  glfwPollEvents()
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glTranslatef(1.55+xpos, -1.75+ypos, -7.0+zpos)

  glBegin(GL_TRIANGLES)

  # Top face
  glColor3f(0.0, 1.0, 0.0)  # Green
  glVertex3f(1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)

  # Bottom face
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # Brown
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Front face
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # Brown
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)
  glVertex3f( 1.0, -1.0, 1.0)
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)

  # Back face
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # Brown
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f( 1.0,  1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)

  # Left face
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # Brown
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Right face
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0) # Brown
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0,  1.0,  1.0)
  glVertex3f(1.0, -1.0,  1.0)
  glVertex3f(1.0, -1.0, -1.0)
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0, -1.0,  1.0)

  glEnd()

  window.swapBuffers()
  
proc esc(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
        if key == int(GLFWKey.Escape):
            window.setWindowShouldClose(true)
  discard window.setKeyCallback(GLFWKeyFun(esc))

var blocks = string(open("blocks.bmc").readAll).split(";")

discard glfwInit()
glfwWindowHint(GLFWContextVersionMajor, 3)
glfwWindowHint(GLFWContextVersionMinor, 3)
glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
glfwWindowHint(GLFWResizable, GLFW_FALSE)
let window = glfwCreateWindow(800, 600, "BlueMC") # Making a window
window.makeContextCurrent
doAssert glInit()

glClearColor(GLFloat(172.0/255.0), GLFloat(246.0/255.0), GLFloat(246.0/255.0), GLFloat(1.0))
glClearDepth(1.0)
glEnable(GL_DEPTH_TEST)
glDepthFunc(GL_LEQUAL)
# glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
var xpos, ypos, zpos: float
if paramCount() == 0:
  xpos = 0.0
  ypos = 0.0
  zpos = 0.0
elif paramCount() == 3:
  xpos = parseFloat(paramStr(1))
  ypos = parseFloat(paramStr(2))
  zpos = parseFloat(paramStr(3))
while not window.windowShouldClose():
  drawAll(xpos, ypos, zpos, window)

window.destroyWindow()
glfwTerminate()