##  Copyright (C) 2011  Davis E. King (davis@dlib.net), Nils Labugt, Changjiang Yang (yangcha@leidos.com)
##  License: Boost Software License   See LICENSE.txt for the full license.

import
  load_image_abstract, ../string, png_loader, jpeg_loader, image_loader

when defined(DLIB_GIF_SUPPORT):
type
  `type`* {.size: sizeof(cint), importcpp: "dlib::image_file_type::type",
           header: "load_image.hnim".} = enum
    BMP, JPG, PNG, DNG, GIF, UNKNOWN


proc read_type*(file_name: string): `type`
##  ----------------------------------------------------------------------------------------

proc load_image*[image_type](image: var image_type; file_name: string)
##  ----------------------------------------------------------------------------------------
