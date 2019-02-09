##  Copyright (C) 2011  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

when defined(DLIB_OBJECT_DeTECTOR_ABSTRACT_Hh_):
  import
    ../geometry, box_overlap_testing_abstract, full_object_detection_abstract

  ##  ----------------------------------------------------------------------------------------
  type
    rect_detection* {.importcpp: "dlib::rect_detection",
                     header: "object_detector_abstract.hnim", bycopy.} = object
      detection_confidence* {.importc: "detection_confidence".}: cdouble
      weight_index* {.importc: "weight_index".}: culong
      rect* {.importc: "rect".}: rectangle

    full_detection* {.importcpp: "dlib::full_detection",
                     header: "object_detector_abstract.hnim", bycopy.} = object
      detection_confidence* {.importc: "detection_confidence".}: cdouble
      weight_index* {.importc: "weight_index".}: culong
      rect* {.importc: "rect".}: full_object_detection



  ##  ----------------------------------------------------------------------------------------
  type
    object_detector* {.importcpp: "dlib::object_detector",
                      header: "object_detector_abstract.hnim", bycopy.}[
        image_scanner_type_] = object ## !
                                   ##             REQUIREMENTS ON image_scanner_type_
                                   ##                 image_scanner_type_ must be an implementation of 
                                   ##                 dlib/image_processing/scan_image_pyramid_abstract.h or 
                                   ##                 dlib/image_processing/scan_fhog_pyramid.h or 
                                   ##                 dlib/image_processing/scan_image_custom.h or 
                                   ##                 dlib/image_processing/scan_image_boxes_abstract.h 
                                   ## 
                                   ##             WHAT THIS OBJECT REPRESENTS
                                   ##                 This object is a tool for detecting the positions of objects in an image.
                                   ##                 In particular, it is a simple container to aggregate an instance of an image 
                                   ##                 scanner (i.e. scan_image_pyramid, scan_fhog_pyramid, scan_image_custom, or
                                   ##                 scan_image_boxes), the weight vector needed by one of these image scanners,
                                   ##                 and finally an instance of test_box_overlap.  The test_box_overlap object
                                   ##                 is used to perform non-max suppression on the output of the image scanner
                                   ##                 object.  
                                   ## 
                                   ##                 Note further that this object can contain multiple weight vectors.  In this
                                   ##                 case, it will run the image scanner multiple times, once with each of the
                                   ##                 weight vectors.  Then it will aggregate the results from all runs, perform
                                   ##                 non-max suppression and then return the results.  Therefore, the object_detector 
                                   ##                 can also be used as a container for a set of object detectors that all use
                                   ##                 the same image scanner but different weight vectors.  This is useful since
                                   ##                 the object detection procedure has two parts.  A loading step where the
                                   ##                 image is loaded into the scanner, then a detect step which uses the weight
                                   ##                 vector to locate objects in the image.  Since the loading step is independent 
                                   ##                 of the weight vector it is most efficient to run multiple detectors by
                                   ##                 performing one load into a scanner followed by multiple detect steps.  This
                                   ##                 avoids unnecessarily loading the same image into the scanner multiple times.  
                                   ##         !
    
    image_scanner_type* = image_scanner_type_
    feature_vector_type* = typename
  proc constructobject_detector*[image_scanner_type_](): object_detector[
      image_scanner_type_] {.constructor, importcpp: "dlib::object_detector(@)",
                            dynlib: dlibdll.}
  proc constructobject_detector*[image_scanner_type_](item: object_detector): object_detector[
      image_scanner_type_] {.constructor, importcpp: "dlib::object_detector(@)",
                            dynlib: dlibdll.}
  proc constructobject_detector*[image_scanner_type_](
      scanner: image_scanner_type; overlap_tester: test_box_overlap;
      w: feature_vector_type): object_detector[image_scanner_type_] {.constructor,
      importcpp: "dlib::object_detector(@)", dynlib: dlibdll.}
  proc constructobject_detector*[image_scanner_type_](
      scanner: image_scanner_type; overlap_tester: test_box_overlap;
      w: vector[feature_vector_type]): object_detector[image_scanner_type_] {.
      constructor, importcpp: "dlib::object_detector(@)", dynlib: dlibdll.}
  proc constructobject_detector*[image_scanner_type_](
      detectors: vector[object_detector]): object_detector[image_scanner_type_] {.
      constructor, importcpp: "dlib::object_detector(@)", dynlib: dlibdll.}
  proc num_detectors*[image_scanner_type_](
      this: object_detector[image_scanner_type_]): culong {.noSideEffect,
      importcpp: "num_detectors", dynlib: dlibdll.}
  proc get_w*[image_scanner_type_](this: object_detector[image_scanner_type_];
                                  idx: culong = 0): feature_vector_type {.
      noSideEffect, importcpp: "get_w", dynlib: dlibdll.}
  proc get_overlap_tester*[image_scanner_type_](
      this: object_detector[image_scanner_type_]): test_box_overlap {.noSideEffect,
      importcpp: "get_overlap_tester", dynlib: dlibdll.}
  proc get_scanner*[image_scanner_type_](this: object_detector[image_scanner_type_]): image_scanner_type {.
      noSideEffect, importcpp: "get_scanner", dynlib: dlibdll.}
  proc `()`*[image_scanner_type_; image_type](
      this: var object_detector[image_scanner_type_]; img: image_type;
      dets: var vector[rect_detection]; adjust_threshold: cdouble = 0) {.
      importcpp: "#(@)", dynlib: dlibdll.}
  proc `()`*[image_scanner_type_; image_type](
      this: var object_detector[image_scanner_type_]; img: image_type;
      dets: var vector[full_detection]; adjust_threshold: cdouble = 0) {.
      importcpp: "#(@)", dynlib: dlibdll.}
  proc `()`*[image_scanner_type_; image_type](
      this: var object_detector[image_scanner_type_]; img: image_type;
      adjust_threshold: cdouble = 0): vector[rectangle] {.importcpp: "#(@)",
      dynlib: dlibdll.}
  proc `()`*[image_scanner_type_; image_type](
      this: var object_detector[image_scanner_type_]; img: image_type;
      dets: var vector[pair[cdouble, rectangle]]; adjust_threshold: cdouble = 0) {.
      importcpp: "#(@)", dynlib: dlibdll.}
  proc `()`*[image_scanner_type_; image_type](
      this: var object_detector[image_scanner_type_]; img: image_type;
      dets: var vector[pair[cdouble, full_object_detection]];
      adjust_threshold: cdouble = 0) {.importcpp: "#(@)", dynlib: dlibdll.}
  proc `()`*[image_scanner_type_; image_type](
      this: var object_detector[image_scanner_type_]; img: image_type;
      dets: var vector[full_object_detection]; adjust_threshold: cdouble = 0) {.
      importcpp: "#(@)", dynlib: dlibdll.}


  ##  ----------------------------------------------------------------------------------------
  proc serialize*[T](item: object_detector[T]; `out`: var ostream) {.
      importcpp: "dlib::serialize(@)", dynlib: dlibdll.}
  ## !
  ##         provides serialization support.  Note that this function only saves the
  ##         configuration part of item.get_scanner().  That is, we use the scanner's
  ##         copy_configuration() function to get a copy of the scanner that doesn't contain any
  ##         loaded image data and we then save just the configuration part of the scanner.
  ##         This means that any serialized object_detectors won't remember any images they have
  ##         processed but will otherwise contain all their state and be able to detect objects
  ##         in new images.
  ##     !
  ##  ----------------------------------------------------------------------------------------
  proc deserialize*[T](item: var object_detector[T]; `in`: var istream) {.
      importcpp: "dlib::deserialize(@)", dynlib: dlibdll.}
  ## !
  ##         provides deserialization support
  ##     !
  ##  ----------------------------------------------------------------------------------------