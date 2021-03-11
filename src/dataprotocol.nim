import json
import strutils

type
  Texture* = object
    top*: string
    side*: string

type
  Vector* = object
    x*: float
    y*: float
    z*: float

type
  NamespacedString* = object
    namespace*: string
    data*: string

type
  Block* = object
    position*: Vector
    id*: NamespacedString
    texture*: Texture

proc newTexture*(top: string, side: string) : Texture =
  result.top = top
  result.side = side

proc parseTexture*(data: string) : Texture =
  let textureJson = parseJson(data)
  result.top = textureJson["top"].getStr()
  result.side = textureJson["side"].getStr()

proc newVector*(x: float, y: float, z: float) : Vector =
  result.x = x
  result.y = y
  result.z = z

proc parseVector*(data: string) : Vector =
  let vectorJson = parseJson(data)
  result.x = vectorJson["x"].getFloat()
  result.y = vectorJson["y"].getFloat()
  result.z = vectorJson["z"].getFloat()

proc newNamespacedString*(namespace: string, data: string) : NamespacedString =
  result.namespace = namespace
  result.data = data

proc parseNamespacedString*(data: string) : NamespacedString =
  let dataseq = data.split(":")
  result.namespace = dataseq[0]
  result.data = dataseq[1]

proc newBlock*(position: Vector, id: NamespacedString, texture: Texture) : Block =
  result.position = position
  result.id = id
  result.texture = texture

proc parseBlock*(data: string) : Block =
  let blockJson = parseJson(data)
  result.id = parseNamespacedString(blockJson["id"].getStr())
  result.position = parseVector(blockJson["position"].getStr())
  result.texture = parseTexture(blockJson["texture"].getStr())

# tests
if isMainModule:
  doAssert parseBlock("""{"id": "bluemc:test", "position": "{\"x\": 1.73, \"y\": 2.14, \"z\": 3.14159265358979323846}", "texture": "{\"top\": \"hi\", \"side\": \"hello\"}"}""") == newBlock(newVector(1.73, 2.14, 3.14159265358979323846), newNamespacedString("bluemc", "test"), newTexture("hi", "hello"))