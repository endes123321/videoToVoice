import json, os, osproc,
        private
from times import cpuTime

proc toJson*(textgrid_file: string): JsonNode =
    let file = getTempDir() & "/vtv/" & $cpuTime().toInt() & ".json"
    exec "python parse_textgrid.py --input \"" & textgrid_file & "\" --output \"" & file & "\""
    result = parseFile(file)

proc generate_train_data*(textgrid_json: JsonNode, imgs_path: string): JsonNode =
    result = newJArray()
    for text in textgrid_json["tiers"][0]["items"].items:
        let r = newJObject()

        let minf = toInt(text["xmin"].getFloat * 30)
        let maxf = toInt(text["xmax"].getFloat * 30)

        r["pho"] = newJInt(int(text["text"].getStr[0])) #TODO
        r["imgs"] = newJArray()
        for i in minf..maxf:
            r["imgs"].add(newJString(imgs_path & $i & ".png"))
        
        result.add(r)

proc align*(data_path: string, config: tuple[dictionary_path, acoustic_model_path: string]): string =
    result = getTempDir() & "/vtv/align/" & $cpuTime().toInt()
    exec "mfa_align \"" & data_path & "\" \"" & config.dictionary_path & "\"" & config.acoustic_model_path & "\" \"" & result & "\""