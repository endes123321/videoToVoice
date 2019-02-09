##  Copyright (C) 2008  Davis E. King (davis@dlib.net), Nils Labugt
##  License: Boost Software License   See LICENSE.txt for the full license.

import
  png_loader_abstract, image_loader, ../pixel, ../dir_nav,
  ../test_for_odr_violations

discard "forward decl of LibpngData"
type
  png_loader* {.importcpp: "dlib::png_loader", header: "png_loader.h", bycopy.} = object of noncopyable
  

proc constructpng_loader*(filename: cstring): png_loader {.constructor,
    importcpp: "dlib::png_loader(@)", dynlib: dlibdll.}
proc constructpng_loader*(filename: string): png_loader {.constructor,
    importcpp: "dlib::png_loader(@)", dynlib: dlibdll.}
proc constructpng_loader*(f: file): png_loader {.constructor,
    importcpp: "dlib::png_loader(@)", dynlib: dlibdll.}
proc destroypng_loader*(this: var png_loader) {.importcpp: "#.~png_loader()",
    dynlib: dlibdll.}
proc is_gray*(this: png_loader): bool {.noSideEffect, importcpp: "is_gray",
                                    dynlib: dlibdll.}
proc is_graya*(this: png_loader): bool {.noSideEffect, importcpp: "is_graya",
                                     dynlib: dlibdll.}
proc is_rgb*(this: png_loader): bool {.noSideEffect, importcpp: "is_rgb",
                                   dynlib: dlibdll.}
proc is_rgba*(this: png_loader): bool {.noSideEffect, importcpp: "is_rgba",
                                    dynlib: dlibdll.}
proc bit_depth*(this: png_loader): cuint {.noSideEffect, importcpp: "bit_depth",
                                       dynlib: dlibdll.}
proc get_image*[T](this: png_loader; t_: var T) {.noSideEffect, importcpp: "get_image",
    dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

proc load_png*[image_type](image: var image_type; file_name: string)
##  ----------------------------------------------------------------------------------------
