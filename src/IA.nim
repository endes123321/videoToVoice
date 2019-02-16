import arraymancer

const 
    PHONEME_CATEGORIES = 41
    LEARNIG = 0.0002'f32
let
    ctx = newContext Tensor[float32]
    ctx_separator = newContext Tensor[float32]

network ctx, PhoNet:
    layers:
        x:          Input([1, 128, 256])
        cv1:        Conv2D(x.out_shape, 40, 5, 5)
        mp1:        MaxPool2D(cv1.out_shape, (2,2), (0,0), (2,2))
        cv2:        Conv2D(mp1.out_shape, 70, 5, 5)
        mp2:        MaxPool2D(cv2.out_shape, (2,2), (0,0), (2,2))
        cv3:        Conv2D(mp2.out_shape, 100, 5, 5)
        mp3:        MaxPool2D(cv3.out_shape, (2,2), (0,0), (2,2))
        cv4:        Conv2D(mp3.out_shape, 130, 5, 5)
        mp4:        MaxPool2D(cv4.out_shape, (4,4), (0,0), (4,4))
        fl:         Flatten(mp2.out_shape)
        hidden1:    Linear(fl.out_shape, 500)
        hidden2:    Linear(500, 160)
        classifier: Linear(160, PHONEME_CATEGORIES)
    forward x:
        x.cv1.relu.mp1.cv2.relu.mp2.cv3.relu.mp3.cv4.relu.mp4.fl.hidden1.relu.hidden1.relu.classifier

network ctx_separator, SeparatorNet:
    layers:
        x:          Input([1, 128, 256])
        cv1:        Conv2D(x.out_shape, 6, 5, 5)
        mp1:        MaxPool2D(cv1.out_shape, (2,2), (0,0), (2,2))
        cv2:        Conv2D(mp1.out_shape, 8, 5, 5)
        mp2:        MaxPool2D(cv2.out_shape, (2,2), (0,0), (2,2))
        cv3:        Conv2D(mp2.out_shape, 15, 5, 5)
        mp3:        MaxPool2D(cv3.out_shape, (2,2), (0,0), (2,2))
        cv4:        Conv2D(mp3.out_shape, 20, 5, 5)
        mp4:        MaxPool2D(cv4.out_shape, (4,4), (0,0), (4,4))
        fl:         Flatten(mp4.out_shape)
        hidden1:    Linear(fl.out_shape, 250)
        hidden2:    Linear(250, 80)
        classifier: Linear(80, 1)
    forward x:
        x.cv1.relu.mp1.cv2.relu.mp2.cv3.relu.mp3.cv4.relu.mp4.fl.hidden1.relu.hidden2.relu.classifier

#[let 
    model = ctx.init(PhoNet)
    model_sep = ctx_separator.init(SeparatorNet)
var
    optim = model.optimizerAdam(learning_rate = LEARNIG)
    optim_sep = model_sep.optimizerSGD(learning_rate = 0.01'f32)]#

#TODO: Unify
proc train*(x: seq[Tensor[float32]], phonemes: seq[uint8]): float32 =
    let model = ctx.init(PhoNet)
    var optim = model.optimizerAdam(learning_rate = LEARNIG)
    for i in 0..x.len-1:
        var y = newTensor[float32]([30, PHONEME_CATEGORIES])
        y[0..29, 0..PHONEME_CATEGORIES-1] = 0
        y[0..29, phonemes[i].int] = 1

        let x_train = ctx.variable x[i].unsqueeze(1)
        let loss = model.forward(x_train).sparse_softmax_cross_entropy(y)
        loss.backprop()
        optim.update()
        if i == x.len-1:
            result = loss.value.data[0]

#TODO: better function
proc train_separator*(x: seq[Tensor[float32]]): float32 =
    let model_sep = ctx_separator.init(SeparatorNet)
    var optim_sep = model_sep.optimizerSGD(learning_rate = 0.01'f32)
    var train_data = newTensor[float32]([12, 1])
    for i in 0..x.len-1:
        for n in 0..9:
            train_data[0..11, _] = [0.toFloat.float32].toTensor

            let x_train = ctx_separator.variable x[i][_, _, n..n*3].unsqueeze(1)
            let loss = model_sep.forward(x_train).sigmoid_cross_entropy(train_data)
            loss.backprop()
            optim_sep.update()
            if i == x.len-1 and n == 9:
                result = loss.value.data[0]
        if i != x.len-1:
            train_data[0..11, _] = [1.toFloat.float32].toTensor

            var x_final = newTensor[float32]([256, 256, 12])
            for k in 0..5:
                x_final[_, _, k] = x[i][_, _, 24+k]
            for k in 1..6:
                x_final[_, _, k+5] = x[i+1][_, _, k-1]
            let x_train = ctx_separator.variable x_final.unsqueeze(1)
            let loss = model_sep.forward(x_train).sigmoid_cross_entropy(train_data)
            loss.backprop()
            optim_sep.update()

proc test*[T](x: array[T, Tensor[float32]], phonemes: array[T, uint8]): float =
    let model = ctx.init(PhoNet)
    ctx.no_grad_mode:
        for i in 0..T:
            let x_test = ctx.variable x[i].unsqueeze(1)
            let y_pred = model.forward(x_test).value.softmax.argmax(axis = 1).squeeze.mean()

            result += accuracy_score(phonemes[i], y_pred.data[0].toInt.uint8)
        result = result / (T+1)

#TODO: better function
proc test_separator*[T](x: array[T, Tensor[float32]]): float =
    let model_sep = ctx_separator.init(SeparatorNet)
    ctx_separator.no_grad_mode:
        for i in 0..T:
            for n in 0...9:
                let x_test = ctx_separator.variable x[i][_, _, n...n*3].unsqueeze(1)
                let y_pred = model_sep.forward(x_test).value.softmax.argmax(axis = 0).squeeze

                result += accuracy_score(0, y_pred)
            if i != T:
                var x_final = newTensor[float32]([256, 256, 12])
                for k in 0..5:
                    x_final[_, _, k] = x[i][_, _, 24+k]
                for k in 1..6:
                    x_final[_, _, k +5] = x[i+1][_, _, k-1]

                let x_test = ctx_separator.variable x_final.unsqueeze(1)
                let y_pred = model_sep.forward(x_test).value.softmax.argmax(axis = 0).squeeze

                result += accuracy_score(1, y_pred)
        result = result / 10*(T+1)

proc run*(x: Tensor[float32]): int =
    let model = ctx.init(PhoNet)
    let x_run = ctx.variable x.unsqueeze(1)
    ctx.no_grad_mode:
        result = model.forward(x_run).value.softmax.argmax(axis = 1).squeeze.mean()

proc run_separator*(x: Tensor[float32]): Tensor[system.int] =
    let model_sep = ctx_separator.init(SeparatorNet)
    let x_run = ctx_separator.variable x.unsqueeze(1)
    ctx_separator.no_grad_mode:
        result = model_sep.forward(x_run).value.softmax.argmax(axis = 0).squeeze

template save*(path: string) =
    ctx.write_hdf5(path, "PhoNet")
    ctx_separator.write_hdf5(path, "SepNet")

template load*(path: string) =
    ctx.read_hdf5(path, "PhoNet")
    ctx_separator.read_hdf5(path, "SepNet")