﻿
PrepareNewVersion()
{
    global ctag, cid, version, branch

    if RegExMatch(ctag, "^v(.*\D)(\d+)$", ver)
        version := format("{}{:0" StrLen(ver2) "}", ver1, ver2 + 1)
    else
        version := SubStr(ctag, 2)
    
    if (branch = "alpha")
        version .= "-" cid

    PrepareVersion()
}

PrepareEdgeVersion()
{
    global cdesc, version

    version := RegExReplace(LTrim(cdesc, "v"), "-(\d+)-", "-$1+")

    PrepareVersion()
}

PrepareVersion()
{
    global

    InputBox version,, Enter new version number.,,, 120,,,,, %version%
    if ErrorLevel
        ExitApp

    ; 1.1.11.01 -> 1,1,11,1  --  2.0-a099 -> 2,0
    if RegExMatch(version, "^(\d+\.){0,3}\d+", version_n)
        version_n := RegExReplace(version_n, "\.(0(?=\d))?", ",")
    else
        version_n := 0

    ; Update ahkversion.h ...
    FileDelete, source\ahkversion.h
    FileAppend,
    (LTrim
    #define AHK_VERSION "%version%"
    #define AHK_VERSION_N %version_n%`n
    ), source\ahkversion.h

    OnExit(Func("PrepareVer_OnExit"))
}

PrepareVer_OnExit()
{
    ; Restore ahkversion.h if it has not been committed
    git("checkout source/ahkversion.h")
}