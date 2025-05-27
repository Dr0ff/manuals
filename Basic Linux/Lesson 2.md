# Lesson 2: Commands. Understanding Command Syntax with Examples of Basic Commands.
*Material written by the author of the channel "Penguins fly to California"*
---
## 📚 | Table of Contents
* Understanding Command Syntax
* Flags
---
## ⌨️ | Understanding Command Syntax
<a name="understanding-command-syntax"></a>

In the last lesson, you were introduced to the `cd` and `mkdir` commands. Now, let's examine them in more detail.
Any command in the terminal can be represented in a general form:

`<Program> [Options/Flags] [Argument_1] [Argument_2]`

A command consists of the following elements:

* **Program**
* **Options/Flags**
* **Arguments** (there can be several)

Of these three elements, only one is **mandatory**: the **Program**.
The commands we are familiar with, like `cd`, `mkdir`, and others, are programs that we run, and they perform their tasks.

Let's look at a specific example:
```bash
cd work

cd - is the program
work - is the argument
```
In this case, the command has two elements: the program and an argument. Here, the argument is the path to the directory you want to navigate to (it can be absolute or relative).<br>

Let's get acquainted with some other commands:
```shel
ls - (from "list") displays a list of files and folders, by default those in the current directory.
pwd - (Print Working Directory) shows the current working directory.
rm - (from "remove") deletes files.
cp - (from "copy") copies files and directories.
mv - (from "move") moves files and directories (also used to rename files).
man - (from "manual") displays the instruction manual for a specified program.
```

With options/flags, we can change the behavior of commands.
For example:
```bash
mkdir -p ~/qwe/asd/zxc
```
Here, we added the -p flag.
Thanks to this flag, the program will not produce errors if a parent directory doesn't exist; instead, it will create it. If it already exists, it will simply "move on" and create the next subdirectory.

Important Note: Flags are not universal! Yes, some are common and perform similar functions across different commands, but this does not mean that these specific flags are present in every program.

