import opengl, opengl/[glut, glu]
import os, strutils, threadpool
import camera, controller, dataprotocol, inventory

proc display() {.cdecl.} =
    discard

proc reshape(width: GLsizei, height: GLsizei) {.cdecl.} =
  if height == 0:
    return

  glViewport(0, 0, width, height)

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  
  gluPerspective(45.0, width / height, 0.1, 100.0)

proc drawAll(xpos: float, ypos: float, zpos: float): void =
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

  glutSwapBuffers()

var blocks = string(open("blocks.bmc").readAll).split(";")

# glutInit()
glutInitDisplayMode(GLUT_DOUBLE)
glutInitWindowSize(640, 480)
glutInitWindowPosition(50, 50)
discard glutCreateWindow("BlueMC")

if paramCount() == 1 and paramStr(1) == "-fullscreen":
  glutFullScreen()

glutSetCursor(GLUT_CURSOR_CROSSHAIR)

glutDisplayFunc(display)
glutReshapeFunc(reshape)

loadExtensions()

glClearColor(GLFloat(172.0/255.0), GLFloat(246.0/255.0), GLFloat(246.0/255.0), GLFloat(1.0))
glClearDepth(1.0)
glEnable(GL_DEPTH_TEST)
glDepthFunc(GL_LEQUAL)
glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

proc eventloop(): void {.gcsafe.} =
  while true:
    drawAll(0.0, 0.0, 0.0)

spawn eventloop()
glutMainLoop()