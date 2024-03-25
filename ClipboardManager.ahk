#Requires AutoHotkey v2+
class ClipboardManager {
    static ClipCount := 0
    static ClipHistory := []
    static Limit := false
    static Menu := Menu()
    static Init := this.BuildMenu()

    __New() {
        return
    }

    static BuildMenu() {
        this.Menu.Add("Add Clipboard to History", (*) => this.Add())
        this.Menu.Add("Clear History", (*) => this.ClearAll())
        this.Menu.Add("Clear Last Item", (*) => this.Clear())
        this.Menu.Add("Dump History", (*) => this.Dump())
        this.Menu.Add("Display History", (*) => MsgBox("Not coded yet"))
    }

    static Add(Value := A_Clipboard) {
        if ((this.Limit && this.ClipCount < this.Limit) || (this.Limit = false)) {
            this.ClipCount += 1
            this.ClipHistory.Push(Value)
        } 
        else if (this.Limit && this.ClipCount >= this.Limit) {
            for k, v in this.ClipHistory {
                if (k = 1) {
                    continue
                }
                else {
                    this.ClipHistory[k-1] := v
                }
            }
            this.ClipHistory[this.ClipCount] := Value
        }
    }

    static Dump() {
        if (this.ClipHistory.Length > 0) {
            for k, v in this.ClipHistory {
                Output .= (k ": " v "`n")
            }
        }
        else {
            Output .= "No values stored"
        }
        MsgBox(Trim(Output), "ClipboardManager.Dump()", "242144")
    }

    static SetLimit(Limit) {
        this.Limit := Limit
        if (this.ClipHistory.Length > Limit) {
            tempArray := []
            Loop(Limit) {
                tempArray.Push(this.ClipHistory.Pop())
            }
            this.ClipHistory := []
            Loop(Limit) {
                this.ClipHistory.Push(tempArray.Pop())
            }
        }
    }

    static Clear(Item := -1) {
        this.ClipHistory.RemoveAt(Item)
    }

    static ClearAll() {
        this.ClipCount := 0
        this.ClipHistory := []
    }

    static ShowMenu() {
        this.Menu.Show()
    }

    static Paste(Item := 1) {
        tempClipboard := ClipboardAll()
        A_Clipboard := ""
        A_Clipboard := this.ClipHistory[Item]
        ClipWait()
        Send("^v")
        Sleep(50)
        A_Clipboard := tempClipboard
    }
}