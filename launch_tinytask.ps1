$TinyTaskPath = "C:\Users\Yannick\Desktop\roblox.studio\tinytask.exe"
$MacroPath = "C:\Users\Yannick\Downloads\tinytask.rec"

# Lance TinyTask avec la macro en argument
Start-Process -FilePath $TinyTaskPath -ArgumentList "`"$MacroPath`""

Start-Sleep -Seconds 2

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class User32 {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    public const int SW_RESTORE = 9;
}
"@

function Wait-ForWindow($title, $timeoutSeconds=10) {
    $stopwatch = [Diagnostics.Stopwatch]::StartNew()
    while ($stopwatch.Elapsed.TotalSeconds -lt $timeoutSeconds) {
        $hwnd = (Get-Process | Where-Object { $_.MainWindowTitle -like "*$title*" }).MainWindowHandle | Where-Object { $_ -ne 0 } | Select-Object -First 1
        if ($hwnd) { return $hwnd }
        Start-Sleep -Milliseconds 300
    }
    return $null
}

$hwnd = Wait-ForWindow "TinyTask"

if ($hwnd) {
    [User32]::ShowWindow($hwnd, [User32]::SW_RESTORE) | Out-Null
    Start-Sleep -Milliseconds 300
    [User32]::SetForegroundWindow($hwnd) | Out-Null
    Start-Sleep -Milliseconds 300

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait("{F8}")
} else {
    Write-Output "Fenêtre TinyTask non trouvée."
}
