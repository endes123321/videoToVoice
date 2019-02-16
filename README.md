# videoToVoice
These files take in a sequence of lip images, and predict the phonemes being said.

Reimplemented in nim with some improvements.

## Requeriments for executing

- Ffmpeg
- Python 3.3+ or Python 2.7
- [face_recognition](https://github.com/ageitgey/face_recognition)
- [textgrid-parser](https://github.com/hschen0712/textgrid-parser) on the executable path
- [Montreal Forced Aligner](https://montreal-forced-aligner.readthedocs.io/en/latest/index.html) executable as a cmd command
- A CBLAS and Lapack library on your system. [Recomendation](https://github.com/mratsim/Arraymancer#installation)

## Requeriments for compiling
videoToVoice.nim includes all requerients and their version. By the way, install Arraymancer_vision with [my patch](https://github.com/endes123321/arraymancer-vision).


## TODOs

- Test and train the CNNs
- Depend less in external software
    - Change face_recognition for Dlib
    - Port textgrid-parser to nim
- Optimize, lips identify crops is very slow (4 seconds for image)
- Use a Markov chain or a RNN for better results
- Instead of Convulutioning, pass directly the lips points from face_recognition to a simple neural network