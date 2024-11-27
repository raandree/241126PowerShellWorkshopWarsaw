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
      - [Where-Object Filtering](#where-object-filtering)
      - [Group-Object samples](#group-object-samples)
      - [RegEx](#regex)
      - [Select-Object and very different return values](#select-object-and-very-different-return-values)
      - [Automatic Member Enumeration](#automatic-member-enumeration)


# 1. PowerShell Workshop in Warsaw on 26. November 2024

## 1.1. Useful modules

- PSScriptAnalyzer
- NTFSSecurity
- AutomatedLab
- 

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

#### Where-Object Filtering

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

#### Group-Object samples

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

#### RegEx
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

#### Select-Object and very different return values

The difference between these two lines lies in how they handle the `ID` property of the process objects:

`Get-Process | Select-Object -Property ID`:

- This command selects the `ID` property and returns objects with the ID property.
- The output will be a list of objects, each with an `ID` property.

`Get-Process | Select-Object -ExpandProperty ID`:

- This command expands the `ID` property and returns the values directly.
- The output will be a list of process ID values (integers) without any additional object structure.

#### Automatic Member Enumeration

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