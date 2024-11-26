# PowerShell Workshop in Warsaw on 26. November 2024

## Content

### Git Introduction

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

#### Markdown

Refer to the [getting started guide](https://www.markdownguide.org/getting-started/).
