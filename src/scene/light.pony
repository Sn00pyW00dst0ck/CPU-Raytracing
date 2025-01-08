use "../math"

primitive Point
primitive Directional
primitive Spot
type LightType is (Point | Directional | Spot)

class val Light 
    let position: Vector3
    let color: Vector3
    let intensity: F32

    let constant_attenuation: F32
    let linear_attenuation: F32
    let quadratic_attenuation: F32

    let light_type: LightType

    let direction: (Vector3 | None) // For directional and spot lights

    let cutoff_angle: (F32 | None) // For spot lights: In degrees or radians
    let outer_cutoff_angle: (F32 | None) // For spot lights: For smooth falloff (optional)

    new val point_light(position': Vector3, color': Vector3, intensity': F32, ca: F32, la: F32, qa: F32) =>
        position = position'
        color = color'
        intensity = intensity'

        constant_attenuation = ca
        linear_attenuation = la
        quadratic_attenuation = qa

        light_type = Point
        direction = None
        cutoff_angle = None
        outer_cutoff_angle = None
    
    new val directional_light(position': Vector3, color': Vector3, intensity': F32, direction': Vector3) =>
        position = position'
        color = color'
        intensity = intensity'

        constant_attenuation = 0
        linear_attenuation = 0
        quadratic_attenuation = 0

        light_type = Directional
        direction = direction'
        cutoff_angle = None
        outer_cutoff_angle = None

    new val spot_light(position': Vector3, color': Vector3, intensity': F32, ca: F32, la: F32, qa: F32, direction': Vector3, cutoff_angle': F32, outer_cutoff_angle': F32) => 
        position = position'
        color = color'
        intensity = intensity'

        constant_attenuation = ca
        linear_attenuation = la
        quadratic_attenuation = qa

        light_type = Spot
        direction = direction'
        cutoff_angle = cutoff_angle'
        outer_cutoff_angle = outer_cutoff_angle'

    fun box intensity_at(point: Vector3): F32? =>
        match light_type
        | Point =>
            let distance = VectorMath.magnitude(VectorMath.sub(point, position))
            if distance == 0.0 then 
                intensity
            else
                intensity / (constant_attenuation + (linear_attenuation * distance) + (quadratic_attenuation * distance * distance))
            end
        | Directional =>
            intensity // no falloff for directional lights
        | Spot =>
            match (direction, cutoff_angle, outer_cutoff_angle)
            | (let dir: Vector3, let ca: F32, let oca: F32) =>
                let light_dir = VectorMath.normalize(VectorMath.sub(position, point))?
                let cos_theta: F32 = VectorMath.dot(VectorMath.normalize(dir)?, light_dir)
                if cos_theta < ca.cos() then
                    0.0 // Outside spotlight cone
                else
                    let distance: F32 = VectorMath.magnitude(VectorMath.sub(point, position))
                    let base_intensity: F32 = intensity / (constant_attenuation + (linear_attenuation * distance) + (quadratic_attenuation * distance * distance))
                    
                    let spot_factor: F32 = 
                        if cos_theta > oca.cos() then
                            1.0
                        else
                            (cos_theta - oca.cos()) / (ca.cos() - oca.cos()) // Smooth falloff between outer and inner cutoff angles
                        end
                    
                    base_intensity * spot_factor
                end
            else 
                error
            end
        end
        
