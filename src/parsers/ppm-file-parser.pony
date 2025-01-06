use "collections"
use "files"
use "promises"

use "../scene"


actor PPMFileParser

    be apply(path: FilePath, promise: Promise[Texture val]) =>
        """
        Parse a PPM file (P6) into a 'Texture' object.
        """

        match OpenFile(path)
        | let file: File =>
            try 
                // Read the header data...
                let lines: FileLines ref = file.lines()
                let header: String iso = lines.next()? // TODO: add support for P3 vs P6 headers
                let dimensions: Array[String] = lines.next()?.split()
                let width: USize = dimensions(0)?.usize()?
                let height: USize = dimensions(1)?.usize()?
                let range: U8 = lines.next()?.u8()? // TODO: assuming 255 for now, but in future update this...

                // Read the binary data...
                let pixels: Array[Array[(U8, U8, U8)] val] iso = Array[Array[(U8, U8, U8)] val](height)
                for i in Range[USize](0, height) do
                    let row: Array[(U8, U8, U8)] iso = Array[(U8, U8, U8)](width)
                    for j in Range[USize](0, width) do
                        let r: U8 = file.read(1)(0)? // Read red component
                        let g: U8 = file.read(1)(0)? // Read green component
                        let b: U8 = file.read(1)(0)? // Read blue component
                        row.push((r, g, b))
                    end
                    pixels.push(consume row)
                end

                // TODO: ensure width and height are valid for the pixel data that was read.
                promise(Texture(consume pixels, width, height))
                return
            end
        | FileOK =>
            """A type of error that can occur when opening the file."""
        | FileEOF =>
            """A type of error that can occur when opening the file."""
        | FileBadFileNumber =>
            """A type of error that can occur when opening the file."""
        | FileExists =>
            """A type of error that can occur when opening the file."""
        | FileError =>
            """A type of error that can occur when opening the file."""
        | FilePermissionDenied =>
            """A type of error that can occur when opening the file."""
        end
        promise.reject()
