##  Copyright (C) 2013  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.


import
    object_detector_abstract, scan_fhog_pyramid_abstract,
    ../image_transforms/image_pyramid_abstract

type
    frontal_face_detector* = object_detector[scan_fhog_pyramid[pyramid_down[6]]]
proc get_frontal_face_detector*(): frontal_face_detector {.
      importcpp: "dlib::get_frontal_face_detector(@)", dynlib: dlibdll.}
## !
##         ensures
##             - returns an object_detector that is configured to find human faces that are
##               looking more or less towards the camera.
##     !
