#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;Esc::CapsLock
;CapsLock::Esc

;lalt::lctrl
;lctrl::lalt

<#q::<!F4
<#l::Return
<#o::<#Right
<#w::<#Up
<#h::<#Left
<#u::<#Down
<#y::<#L


; copy file path
^+c::
; null= 
send ^c
sleep,200
clipboard=%clipboard% ;%null%
tooltip,%clipboard%
sleep,500
tooltip,
return