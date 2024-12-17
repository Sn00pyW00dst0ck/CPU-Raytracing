use "../math"

// Define camera projection modes using a closed world type
primitive Orthographic
primitive Perspective
type CameraProjectionMode is (Orthographic | Perspective)

class Camera
    """
    Represents a camera in the scene.
    """

    let origin: Vector3[F64]
    let look_at: Vector3[F64]
    let up: Vector3[F64]
    let _direction: Vector3[F64]
    let _horizontal: Vector3[F64]
    let _vertical: Vector3[F64]
    let _lower_left_corner: Vector3[F64]
    let projection_mode: CameraProjectionMode
    
    new orthographic(
        origin': Vector3[F64], 
        look_at': Vector3[F64], 
        up': Vector3[F64],
        width: F64,
        height: F64
    )? => 
        """
        Create a new camera using orthographic projection.
        """
        origin = origin'
        look_at = look_at'
        up = up'
        _direction = (look_at - origin).normalize()?
        projection_mode = Orthographic

        // Camera basis vectors
        let w: Vector3[F64] = (origin - look_at).normalize()?
        let u: Vector3[F64] = up.cross(w).normalize()?
        let v: Vector3[F64] = w.cross(u)

        // Define the orthographic viewport
        _horizontal = u.scale(width)
        _vertical = v.scale(height)
        _lower_left_corner = origin - _horizontal.scale(1/2.0) - _vertical.scale(1/2.0)
    
    new perspective(
        origin': Vector3[F64], 
        look_at': Vector3[F64], 
        up': Vector3[F64],
        fov: F64,
        aspect_ratio: F64
    )? => 
        """
        Create a new camera using perspective projection.
        """
        origin = origin'
        look_at = look_at'
        up = up'
        _direction = (look_at - origin).normalize()?
        projection_mode = Perspective

        // Camera basis vectors
        let w: Vector3[F64]= (origin - look_at).normalize()?
        let u: Vector3[F64]= up.cross(w).normalize()?
        let v: Vector3[F64]= w.cross(u)

        // FOV calculations
        let viewport_height: F64 = 2.0 * (fov / 2.0).tan()
        let viewport_width: F64 = viewport_height * aspect_ratio

        _horizontal = u.scale(viewport_width)
        _vertical = v.scale(viewport_height)
        _lower_left_corner = origin - _horizontal.scale(1/2.0) - _vertical.scale(1/2.0) - w

    fun ref get_ray(s: F64, t: F64): Ray[F64]? =>
        """
        Generate a ray from the camera through a screen point (s, t).
        """
        match projection_mode
        | Perspective =>
            Ray[F64](origin, _lower_left_corner + _horizontal.scale(s) + _vertical.scale(t) + -origin)?
        | Orthographic =>
            Ray[F64](_lower_left_corner + _horizontal.scale(s) + _vertical.scale(t), - _direction)?
        end
