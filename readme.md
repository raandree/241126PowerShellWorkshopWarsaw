- [1. PowerShell Workshop in Warsaw on 26. November 2024](#1-powershell-workshop-in-warsaw-on-26-november-2024)
  - [1.1. Useful modules](#11-useful-modules)
  - [1.2. Content](#12-content)
    - [1.2.1. Git Introduction](#121-git-introduction)
      - [1.2.1.1. Markdown](#1211-markdown)
    - [1.2.2. Recap](#122-recap)
      - [1.2.2.1. Here String](#1221-here-string)
      - [1.2.2.2. Native commands return text](#1222-native-commands-return-text)
      - [1.2.2.3. Error handling](#1223-error-handling)
      - [1.2.2.4. The difference between singe and double-quoted strings and the format operator](#1224-the-difference-between-singe-and-double-quoted-strings-and-the-format-operator)
      - [1.2.2.5. Reading and Path environment variable](#1225-reading-and-path-environment-variable)
      - [1.2.2.6. Format-Table with dynamic / custom columns](#1226-format-table-with-dynamic--custom-columns)
      - [1.2.2.7. Out-GridView and the PassThru switch](#1227-out-gridview-and-the-passthru-switch)
      - [1.2.2.8. Where-Object Filtering](#1228-where-object-filtering)
      - [1.2.2.9. Group-Object samples](#1229-group-object-samples)
      - [1.2.2.10. RegEx](#12210-regex)
      - [1.2.2.11. Select-Object and very different return values](#12211-select-object-and-very-different-return-values)
      - [1.2.2.12. Automatic Member Enumeration](#12212-automatic-member-enumeration)
      - [1.2.2.13. When to use which kind of bracket?](#12213-when-to-use-which-kind-of-bracket)
      - [1.2.2.14. PowerShell Command History](#12214-powershell-command-history)
      - [1.2.2.15. Hashtables in PowerShell](#12215-hashtables-in-powershell)
        - [1.2.2.15.1. What are Hashtables?](#122151-what-are-hashtables)
        - [1.2.2.15.2. Why Use Hashtables?](#122152-why-use-hashtables)
        - [1.2.2.15.3. Where are Hashtables Used in PowerShell?](#122153-where-are-hashtables-used-in-powershell)
        - [1.2.2.15.4. Exporting Hashtables](#122154-exporting-hashtables)
      - [1.2.2.16. Parameter Sets in PowerShell](#12216-parameter-sets-in-powershell)
        - [1.2.2.16.1. Key Points:](#122161-key-points)
      - [1.2.2.17. Splatting in PowerShell](#12217-splatting-in-powershell)
      - [Enums (and a Bit of Splatting)](#enums-and-a-bit-of-splatting)
    - [New-InternalCar](#new-internalcar)
      - [NTFSSecurity for managing file permissions](#ntfssecurity-for-managing-file-permissions)
      - [Debugging in Visual Studio Code](#debugging-in-visual-studio-code)


# 1. PowerShell Workshop in Warsaw on 26. November 2024

## 1.1. Useful modules

- [psconf.eu](https://psconf.eu/) - is the premier European PowerShell conference where you can learn from and network with top PowerShell experts and enthusiasts, enhancing your skills and knowledge in a collaborative environment.
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) - PSScriptAnalyzer is a static code checker for PowerShell modules and scripts.
- [NTFSSecurity](https://github.com/raandree/NTFSSecurity) - Easy permission management on the file system.
- [AutomatedLab](https://automatedlab.org/en/latest/) - AutomatedLab is a powerful and easy-to-use automation framework that simplifies the creation and management of complex lab environments for testing and development.

## 1.2. Content

### 1.2.1. Git Introduction

Git is usually used with a remote source which is hosted on GitHub, Azure DevOps or other products that support Git. But, it can be also used locally.

Initialize a folder to become a git repository is as easy as that:

```text
git init
```

To commit a change in the git repository, either use the source control activity bar or the command line:

```text
git add .
git commit -m "Updated readme"
```

> Note: The only requirement for that is to have [git](https://git-scm.com/downloads) installed locally.

To create a new branch, merge the new branch to master and delete it afterwards it is comfortable to use the UI. The commands the UI sends to the git.exe are these ones:

```text
git checkout -b fix/bug2
```

Then do some change in the new branch and the continue the sequence:

```text
git add .
git commit -m "Fixed bug 2"

git checkout master

git merge fix/bug2
git branch -d fix/bug2
```

To upload / publish the code to GitHub, add a remote repository link like that:

```powershell
git remote add origin https://github.com/raandree/241126PowerShellWorkshopWarsaw.git
git push -u origin master
```

#### 1.2.1.1. Markdown

Refer to the [getting started guide](https://www.markdownguide.org/getting-started/).

### 1.2.2. Recap

#### 1.2.2.1. Here String

In PowerShell, you can use here-strings to declare blocks of text. They’re declared just like regular strings except they have an @ on each end. Instead of being limited to one line, you can declare an entire block or a multiple line string.

```powershell
$text = @"

Hello World $a @"

The name is "Peter"

hello "@
"@
```

#### 1.2.2.2. Native commands return text

As native commands return only text, we have to use regular expressions to extract the data that we are interested in like this:

```powershell
$text = @'
Pinging microsoft.com [2603:1030:b:3::152] with 32 bytes of data:
Reply from 2603:1030:b:3::152: time=145ms
Reply from 2603:1030:b:3::152: time=142ms
Reply from 2603:1030:b:3::152: time=144ms
Reply from 2603:1030:b:3::152: time=149ms

Ping statistics for 2603:1030:b:3::152:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 142ms, Maximum = 149ms, Average = 145ms
'@

$pattern = 'Reply from [0-9a-f:]+ time=(?<Time>\d{1,4})ms'
$text | Select-String -Pattern $pattern -AllMatches | ForEach-Object {
    $_.Matches.Groups['Time'].Value
}
```

Instead of using a cmdlet rather than the native command, you get an object back and accessing the response time is much easier:

```powershell
$a = Test-Connection -ComputerName microsoft.com
$a.ResponseTime | Measure-Object -Sum -Average -Minimum -Maximum

<#
The output should be like:

Count    : 4
Average  : 144,25
Sum      : 577
Maximum  : 146
Minimum  : 143
Property :
#>
```

#### 1.2.2.3. Error handling

When `ErrorAction SilentlyContinue` is used, you need to make sure the return value of the cmdlet was as expected (`$folder -ne $null`):

```powershell
$folder = Get-Item -Path C:\Window -ErrorAction SilentlyContinue

if ($folder -ne $null) {
    $files = Get-ChildItem -Path $folder
    Write-Host "File count: $($files.Count)"
} else {
    Write-Host "Folder not found or inaccessible."
}
```

You want to use `ErrorAction` stop when having a try-catch construct:

```powershell
try
{
    $folder = Get-Item -Path C:\Window -ErrorAction Stop
    $files = Get-ChildItem -Path $folder
    Write-Host "File count: $($files.Count)"
}
catch
{
    Write-Host "Folder not found or inaccessible."
}
```

#### 1.2.2.4. The difference between singe and double-quoted strings and the format operator

```powershell
$a = 5

"The value of `$a is $a"
'The value of `$a is $a'

$p = Get-Process
$totalWorkingSet = ($p.WS | Measure-Object -Sum).Sum / 1GB
"There are " + $p.Count + " processes running"
"There are $($p.Count) processes running"
'There are {0} processes running' -f $p.Count

'There are {0} processes running which consume {1:N2} GB of memory' -f $p.Count, $totalWorkingSet

#Create a list of 1000 strings with the format "Test 0001", "Test 0002", etc.
1..1000 | ForEach-Object { "Test {0:d4}" -f $_ }
```

#### 1.2.2.5. Reading and Path environment variable

The `PATH` and `PSModulePath` environment variables are used to specify directories for executable files and PowerShell modules, respectively.

```powershell
$env:PSModulePath -split ';'
$env:Path -split ';'
```

#### 1.2.2.6. Format-Table with dynamic / custom columns

This PowerShell script customizes the output of the dir (alias for Get-ChildItem) command to display file sizes in gigabytes.

```powershell
$sizeColumn = @{ 
    Name       = 'Size' 
    Expression = { [Math]::Round($_.Length / 1GB, 2) }
    Width      = 8 
}
dir | Format-Table -Property Length, $sizeColumn, Name
```

#### 1.2.2.7. Out-GridView and the PassThru switch

This PowerShell command sequence allows the user to select one or more running processes from an interactive grid view window and then stops the selected processes.

```powershell
Get-Process | Out-GridView -PassThru
Get-Process | Out-GridView -PassThru | Stop-Process
```

`Out-GridView` does not work remotely. However, you can get the data remotely and show it locally.

```powershell
$sb = {
    Get-Process
}

$result = Invoke-Command -ScriptBlock $sb -ComputerName dsccasql01

$result | Out-GridView -PassThru
```

This PowerShell script retrieves the first two running processes from multiple remote computers and displays the selected processes in an interactive grid view window.

Yes, `Invoke-Command` can execute the script block on multiple remote computers in parallel, which can improve performance when querying multiple machines. By default, `Invoke-Command` runs commands in parallel on up to 32 remote computers. You can adjust this limit using the `-ThrottleLimit` parameter if needed.

```powershell
$sb = {
    Get-Process | Select-Object -First 2
}

$computers = Get-ADComputer -Filter *

$result = Invoke-Command -ScriptBlock $sb -ComputerName $computers.DnsHostName

$result | Select-Object -Property Name, WS, Handles, PSComputerName | Out-GridView -PassThru
```

This is an extended version of the script with error handling to report on machines that are offline:

```powershell
$sb = {
    Get-Process | Select-Object -First 2
}

$computers = Get-ADComputer -Filter *
$offlineComputers = @()
$allResults = @()

foreach ($computer in $computers) {
    try {
        $result = Invoke-Command -ScriptBlock $sb -ComputerName $computer.DnsHostName -ErrorAction Stop
        $allResults += $result
    } catch {
        Write-Host "Failed to connect to $($computer.DnsHostName)"
        $offlineComputers += $computer.DnsHostName
    }
}

if ($allResults.Count -gt 0) {
    $allResults | Select-Object -Property Name, WS, Handles, PSComputerName | Out-GridView -PassThru
}

if ($offlineComputers.Count -gt 0) {
    Write-Host "The following computers were offline or unreachable:"
    $offlineComputers | ForEach-Object { Write-Host $_ }
}
```

#### 1.2.2.8. Where-Object Filtering

Filtering with a scriptblock like it works since PowerShell 1.0

```powershell
Get-Process | Where-Object -FilterScript { $_.WS -gt 500MB }
Get-Process | Where-Object { $_.WS -gt 500MB }
```

Since PowerShell 3.0, you can use the -Property parameter to specify the property to filter on.
It is simpler and more readable than the scriptblock syntax but you cannot combine multiple conditions in a single command.

```powershell
Get-Process | Where-Object -Property WS -GT -Value 500MB
Get-Process | Where-Object WS -GT 500MB
```

If you have multiple conditions, you must use the scriptblock syntax.

```powershell
Get-Process | Where-Object { $_.WS -gt 50MB -and $_.Name -like 'a*' }
```

#### 1.2.2.9. Group-Object samples

This PowerShell command sequence lists the top 10 most common file extensions in the current directory and its subdirectories.

```powershell
dir -Recurse | Group-Object -Property Extension | Sort-Object -Property Count -Descending | Select-Object -First 10
```

---

This PowerShell command sequence groups the data from a CSV file by the Department property, which is actually the party the senators belong to.

```powershell
$p = Import-Csv .\assets\People.csv
$p | Group-Object -Property Department
```

---

This PowerShell command sequence groups files by their creation date and sorts the groups in descending order by date.

```powershell
$data = dir -Recurse | Group-Object -Property { $_.CreationTime.ToString('yy MM dd') } | Sort-Object -Property Name -Descending
```

`dir -Recurse`: Recursively lists all files in the current directory and its subdirectories.
`Group-Object -Property { $_.CreationTime.ToString('yy MM dd') }`: Groups the files by their creation date. The `ToString('yy MM dd')` method formats the creation date as a string in the format yy MM dd (two-digit year, two-digit month, two-digit day).
`Sort-Object -Property Name -Descending`: Sorts the groups by the group name (which is the formatted creation date) in descending order.

The result is a collection of file groups, each group containing files created on the same date, sorted from the most recent to the oldest.

###$ Use the PipelineVariable Common parameter

This PowerShell command sequence retrieves the threads of each running process and selects specific properties for output, using the -PipelineVariable parameter to retain the process information.

Get-Process -PipelineVariable p | ForEach-Object { $_.Threads } | Select-Object ID, StartTime, @{ Name = 'PID'; Expression = { $p.ID } }

> Note: In PowerShell, the `-PipelineVariable` parameter is used without the `$` sign. The `$` sign is used to reference variables, but when defining a pipeline variable, you only specify the variable name without the `$`.
> So, `-PipelineVariable p` defines a pipeline variable named `p`, which can then be referenced as `$p` later in the pipeline.

#### 1.2.2.10. RegEx
Regular expressions (Regex) are used for pattern matching and text manipulation. Here are some reasons to use Regex:

- Pattern Matching: Identify and extract specific patterns in text, such as phone numbers, email addresses, or dates.
- Validation: Check if a string conforms to a specific format, such as validating email addresses or passwords.
- Search and Replace: Find and replace text based on patterns, useful for text processing and data cleaning.
- Flexibility: Handle complex text processing tasks with concise and powerful expressions.
- Efficiency: Perform text operations quickly and efficiently, especially with large datasets.

Regex is a versatile tool for handling various text processing tasks in programming and scripting.

> Note: "Some people, when confronted with a problem, think "I know, I'll use regular expressions." Now they have two problems." [Regular Expressions: Now You Have Two Problems](https://blog.codinghorror.com/regular-expressions-now-you-have-two-problems/)

Useful resources:
- [regular expressions 101](https://regex101.com/)
- [Regex Tutorial - A Cheatsheet with Examples!](https://regextutorial.org/)

#### 1.2.2.11. Select-Object and very different return values

The difference between these two lines lies in how they handle the `ID` property of the process objects:

`Get-Process | Select-Object -Property ID`:

- This command selects the `ID` property and returns objects with the ID property.
- The output will be a list of objects, each with an `ID` property.

`Get-Process | Select-Object -ExpandProperty ID`:

- This command expands the `ID` property and returns the values directly.
- The output will be a list of process ID values (integers) without any additional object structure.

#### 1.2.2.12. Automatic Member Enumeration

```powershell
# Define an array of objects with a 'Name' property
$people = @(
    [PSCustomObject]@{ Name = 'Alice'; Age = 30 },
    [PSCustomObject]@{ Name = 'Bob'; Age = 25 },
    [PSCustomObject]@{ Name = 'Charlie'; Age = 35 }
)

# Use Automatic Member Enumeration to directly access the 'Name' property of each object
$names = $people.Name

# Output the names
Write-Host "Names of people: $names"
```

Automatic Member Enumeration in PowerShell works by automatically enumerating (iterating over) collections when accessing a property of each item in the collection. This feature simplifies the syntax for accessing properties of objects within a collection.

**How it works internally**:

- Collection Detection:
  When you access a property on a collection of objects, PowerShell detects that the target is a collection.
- Property Access:
  PowerShell then attempts to access the specified property on each item within the collection.
- Enumeration:
  It enumerates through each item in the collection and retrieves the value of the specified property for each item.
- Result Aggregation:
  The results are aggregated into a new collection, which is returned as the output.

Here is an example:

```powershell
$p = Get-Process | Select-Object -First 5
$p | ForEach-Object { $_.Threads | ForEach-Object { $_.StartTime } }
$p.Threads.StartTime
```

#### 1.2.2.13. When to use which kind of bracket?

- Normal brackets ()
  
  - To prioritize sections of a line like in math to prioritize additions before multiplications.

    ```powershell
    #This results in an error
    Get-Process.Count

    (Get-Process).Count
    ```

  - To call a method

    ```powershell
    $d = Get-Date
    $d.AddDays(1)
    ```

  - If you want to create an empty array or   convert a single object into an array ob objects

      ```powershell
      $array = @()
      $array = @(1)
      ```

- Curly brackets

  - To indicate scripts blocks. Used in If, ForEach, functions, etc.

      ```powershell
      if ($a -gt 5){
        'yes'
      }
      else {
        'no'
      }
      ```

  - To define hashtables

    ```powershell
    $ht1 = @{}

    $ht2 = @{
      key1  = 'value1'
      Model = 'Golf'
    }
    ```

- Square brackets

  - Square brackets are used to access elements in an array:

    ```powershell
    $a = 1,2,3
    $a[0]
    $a[-1]
    ```

  - Square brackets are used to declare types or cast data

    ```powershell
    [int]$i = 0
    $a = [int]'123'

    $al = [System.Collections.ArrayList]::new()
    [System.Math]::Round(1.323434, 2)
    ```

#### 1.2.2.14. PowerShell Command History

PowerShell / the PSReadline module stores the history in the file `(Get-PSReadLineOption).HistorySavePath`.

You can search the history with `CTRL + R` and `CTRL + F`.

#### 1.2.2.15. Hashtables in PowerShell

##### 1.2.2.15.1. What are Hashtables?

Hashtables, also known as dictionaries or associative arrays, are a collection of key-value pairs. Each key is unique and is used to access the corresponding value. In PowerShell, hashtables are created using the `@{}` syntax.

**Example**:
```powershell
$hashtable = @{
    "Name" = "John Doe"
    "Age" = 30
    "Occupation" = "Developer"
}
```

##### 1.2.2.15.2. Why Use Hashtables?

Hashtables are used for their efficiency in storing and retrieving data. They provide a fast way to look up values based on their keys. This makes them ideal for scenarios where you need to manage and access a collection of related data quickly.

##### 1.2.2.15.3. Where are Hashtables Used in PowerShell?

1. **Configuration Management**: Storing configuration settings and parameters.
2. **Data Manipulation**: Organizing and processing data retrieved from various sources.
3. **Scripting**: Passing complex data structures between functions and scripts.
4. **Automation**: Managing and automating administrative tasks by storing and retrieving state information.

**Example Usage in PowerShell**:
```powershell
# Creating a hashtable
$person = @{
    "FirstName" = "Jane"
    "LastName" = "Doe"
    "Email" = "jane.doe@example.com"
}

# Accessing values
$firstName = $person["FirstName"]
$email = $person["Email"]

# Adding a new key-value pair
$person["Phone"] = "123-456-7890"

# Iterating over a hashtable
foreach ($key in $person.Keys) {
    Write-Output "$key: $($person[$key])"
}
```

Hashtables are a powerful and flexible tool in the PowerShell ecosystem, enabling efficient data management and manipulation.

##### 1.2.2.15.4. Exporting Hashtables

```powershell
# Convert the hashtable to YAML
$yaml = $employees | ConvertTo-Yaml

# Store the YAML in a file
$yaml | Out-File -FilePath 'employees.yaml'

# Import the YAML from the file
$importedEmployees = Get-Content -Path 'employees.yaml' | ConvertFrom-Yaml

# Display the imported employees
$importedEmployees
```

> Note: More hashtable examples
> - [HashtableExample.ps1](./assets/HashtableExample.ps1)
> - [ArrayOfHashtablesExample.ps1](./assets/ArrayOfHashtablesExample.ps1)

#### 1.2.2.16. Parameter Sets in PowerShell

Parameter sets in PowerShell allow you to define different sets of parameters for a single cmdlet or function. This enables you to create versatile commands that can handle various scenarios by grouping parameters into distinct sets. Each parameter set can have its own unique combination of mandatory and optional parameters, providing flexibility and clarity in how the cmdlet or function is used.

##### 1.2.2.16.1. Key Points:
- **Purpose**: To provide different ways to call a cmdlet or function, depending on the parameters provided.
- **Mutually Exclusive**: Parameters in different parameter sets are mutually exclusive; you can only use parameters from one set at a time.
- **Default Parameter Set**: You can specify a default parameter set that PowerShell will use if it cannot determine which set to use based on the provided parameters.
- **ParameterSetName Attribute**: Used to assign parameters to specific parameter sets.

An example for connecting to a server by either the name or IP address:

```powershell
function Connect-ExchangeServer {
    param (
        [Parameter(Mandatory=$true, ParameterSetName = 'ByComputerName')]
        [string]$ComputerName,

        [Parameter(Mandatory=$true, ParameterSetName = 'ByIpAddress')]
        [string]$IpAddress
    )

    if ($PSCmdlet.ParameterSetName -eq 'ByIpAddress')
    {
        $ComputerName = [System.Net.Dns]::GetHostAddresses($IpAddress)
    }

    Write-Host "Connecting to Exchange Server '$ComputerName'"
}

Connect-ExchangeServer -ComputerName "EX01"
Connect-ExchangeServer -IpAddress 192.168.10.10

#The next line does not work
Connect-ExchangeServer -ComputerName ex1 -IpAddress 192.168.10.10
```

#### 1.2.2.17. Splatting in PowerShell

Splatting in PowerShell is a method of passing a collection of parameter values to a command. It allows you to bundle parameters into a single variable, making your scripts cleaner and easier to read. Splatting can be done using either a hash table or an array.

**Why Splatting is Cool**?

1. **Readability**: It makes your code more readable by reducing the clutter of long parameter lists.
2. **Maintainability**: Easier to maintain and update parameters in one place.
3. **Reusability**: You can reuse the same set of parameters for multiple commands.

**Example**

Here's an example of using splatting with a hash table:

```powershell
# Define a hash table with parameters
$parameters = @{
    Name = "example.txt"
    Path = "C:\Temp"
    ItemType = "File"
}

# Use splatting to pass the parameters to New-Item
New-Item @parameters
```

In this example, the `New-Item` cmdlet creates a new file named `example.txt` in the `C:\Temp` directory. The parameters are defined in a hash table and passed to the cmdlet using the `@` symbol.

#### Enums (and a Bit of Splatting)

The following PowerShell script demonstrates the use of enums, splatting, and the `$PSBoundParameters` automatic variable.

Two enums are defined: `CarMake` and `CarColor`. These enums represent the make and color of a car, respectively.

```powershell
enum CarMake {
    Toyota
    Honda
    Ford
    Chevrolet
}

enum CarColor {
    Red
    Blue
    Green
    Black
    White
}
```

The `New-Car` function takes four parameters: `Make`, `Model`, `Year`, and `Color`. It uses the `$PSBoundParameters` automatic variable to capture all the parameters passed to the function. The `Year` parameter is removed from `$PSBoundParameters`, and the remaining parameters are passed to the `New-InternalCar` function using splatting (`@PSBoundParameters`).

```powershell
function New-Car {
    param(
        [CarMake]$Make,
        [string]$Model,
        [int]$Year,
        [CarColor]$Color
    )

    $PSBoundParameters.Remove('Year')
    New-InternalCar @PSBoundParameters
}
```

### New-InternalCar

The `New-InternalCar` function takes three parameters: `Make`, `Model`, and `Color`. It simply returns the `$PSBoundParameters` automatic variable, which contains the parameters passed to the function.

```powershell
function New-InternalCar {
    param(
        [CarMake]$Make,
        [string]$Model,
        [string]$Color
    )

    $PSBoundParameters
}
```

```powershell
New-Car -Model 'Corolla' -Year 2018 -Color 'Red' -Make 'Toyota'
```

In this example, the `Year` parameter is removed before calling `New-InternalCar`, so the final call to `New-InternalCar` will only include `Make`, `Model`, and `Color`.

#### NTFSSecurity for managing file permissions

used /explain (rerun without)
The NTFSSecurity PowerShell module is used to manage NTFS permissions on files and directories. It provides cmdlets to view, modify, and manage access control lists (ACLs) and inheritance settings for NTFS file system objects.

```powershell
dir -Directory | Get-NTFSInheritance | Where-Object { -not $_.AccessInheritanceEnabled } | Enable-NTFSAccessInheritance -RemoveExplicitAccessRules 

Add-NTFSAccess .\DscBuildHelpers\ -Account test1 -AccessRights FullControl -AccessType Allow -AppliesTo ThisFolderAndSubfolders 

dir -Recurse -Directory | Get-NTFSAccess
```

#### Debugging in Visual Studio Code

A `launch.json` file in Visual Studio Code is used to configure the debugger. It defines how to start and attach to your application, set breakpoints, and specify environment variables. This file is essential for customizing the debugging experience for different programming languages and environments.

For this project we created a the [launch.json](./.vscode/launch.json) that calls the script `\assets\Gui Example 1.ps1` with an argument.


Greg's code
debugging

