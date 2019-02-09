##  Copyright (C) 2013  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

import
  frontal_face_detector_abstract, object_detector,
  scan_fhog_pyramid, ../compress_stream, ../base64

type
  frontal_face_detector* = object_detector[scan_fhog_pyramid[pyramid_down[6]]]

proc get_serialized_frontal_faces*(): string {.
    importcpp: "dlib::get_serialized_frontal_faces(@)", dynlib: dlibdll.}
proc get_frontal_face_detector*(): frontal_face_detector {.
    importcpp: "dlib::get_frontal_face_detector(@)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------
## 
##         It is built out of 5 HOG filters. A front looking, left looking, right looking, 
##         front looking but rotated left, and finally a front looking but rotated right one.
##         
##         Moreover, here is the training log and parameters used to generate the filters:
##         The front detector:
##             trained on mirrored set of labeled_faces_in_the_wild/frontal_faces.xml
##             upsampled each image by 2:1
##             used pyramid_down<6> 
##             loss per missed target: 1
##             epsilon: 0.05
##             padding: 0
##             detection window size: 80 80
##             C: 700
##             nuclear norm regularizer: 9
##             cell_size: 8
##             num filters: 78
##             num images: 4748
##             Train detector (precision,recall,AP): 0.999793 0.895517 0.895368 
##             singular value threshold: 0.15
## 
##         The left detector:
##             trained on labeled_faces_in_the_wild/left_faces.xml
##             upsampled each image by 2:1
##             used pyramid_down<6> 
##             loss per missed target: 2
##             epsilon: 0.05
##             padding: 0
##             detection window size: 80 80
##             C: 250
##             nuclear norm regularizer: 8
##             cell_size: 8
##             num filters: 63
##             num images: 493
##             Train detector (precision,recall,AP): 0.991803  0.86019 0.859486 
##             singular value threshold: 0.15
## 
##         The right detector:
##             trained left-right flip of labeled_faces_in_the_wild/left_faces.xml
##             upsampled each image by 2:1
##             used pyramid_down<6> 
##             loss per missed target: 2
##             epsilon: 0.05
##             padding: 0
##             detection window size: 80 80
##             C: 250
##             nuclear norm regularizer: 8
##             cell_size: 8
##             num filters: 66
##             num images: 493
##             Train detector (precision,recall,AP): 0.991781  0.85782 0.857341 
##             singular value threshold: 0.19
## 
##         The front-rotate-left detector:
##             trained on mirrored set of labeled_faces_in_the_wild/frontal_faces.xml
##             upsampled each image by 2:1
##             used pyramid_down<6> 
##             rotated left 27 degrees
##             loss per missed target: 1
##             epsilon: 0.05
##             padding: 0
##             detection window size: 80 80
##             C: 700
##             nuclear norm regularizer: 9
##             cell_size: 8
##             num images: 4748
##             singular value threshold: 0.12
## 
##         The front-rotate-right detector:
##             trained on mirrored set of labeled_faces_in_the_wild/frontal_faces.xml
##             upsampled each image by 2:1
##             used pyramid_down<6> 
##             rotated right 27 degrees
##             loss per missed target: 1
##             epsilon: 0.05
##             padding: 0
##             detection window size: 80 80
##             C: 700
##             nuclear norm regularizer: 9
##             cell_size: 8
##             num filters: 89
##             num images: 4748
##             Train detector (precision,recall,AP):        1 0.897369 0.897369 
##             singular value threshold: 0.15
## 

proc get_serialized_frontal_faces*(): string {.
    importcpp: "dlib::get_serialized_frontal_faces(@)", dynlib: dlibdll.}
