; #Persistent ; Keep the script running

; Monitoring interval (milliseconds)
monitoringInterval := 2000 ; Check every 2 seconds

; Variable to hold the previous list of COM ports
Global previousComPortList := []

; Function to get the current list of COM ports
GetCOMPortList()
{
    local currentComPortList := []
    devices := ComObject("WbemScripting.SWbemLocator").ConnectServer().ExecQuery("SELECT Name FROM Win32_PnPEntity")
    for device in devices
    {
        if RegExMatch(device.Name, "\(COM\d+\)")
        {
            currentComPortList.Push(device.Name)
        }
    }
    return currentComPortList
}

; Function to compare the current and previous COM port lists and display notifications
CheckCOMPortChanges()
{
    Global previousComPortList
    currentComPortList := GetCOMPortList()

    ; If the previous list is empty (first run), save the current list and exit
    if !previousComPortList.Length
    {
        previousComPortList := currentComPortList
        return
    }

    ; Detect added and removed COM ports
    addedComPorts := []
    removedComPorts := []

    ; Check for added COM ports
    for port in currentComPortList
    {
        found := false
        for prevPort in previousComPortList
        {
            if (port = prevPort)
            {
                found := true
                break
            }
        }
        if !found
            addedComPorts.Push(port)
    }

    ; Check for removed COM ports
    for port in previousComPortList
    {
        found := false
        for currPort in currentComPortList
        {
            if (port = currPort)
            {
                found := true
                break
            }
        }
        if !found
            removedComPorts.Push(port)
    }

    ; Display notifications if there are changes
    if addedComPorts.Length > 0
    {
        message := "COM port connected:"
        for port in addedComPorts
        {
            message .= "`n" . port
        }
        MsgBox(message)
    }
    if removedComPorts.Length > 0
    {
        message := "COM port disconnected:"
        for port in removedComPorts
        {
            message .= "`n" . port
        }
        MsgBox(message)
    }

    ; Save the current list as the previous list for the next check
    previousComPortList := currentComPortList
}

; Set a timer to run the monitoring function periodically
SetTimer(CheckCOMPortChanges, monitoringInterval)