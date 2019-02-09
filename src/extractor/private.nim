import osproc

type
    CmdError* = object of Exception

template exec*(cmd: string) =
    let (output, exitCode) = execCmdEx cmd

    if exitCode != 0:
        raise newException(CmdError, output)