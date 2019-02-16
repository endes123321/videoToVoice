import arraymancer, json, sequtils

const batch_size = 100

#TODO unify
proc imagesToTensor*[T: seq[byte] or string](buffers: array[10, T]): Tensor[float32] =
    result = newTensor[float32]([30, 128, 256])
    for i in 0..9:
        let img = buffers[i].read_image().map_inline:
            x.float32 / 255.0
        result[i*3, _, _] = img[0, 127, 255]
        result[i*3 + 1, _, _] = img[1, 127, 255]
        result[i*3 + 2, _, _] = img[2, 127, 255]

proc sepImagesToTensor*[T: seq[byte] or string](buffers: array[4, T]): Tensor[float32] =
    result = newTensor[float32]([12, 128, 256])
    for i in 0..3:
        let img = buffers[i].read_image().map_inline:
            x.float32 / 255.0
        result[i*3, _, _] = img[0, 127, 255]
        result[i*3 + 1, _, _] = img[1, 127, 255]
        result[i*3 + 2, _, _] = img[2, 127, 255]

proc mapJson(x: JsonNode): string =
    return x.getStr

proc load_train_batch*(config: JsonNode, batch: int): tuple[img: seq[Tensor[float32]], phonemes: seq[uint8]] =
    result = (img: @[], phonemes: @[])
    for i in batch*batch_size..batch*batch_size + batch_size:
        var imgs: array[10, string]

        imgs[0..9] = config[i]["imgs"].getElems.map(mapJson)
        result.img.add(imgs.imagesToTensor)
        result.phonemes.add(config[i]["pho"].getInt.uint8)

proc load_normal_batch*(config: JsonNode, batch: int): seq[string] =
    for i in batch*batch_size..batch*batch_size + batch_size:
        result.add(config[i].getStr)

template phonemesToInt*(pho: seq[untyped]): seq[uint8] =
    for p in pho:
        result.add(p.uint8)