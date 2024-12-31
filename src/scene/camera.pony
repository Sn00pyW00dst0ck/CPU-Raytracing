use "../math"

// Define camera projection modes using a closed world type
primitive Orthographic
primitive Perspective
type CameraProjectionMode is (Orthographic | Perspective)


class Camera
    """
    Represents a camera in the scene.
    """

    let origin: Vector3
    let look_at: Vector3
    let up: Vector3
    let _direction: Vector3
    let _horizontal: Vector3
    let _vertical: Vector3
    let _lower_left_corner: Vector3
    let projection_mode: CameraProjectionMode
    
    new orthographic(
        origin': Vector3, 
        look_at': Vector3, 
        up': Vector3,
        width: F32,
        height: F32
    )? => 
        """
        Create a new camera using orthographic projection.
        """
        origin = origin'
        look_at = look_at'
        up = up'
        _direction = VectorMath.normalize(VectorMath.sub(look_at, origin))?
        projection_mode = Orthographic

        // Camera basis vectors
        let w: Vector3 = VectorMath.normalize(VectorMath.sub(look_at, origin))?
        let u: Vector3 = VectorMath.normalize(VectorMath.cross(up, w))?
        let v: Vector3 = VectorMath.cross(w, u)

        // Define the orthographic viewport
        _horizontal = VectorMath.scale(u, width)
        _vertical = VectorMath.scale(v, height)
        _lower_left_corner = VectorMath.sub(VectorMath.sub(origin, VectorMath.scale(_horizontal, 1/2.0)), VectorMath.scale(_vertical, 1/2.0))
    
    new perspective(
        origin': Vector3, 
        look_at': Vector3, 
        up': Vector3,
        fov: F32,
        aspect_ratio: F32
    )? => 
        """
        Create a new camera using perspective projection.
        """
        origin = origin'
        look_at = look_at'
        up = up'
        _direction = VectorMath.normalize(VectorMath.sub(origin, look_at))?
        projection_mode = Perspective

        // Camera basis vectors
        let w: Vector3 = VectorMath.normalize(VectorMath.sub(origin, look_at))?
        let u: Vector3 = VectorMath.normalize(VectorMath.cross(up, w))?
        let v: Vector3 = VectorMath.cross(w, u)

        // FOV calculations
        let viewport_height: F32 = 2.0 * (fov / 2.0).tan()
        let viewport_width: F32 = viewport_height * aspect_ratio

        _horizontal = VectorMath.scale(u, viewport_width)
        _vertical = VectorMath.scale(v, viewport_height)
        _lower_left_corner = VectorMath.sub(VectorMath.sub(VectorMath.sub(origin, VectorMath.scale(_horizontal, 1/2.0)), VectorMath.scale(_vertical, 1/2.0)), w)

    fun box get_ray(s: F32, t: F32): Ray? =>
        """
        Generate a ray from the camera through a screen point (s, t).
        """
        match projection_mode
        | Perspective =>
            Ray(origin, VectorMath.sub(VectorMath.add(VectorMath.add(_lower_left_corner, VectorMath.scale(_horizontal, s)), VectorMath.scale(_vertical, t)), origin))?
        | Orthographic =>
            Ray(VectorMath.add(VectorMath.add(_lower_left_corner, VectorMath.scale(_horizontal, s)), VectorMath.scale(_vertical, t)), VectorMath.sub((0,0,0), _direction))?
        end
