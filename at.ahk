#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;replace CapsLock to LeftEnter; CapsLock = Alt CapsLock
$CapsLock::Control


LAlt & Capslock::SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"

F1::Send {LWin down}{ctrl down}{1}{1}{ctrl up}{LWin up}
F2::Send {LWin down}{ctrl down}{1}{1}{1}{ctrl up}{LWin up}

#IfwinActive ahk_class vwr::CDesktopWin
F8::Send {F8}{f}
F1::Send {F8}{n}{sleep 100}{F8}{n}
F2::Send {F8}{n}
Return


#IfWinActive ahk_class AcrobatSDIWindow
j::Send {WheelDown}
Return

#IfWinActive ahk_class AcrobatSDIWindow
k::Send {WheelUp}
Return

#IfWinActive ahk_class AcrobatSDIWindow
d::Send {WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}
Return

#IfWinActive ahk_class AcrobatSDIWindow
u::Send {WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}
Return

#IfWinActive ahk_class OpusApp
j::Send {WheelDown}
Return

#IfWinActive ahk_class OpusApp
k::Send {WheelUp}
Return


#ifWinActive ahk_class XLMAIN
	j::
	If GetKeyState( "ScrollLock", "T" )
		Send {Down}
	Else
		Send {j}
	Return

	k::
	If GetKeyState( "ScrollLock", "T" )
		Send {Up}
	Else
		Send {k}
	Return

	h::
	If GetKeyState( "ScrollLock", "T" )
		Send {Left}
	Else
		Send {h}
	Return

	l::
	If GetKeyState( "ScrollLock", "T" )
		Send {Right}
	Else
		Send {l}
	Return

	d::
	If GetKeyState( "ScrollLock", "T" )
		Send {PgDn}
	Else
		Send {d}
	Return

	u::
	If GetKeyState( "ScrollLock", "T" )
		Send {PgUp}
	Else
		Send {u}
	Return

Return
