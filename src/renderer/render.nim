import ../dataprotocol

const blockSize* = 45.0
proc `*`(arg1: float, arg2: Vector) : Vector =
    newVector(arg1*arg2.x, arg1*arg2.y, arg1*arg2.z)
proc `+`(arg1: float, arg2: Vector) : Vector =
    newVector(arg1+arg2.x, arg1+arg2.y, arg1+arg2.z)

proc drawCube*(vector1: Vector, vector2: Vector, texture: Texture) : void =
    echo(vector1, vector2, texture)
proc drawBlock*(b: Block) : void =
    drawCube(blockSize*b.position, blockSize*(1.0+b.position), b.texture)
proc drawAndParseBlock*(blockdata: string) =
    drawBlock(parseBlock(blockdata))