import arraymancer, nimpy, arraymancer_vision

let ir = pyImport("face_recognition")
let py = pyBuiltinsModule()

proc detect_lips*(img: string): tuple[x, y, width, height: int] =
    result = (0,0,0,0)

    let face = ir.face_landmarks(ir.load_image_file(img))
    if py.len(face).to(int) > 0 and py.len(face[0]["top_lip"]).to(int) > 7 and py.len(face[0]["bottom_lip"]).to(int) > 3:
        let face_features = face[0]
        result.x = face_features["top_lip"][0][0].to(int)
        result.y = face_features["top_lip"][2][1].to(int)

        result.width = face_features["top_lip"][6][0].to(int) - result.x
        result.height = face_features["bottom_lip"][3][1].to(int) - result.y 

proc crop_lips*(lips: tuple[x, y, width, height: int], img: string) =
    var loaded_img = img.load()
    loaded_img = loaded_img.crop(lips.x, lips.y, lips.width, lips.height)
    loaded_img = loaded_img.scale(256, 128, ScaleBilinear)
    loaded_img.save(img)