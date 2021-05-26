import nimgl, nimgl/[opengl, glfw]
import glm
import strutils, os
import camera, controller, dataprotocol, inventory
  
proc esc(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
    if key == int(GLFWKey.Escape):
      window.setWindowShouldClose(true)
    if key == int(GLFWKey.Space):
      glPolygonMode(GL_FRONT_AND_BACK, if action != GLFWRelease: GL_LINE else: GL_FILL)

var blocks = string(open("blocks.bmc").readAll).split(";")

discard glfwInit()
glfwWindowHint(GLFWContextVersionMajor, 3)
glfwWindowHint(GLFWContextVersionMinor, 3)
glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
glfwWindowHint(GLFWResizable, GLFW_FALSE)
let window = glfwCreateWindow(800, 600, "BlueMC") # Making a window
window.makeContextCurrent
discard window.setKeyCallback(GLFWKeyFun(esc))
doAssert glInit()

proc statusShader(shader: int32) =
  var status: int32
  glGetShaderiv(GLuint(shader), GL_COMPILE_STATUS, status.addr)
  if status != GL_TRUE.ord:
    var
      log_length: int32
      message = newSeq[char](1024)
    glGetShaderInfoLog(GLuint(shader), 1024, log_length.addr, message[0].addr)
    echo message

proc toRGB(vec: Vec3[float32]): Vec3[float32] =
  return vec3(vec.x / 255, vec.y / 255, vec.z / 255)

var
  mesh: tuple[vbo, vao, ebo: uint32]
  vertex: uint32
  fragment: uint32
  program: uint32

var vert = @[
  0.3f, 0.3f,
  0.3f, -0.3f,
  -0.3f, -0.3f,
  -0.3f, 0.3f
]

var ind = @[
  0'u32, 1'u32, 3'u32,
  1'u32, 2'u32, 3'u32
]

glGenBuffers(1, mesh.vbo.addr)
glGenBuffers(1, mesh.ebo.addr)
glGenVertexArrays(1, mesh.vao.addr)

glBindVertexArray(mesh.vao)

glBindBuffer(GL_ARRAY_BUFFER, mesh.vbo)
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mesh.ebo)

glBufferData(GL_ARRAY_BUFFER, cint(cfloat.sizeof * vert.len), vert[0].addr, GL_STATIC_DRAW)
glBufferData(GL_ELEMENT_ARRAY_BUFFER, cint(cuint.sizeof * ind.len), ind[0].addr, GL_STATIC_DRAW)

glEnableVertexAttribArray(0)
glVertexAttribPointer(GLuint(0), GLint(2), EGL_FLOAT, false, GLsizei(cfloat.sizeof * 2), nil)

vertex = glCreateShader(GL_VERTEX_SHADER)
var vsrc: cstring = """
# version 330 core
layout (location = 0) in vec2 aPos;

uniform mat4 uMVP;

void main() {
  gl_Position = vec4(aPos, 0.0, 1.0) * uMVP;
}
"""
glShaderSource(vertex, 1'i32, vsrc.addr, nil)
glCompileShader(vertex)
statusShader(int32(vertex))

fragment = glCreateShader(GL_FRAGMENT_SHADER)
var fsrc: cstring = """
#version 330 core
out vec3 FragColor;

uniform vec3 uColor;

void main() {
  FragColor = vec4(uColor, 1.0f);
}
"""
glShaderSource(fragment, 1, fsrc.addr, nil)
glCompileShader(GLuint(fragment))
statusShader(int32(fragment))

program = glCreateProgram()
glAttachShader(program, vertex)
glAttachShader(program, fragment)
glLinkProgram(program)

var
  log_length: int32
  message = newSeq[char](1024)
  pLinked: int32
glGetProgramiv(program, GL_LINK_STATUS, pLinked.addr)
if pLinked != GL_TRUE.ord:
  glGetProgramInfoLog(program, 1024, log_length.addr, message[0].addr)
  echo message

let
  uColor = glGetUniformLocation(program, "uColor")
  uMVP = glGetUniformLocation(program, "uMVP")
var
  bg = vec3(172f, 246f, 246f).toRGB()
  color = vec3(50f, 205f, 50f).toRGB()
  mvp = ortho(-2f, 2f, -1.5f, 1.5f, -1f, 1f)
glEnable(GL_DEPTH_TEST)
glDepthFunc(GL_LEQUAL)
# glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
#[
var xpos, ypos, zpos: float
if paramCount() == 0:
  xpos = 0.0
  ypos = 0.0
  zpos = 0.0
elif paramCount() == 3:
  xpos = parseFloat(paramStr(1))
  ypos = parseFloat(paramStr(2))
  zpos = parseFloat(paramStr(3))
]#
while not window.windowShouldClose():
  glClearColor(bg.r, bg.g, bg.b, 1f)
  glClear(GL_COLOR_BUFFER_BIT)

  glUseProgram(program)
  glUniform3fv(uColor, GLsizei(1), color.caddr)
  glUniformMatrix4fv(GLint(uMVP), GLsizei(1), false, mvp.caddr)

  glBindVertexArray(mesh.vao)
  glDrawElements(GL_TRIANGLES, ind.len.cint, GL_UNSIGNED_INT, nil)

  #[
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
  ]#

  window.swapBuffers()
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()

glDeleteVertexArrays(1, mesh.vao.addr)
glDeleteBuffers(1, mesh.vbo.addr)
glDeleteBuffers(1, mesh.ebo.addr)