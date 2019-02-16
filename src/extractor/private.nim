import osproc

type
    CmdError* = object of Exception

template exec*(cmd: string) =
    echo cmd
    let (output, exitCode) = execCmdEx cmd

    if exitCode != 0:
        raise newException(CmdError, output)