import algorithm, tables, os, json, sequtils, nre, arraymancer, IA, helpers, extractor/video, extractor/subtitle, extractor/lips

let video_file = re"video\..*"
let file_ext = re"(.*)\.(.*)$"

proc separate_batch(b: seq[string]): seq[seq[string]] =
    var k = 0
    for i in 0..toInt((b.len-1)/4):
        var arr: array[4, string]
        arr[0..3] = b[i*4..i*4+3]

        if arr.sepImagesToTensor.run_separator().data[0] == 1:
            k = k+1
        result[k].add(b[i*4..i*4+3])

proc identify_phoneme(sep_b: seq[seq[string]]): Table[string, uint8] =
    result = initTable[string, uint8]()
    for p in sep_b:
        var arr: array[10, string]
        if p.len < 13:
            arr[0..9] = p
        else:
            let every = toInt(p.len/10)
            for i in 0..9:
                arr[i] = p[i*every]

        result.add(p[0], arr.imagesToTensor().run().uint8)


proc train_prealigned(data_path, phonemes_file: string) =
    let phonemes = parseFile(phonemes_file)["phonemes"].getElems.mapIt(it.getStr)
    for kind, path in walkDir(data_path, true):
        if kind == pcFile or kind == pcLinkToFile:
            if path.contains(video_file):
                let match = path.match(file_ext).get
                if #[existsFile(match[0] & ".wav") and]# existsFile(match.captures[0] & ".TextGrid"):
                    let images = path.toImages()
                    for kind, img_path in walkDir(images):
                        let lips = img_path.detect_lips()
                        if lips.x == 0 and lips.width == 0:
                            echo img_path & " Has no lips"
                            removeFile(img_path)
                        else:
                            lips.crop_lips(img_path)

                    let train = generate_train_data(toJson(match.captures[0] & ".TextGrid"), phonemes, images)
                    
                    for i in 0..((train.getElems.len-1)/100).toInt:
                        let (imgs, phos) = load_train_batch(train, i)
                        echo "Separator loss:" & $train_separator(imgs)
                        echo "Identifier loss:" & $train(imgs, phos)
                else:
                    echo "Missing TextGrid file for " & path

proc train_final(data_path, phonemes_file, dictionary_path, acoustic_model_path: string) =
    train_prealigned(data_path.align(dictionary_path, acoustic_model_path), phonemes_file)

proc use(video_path, phonemes_file: string) =
    let 
        phonemes = parseFile(phonemes_file)["phonemes"].getElems.mapIt(it.getStr)
        imgs = video_path.toImages()

    var list: seq[string]
    for kind, path in walkDir(imgs):
        let lips = path.detect_lips()
        if lips.x == 0 and lips.width == 0:
            echo path & " Has no lips"
        else:
            path.detect_lips.crop_lips(path)
            list.add(path)

    list.sort(system.cmp)

    echo list.separate_batch().identify_phoneme()

#TODO: test

when isMainModule:
    import cligen 
    dispatchMulti([use], [train_final], [train_prealigned])