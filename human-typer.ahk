#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook true          ; implement hotkeys via the keyboard hook so they fire reliably during Send
SendMode "Event"       ; Event mode does NOT deactivate the hook while typing, unlike SendInput,
                       ; so Ctrl+F9 always registers (SendInput briefly blinds the hook per keystroke)
;
; Human Typer — types your own text into a focused field like a human would,
; so it goes in without triggering copy/paste detection.
;
; Usage:
;   1. Run this script (or the compiled .exe).
;   2. Paste your text into the box, set Speed (WPM) and the start delay.
;   3. Click "Start" (or press F9), then click into the target field during
;      the countdown.
;   4. Press Ctrl+F9 at any time to abort.

global Abort := false, Typing := false

g := Gui("+AlwaysOnTop", "Human Typer")
g.SetFont("s10", "Segoe UI")
g.Add("Text", , "Paste your text:")
g.Add("Edit", "w560 r15 vBody")
g.Add("Text", "xm", "Speed (WPM):")
g.Add("Edit", "x+8 w60 vWPM", "60")
g.Add("Text", "x+16", "Start delay (s):")
g.Add("Edit", "x+8 w50 vDelay", "5")
g.Add("Checkbox", "x+16 vShiftEnter Checked", "Shift+Enter for line breaks (chat apps)")
g.Add("Button", "xm w130", "Start  (F9)").OnEvent("Click", (*) => Start())
g.Add("Button", "x+8 w130", "Stop  (Ctrl+F9)").OnEvent("Click", (*) => Stop())
g.Add("Text", "xm w560 vStatus", "Ready.  Abort = Ctrl+F9")
g.OnEvent("Close", (*) => ExitApp())
g.Show()

F9::Start()
^F9::Stop()

Stop() {
    global Abort
    Abort := true
}

Start() {
    global Abort, Typing
    if Typing
        return
    d := g.Submit(false)
    if (Trim(d.Body) = "") {
        g["Status"].Text := "Nothing to type."
        return
    }
    wpm := Integer(d.WPM)
    if (wpm < 1)
        wpm := 60
    Typing := true, Abort := false
    g["Body"].Opt("+ReadOnly")   ; protect the source text while typing
    secs := Integer(d.Delay)
    Loop secs {
        if Abort
            break
        g["Status"].Text := "Focus the target field... " (secs - A_Index + 1) "s"
        Sleep 1000
    }
    if !Abort
        TypeHuman(StrReplace(d.Body, "`r`n", "`n"), wpm, d.ShiftEnter)
    g["Body"].Opt("-ReadOnly")
    g["Status"].Text := Abort ? "Aborted." : "Done."
    Typing := false
}

TypeHuman(text, wpm, shiftEnter) {
    global Abort
    base := 12000 / wpm           ; ms per char (~5 chars/word)
    chars := StrSplit(text)
    for i, ch in chars {
        if Abort
            break
        ; Pause while our own window is focused, so keystrokes never land in the GUI.
        while (WinActive("ahk_id " g.Hwnd) && !Abort) {
            g["Status"].Text := "Paused — Human Typer is focused. Click the target field to resume."
            Sleep 200
        }
        if Abort
            break
        if (ch = "`n")
            Send(shiftEnter ? "+{Enter}" : "{Enter}")
        else
            SendText(ch)

        delay := base * (0.5 + Random(0.0, 1.0))     ; jitter 0.5x - 1.5x
        if InStr(".!?", ch)
            delay += Random(300, 800)                 ; end of sentence
        else if (ch = ",")
            delay += Random(120, 300)                 ; clause break
        else if (ch = "`n")
            delay += Random(200, 600)                 ; new line
        if (Random(0, 100) < 1.5)
            delay += Random(700, 2500)                ; occasional "thinking"

        Sleep Round(delay)
        if (Mod(i, 10) = 0)
            g["Status"].Text := "Typing " i "/" chars.Length "  (Ctrl+F9 to stop)"
    }
}
