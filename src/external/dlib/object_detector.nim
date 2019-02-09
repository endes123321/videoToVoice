##  Copyright (C) 2011  Davis E. King (davis@dlib.net)
##  License: Boost Software License   See LICENSE.txt for the full license.

import
  object_detector_abstract, ../geometry, box_overlap_testing, full_object_detection

##  ----------------------------------------------------------------------------------------

type
  rect_detection* {.importcpp: "dlib::rect_detection",
                   header: "object_detector.hnim", bycopy.} = object
    detection_confidence* {.importc: "detection_confidence".}: cdouble
    weight_index* {.importc: "weight_index".}: culong
    rect* {.importc: "rect".}: rectangle


proc `<`*(this: rect_detection; item: rect_detection): bool {.noSideEffect,
    importcpp: "(# < #)", dynlib: dlibdll.}
type
  full_detection* {.importcpp: "dlib::full_detection",
                   header: "object_detector.hnim", bycopy.} = object
    detection_confidence* {.importc: "detection_confidence".}: cdouble
    weight_index* {.importc: "weight_index".}: culong
    rect* {.importc: "rect".}: full_object_detection


proc `<`*(this: full_detection; item: full_detection): bool {.noSideEffect,
    importcpp: "(# < #)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

type
  processed_weight_vector* {.importcpp: "dlib::processed_weight_vector",
                            header: "object_detector.hnim", bycopy.}[
      image_scanner_type] = object
    w* {.importc: "w".}: feature_vector_type


proc constructprocessed_weight_vector*[image_scanner_type](): processed_weight_vector[
    image_scanner_type] {.constructor,
                         importcpp: "dlib::processed_weight_vector(@)",
                         dynlib: dlibdll.}
type
  feature_vector_type* = typename

proc init*[image_scanner_type](this: var processed_weight_vector[image_scanner_type];
                              a3: image_scanner_type) {.importcpp: "init",
    dynlib: dlibdll.}
  ## !
  ##             requires
  ##                 - w has already been assigned its value.  Note that the point of this
  ##                   function is to allow an image scanner to overload the
  ##                   processed_weight_vector template and provide some different kind of
  ##                   object as the output of get_detect_argument().  For example, the
  ##                   scan_fhog_pyramid object uses an overload that causes
  ##                   get_detect_argument() to return the special fhog_filterbank object
  ##                   instead of a feature_vector_type.  This avoids needing to construct the
  ##                   fhog_filterbank during each call to detect and therefore speeds up
  ##                   detection.
  ##         !
proc get_detect_argument*[image_scanner_type](
    this: processed_weight_vector[image_scanner_type]): feature_vector_type {.
    noSideEffect, importcpp: "get_detect_argument", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

type
  object_detector* {.importcpp: "dlib::object_detector",
                    header: "object_detector.hnim", bycopy.}[image_scanner_type_] = object
  
  image_scanner_type* = image_scanner_type_
  feature_vector_type* = typename

proc constructobject_detector*[image_scanner_type_](): object_detector[
    image_scanner_type_] {.constructor, importcpp: "dlib::object_detector(@)",
                          dynlib: dlibdll.}
proc constructobject_detector*[image_scanner_type_](item: object_detector): object_detector[
    image_scanner_type_] {.constructor, importcpp: "dlib::object_detector(@)",
                          dynlib: dlibdll.}
proc constructobject_detector*[image_scanner_type_](scanner_: image_scanner_type;
    overlap_tester_: test_box_overlap; w_: feature_vector_type): object_detector[
    image_scanner_type_] {.constructor, importcpp: "dlib::object_detector(@)",
                          dynlib: dlibdll.}
proc constructobject_detector*[image_scanner_type_](scanner_: image_scanner_type;
    overlap_tester_: test_box_overlap; w_: vector[feature_vector_type]): object_detector[
    image_scanner_type_] {.constructor, importcpp: "dlib::object_detector(@)",
                          dynlib: dlibdll.}
proc constructobject_detector*[image_scanner_type_](
    detectors: vector[object_detector]): object_detector[image_scanner_type_] {.
    constructor, importcpp: "dlib::object_detector(@)", dynlib: dlibdll.}
proc num_detectors*[image_scanner_type_](this: object_detector[image_scanner_type_]): culong {.
    noSideEffect, importcpp: "num_detectors", dynlib: dlibdll.}
proc get_w*[image_scanner_type_](this: object_detector[image_scanner_type_];
                                idx: culong = 0): feature_vector_type {.noSideEffect,
    importcpp: "get_w", dynlib: dlibdll.}
proc get_processed_w*[image_scanner_type_](
    this: object_detector[image_scanner_type_]; idx: culong = 0): processed_weight_vector[
    image_scanner_type] {.noSideEffect, importcpp: "get_processed_w",
                         dynlib: dlibdll.}
proc get_overlap_tester*[image_scanner_type_](
    this: object_detector[image_scanner_type_]): test_box_overlap {.noSideEffect,
    importcpp: "get_overlap_tester", dynlib: dlibdll.}
proc get_scanner*[image_scanner_type_](this: object_detector[image_scanner_type_]): image_scanner_type {.
    noSideEffect, importcpp: "get_scanner", dynlib: dlibdll.}
proc `()`*[image_scanner_type_; image_type](
    this: var object_detector[image_scanner_type_]; img: image_type;
    adjust_threshold: cdouble = 0): vector[rectangle] {.importcpp: "#(@)",
    dynlib: dlibdll.}
proc `()`*[image_scanner_type_; image_type](
    this: var object_detector[image_scanner_type_]; img: image_type;
    final_dets: var vector[pair[cdouble, rectangle]]; adjust_threshold: cdouble = 0) {.
    importcpp: "#(@)", dynlib: dlibdll.}
proc `()`*[image_scanner_type_; image_type](
    this: var object_detector[image_scanner_type_]; img: image_type;
    final_dets: var vector[pair[cdouble, full_object_detection]];
    adjust_threshold: cdouble = 0) {.importcpp: "#(@)", dynlib: dlibdll.}
proc `()`*[image_scanner_type_; image_type](
    this: var object_detector[image_scanner_type_]; img: image_type;
    final_dets: var vector[full_object_detection]; adjust_threshold: cdouble = 0) {.
    importcpp: "#(@)", dynlib: dlibdll.}
proc `()`*[image_scanner_type_; image_type](
    this: var object_detector[image_scanner_type_]; img: image_type;
    final_dets: var vector[rect_detection]; adjust_threshold: cdouble = 0) {.
    importcpp: "#(@)", dynlib: dlibdll.}
proc `()`*[image_scanner_type_; image_type](
    this: var object_detector[image_scanner_type_]; img: image_type;
    final_dets: var vector[full_detection]; adjust_threshold: cdouble = 0) {.
    importcpp: "#(@)", dynlib: dlibdll.}
##  ----------------------------------------------------------------------------------------

proc serialize*[T](item: object_detector[T]; `out`: var ostream)
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##                       object_detector member functions
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------

proc object_detector*(img: image_type; final_dets: var vector[rect_detection];
                     adjust_threshold: cdouble)
##  ----------------------------------------------------------------------------------------

proc object_detector*[image_scanner_type](img: image_type;
    final_dets: var vector[full_detection]; adjust_threshold: cdouble)
##  ----------------------------------------------------------------------------------------

proc object_detector*[image_scanner_type](img: image_type;
    adjust_threshold: cdouble): vector[rectangle]
##  ----------------------------------------------------------------------------------------

proc object_detector*[image_scanner_type](img: image_type;
    final_dets: var vector[pair[cdouble, rectangle]]; adjust_threshold: cdouble)
##  ----------------------------------------------------------------------------------------

proc object_detector*[image_scanner_type](img: image_type;
    final_dets: var vector[pair[cdouble, full_object_detection]];
    adjust_threshold: cdouble)
##  ----------------------------------------------------------------------------------------

proc object_detector*[image_scanner_type](img: image_type;
    final_dets: var vector[full_object_detection]; adjust_threshold: cdouble)
##  ----------------------------------------------------------------------------------------

proc get_overlap_tester*[image_scanner_type](): var test_box_overlap {.noSideEffect.}
##  ----------------------------------------------------------------------------------------
##  ----------------------------------------------------------------------------------------
