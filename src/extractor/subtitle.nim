import json, os, osproc,
        private
from times import cpuTime

proc toJson*(textgrid_file: string): JsonNode =
    let file = getTempDir() & "/vtv/" & $cpuTime().toInt() & ".json"
    exec "python parse_textgrid.py --input \"" & textgrid_file & "\" --output \"" & file & "\""
    result = parseFile(file)

proc generate_train_data*(textgrid_json: JsonNode, phonemes: seq[string], imgs_path: string): JsonNode =
    result = newJArray()
    for text in textgrid_json["tiers"][0]["items"].items:
        let r = newJObject()

        let minf = toInt(text["xmin"].getFloat * 30)
        let maxf = toInt(text["xmax"].getFloat * 30)

        for i in 0..phonemes.len-1:
            if phonemes[i] == text["text"].getStr:
                r["pho"] = newJInt(i)
                break
        r["imgs"] = newJArray()
        for i in minf..maxf:
            r["imgs"].add(newJString(imgs_path & $i & ".png"))
        
        result.add(r)

proc align*(data_path: string, dictionary_path, acoustic_model_path: string): string =
    result = getTempDir() & "/vtv/align/" & $cpuTime().toInt()
    copyDir(data_path, result)
    exec "mfa_align \"" & data_path & "\" \"" & dictionary_path & "\"" & acoustic_model_path & "\" \"" & result & "\""