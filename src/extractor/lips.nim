import nimpy, arraymancer_vision

proc detect_lips*(img: string): tuple[x, y, width, height: int] =
    result = (0,0,0,0)
    let ir = pyImport("face_recognition")

    let face_features = ir.face_landmarks(ir.load_image_file(img))[0]
    result.x = face_features["top_lip"][0].x.to(int)
    result.y = face_features["top_lip"][2].y.to(int)

    result.width = face_features["top_lip"][4].x.to(int) - result.x
    result.height = face_features["bottom_lip"][3].y.to(int) - result.y

proc crop_lips*(lips: tuple[x, y, width, height: int], img: string) =
    var loaded_img = img.load()
    loaded_img = loaded_img.crop(lips.x, lips.y, lips.width, lips.height)
    loaded_img = loaded_img.scale(256, 256, ScaleBilinear)
    loaded_img.save(img)