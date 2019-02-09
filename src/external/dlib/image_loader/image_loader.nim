##  Copyright (C) 2006  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

import
  image_loader_abstract, ../algs, ../pixel, ../image_saver/dng_shared,
  ../entropy_decoder_model, ../entropy_decoder, ../uintn,
  ../image_transforms/assign_image, ../vectorstream

##  ----------------------------------------------------------------------------------------

type
  image_load_error* {.importcpp: "dlib::image_load_error",
                     header: "image_loader.hnim", bycopy.} = object of error
  

proc constructimage_load_error*(str: string): image_load_error {.constructor,
    importcpp: "dlib::image_load_error(@)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

proc load_bmp*[image_type](image_: var image_type; `in_`: var istream) {.
    importcpp: "dlib::load_bmp(@)", dynlib: dlibdll.}
##  ---------------------------------------------------------------------------------------

proc load_dng*(image_: var image_type; `in`: var istream) {.
    importcpp: "dlib::load_dng(@)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

proc load_bmp*[image_type](image: var image_type; file_name: string) {.
    importcpp: "dlib::load_bmp(@)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

proc load_dng*[image_type](image: var image_type; file_name: string) {.
    importcpp: "dlib::load_dng(@)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------
