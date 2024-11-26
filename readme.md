- [1. PowerShell Workshop in Warsaw on 26. November 2024](#1-powershell-workshop-in-warsaw-on-26-november-2024)
  - [Useful modules](#useful-modules)
  - [1.1. Content](#11-content)
    - [1.1.1. Git Introduction](#111-git-introduction)
      - [1.1.1.1. Markdown](#1111-markdown)
    - [1.1.2. Recap](#112-recap)
      - [1.1.2.1. Here String](#1121-here-string)
      - [Native commands return text](#native-commands-return-text)
      - [Error handling](#error-handling)
      - [The difference between singe and double-quoted strings and the format operator](#the-difference-between-singe-and-double-quoted-strings-and-the-format-operator)
      - [Reading and Path environment variable](#reading-and-path-environment-variable)


# 1. PowerShell Workshop in Warsaw on 26. November 2024

## Useful modules

- PSScriptAnalyzer
- NTFSSecurity
- AutomatedLab
- 

## 1.1. Content

### 1.1.1. Git Introduction

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

#### 1.1.1.1. Markdown

Refer to the [getting started guide](https://www.markdownguide.org/getting-started/).

### 1.1.2. Recap

#### 1.1.2.1. Here String

In PowerShell, you can use here-strings to declare blocks of text. They’re declared just like regular strings except they have an @ on each end. Instead of being limited to one line, you can declare an entire block or a multiple line string.

```powershell
$text = @"

Hello World $a @"

The name is "Peter"

hello "@
"@
```

#### Native commands return text

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

#### Error handling

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

#### The difference between singe and double-quoted strings and the format operator

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

#### Reading and Path environment variable

The `PATH` and `PSModulePath` environment variables are used to specify directories for executable files and PowerShell modules, respectively.

```powershell
$env:PSModulePath -split ';'
$env:Path -split ';'
```