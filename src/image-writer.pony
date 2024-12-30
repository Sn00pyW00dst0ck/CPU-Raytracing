use "files"
use "buffered"

actor PPMWriter
    """
    A PONY actor to write PPM file format images.
    """

    be apply(path: FilePath, width: U128, height: U128, max_color: U8, pixels: Array[(U8, U8, U8)] val) =>
        """
        Write the given PPM file data to the given filepath. 
        """
        match CreateFile(path)
        | let file: File =>
            // Write the PPM data headers.
            file.queue("P6\n")
            file.queue(width.string() + " " + height.string() + "\n")
            file.queue(max_color.string() + "\n")

            // Write the PPM pixel data.
            for pixel in pixels.values() do
                file.queue([pixel._1; pixel._2; pixel._3])
            end

            file.flush()
        end

// TODO: add other forms of images here (PNG, JPG)