class val Texture
    """
    Represents a texture (image) that can be sampled from. 
    """

    let pixels: Array[Array[(U8, U8, U8)] val] val
        """Rows then columns"""
    let width: USize
    let height: USize

    new val create(pixels': Array[Array[(U8, U8, U8)] val] val, width': USize, height': USize) =>
        pixels = pixels'
        width = width'
        height = height'

    fun box sample(u: F32, v: F32): (U8, U8, U8)? =>
        """
        Sample the texture color at UV coordinates (u, v).
        """
        let x = (u * (width - 1).f32()).floor().usize()
        let y = (v * (height - 1).f32()).floor().usize()
        pixels(y)?(x)?
