# Lesson 1: File System. Directories. Path (absolute and relative).

---
## 📚 | Table of Contents
* [File System](#file-system)
* [Navigating Directories](#navigating-directories)
* [Creating Directories](#creating-directories)
* [Homework](#homework)
---

## 📁 | File System
<a name="file-system"></a>

In Linux, everything consists of files. Devices and folders are also files; that is, a folder in Linux is a file that stores information about other files and folders located within it.
The Linux file system starts with the **root directory**, which is denoted by `/`.

Just so you know, "folder," "catalog," and "directory" all mean the same thing. I will use different terms to avoid too much repetition.
All other directories are attached to the root directory. To draw an analogy, the directory structure is like a tree.
<img src="https://img1.teletype.in/files/8c/c6/8cc648ba-1014-40a1-97f1-b532573d16c3.png" />
The root directory contains various subdirectories, each performing a specific function. Let's look at some of them:

* `/etc` — stores the main configuration files for software.
* `/home` — a directory for storing files and settings for system users, except for the administrator (root).
* `/root` — the home directory of the `root` user (administrator).
* `/tmp` — for temporary files. This directory is typically cleared on every reboot. You shouldn't store important files there.

There are other directories, but we won't cover them now.
We will primarily work in the `/home` or `/root` folder, depending on which user you are logged in as.

> **Warning:** I strongly advise against changing anything in directories you know nothing about. With `root` privileges, you can crash the system by simply deleting an "unnecessary" file or directory.

Directories can contain subdirectories. For example, `/home/username`. Directories can contain other subdirectories and files. Files, in turn, contain information.

A file's address (or path) can be **absolute** (i.e., it contains the full path from the root directory to the file, e.g., `/home/user/.bashrc`) or **relative** (it is interpreted from the current directory. For example, `.ssh/authorized_keys` means that the file `authorized_keys` is in the `.ssh` subdirectory of the current directory).

It's also worth noting that the `/` symbol not only denotes the root directory but also serves as a separator between directories in a path.
Consequently, if a path to a file or directory does not contain any `/` symbols (e.g., `myfile.txt`), it implies that it is located directly within the current directory.

Additionally, there are special symbols for working with relative paths:
* `./`   – refers to the current directory.
* `../`  – refers to the parent directory (the directory one level up). For example, `../data` means the `data` directory is located in the parent directory of your current location. (`../../` means two levels up).
* `~/`   – refers to the home directory of the current user. This is usually `/home/<username>` (where `<username>` is the current user's system name) or `/root` for the `root` user.

> **For experienced users and for beginners to note for the future:** Be careful with these notations (`./`, `../`, `~/`). They might not always behave as expected when used in scripts, depending on how the script is executed.

File names can include an extension (indicating the file type), for example, `file.txt`, `archive.tar.gz`, `image.png`, etc.

And now, some crucial points:

* Unlike Windows, file and directory names in Linux are **case-sensitive**. This means `FILENAME`, `Filename`, `filename`, and `FiLeNaMe` are all considered different names.
* Linux allows names with spaces and non-Latin characters (like Cyrillic), but their use is **highly discouraged**, especially spaces, as they can make command-line operations more cumbersome.
* File extensions are primarily for human convenience to understand the file's likely content. However, they **do not guarantee** that the file actually contains the indicated type of data. For example, you could create a file named `MyImportantDocument.jpeg` and write plain text into it. 😉
* File and directory names can contain various special characters, like `!#@`, but it is **recommended to use only Latin letters (a-z, A-Z), numbers (0-9), underscores (`_`), hyphens (`-`), and periods (`.`).**
* You will also see that some files and directories in the system start with a **dot** (e.g., `.bashrc`, `.config`). These are **"hidden"** files and directories. Standard listing commands often don't show them by default.

---
## 📂 | Navigating Directories
<a name="navigating-directories"></a>

To move between directories, you use the `cd` command (short for **C**hange **D**irectory).
In the next lesson, we will discuss command syntax in more detail, so you will learn more about command options then.

```bash
cd /home/<username>  # Navigate to the specified directory (using an absolute path).
cd work              # Navigate to the 'work' directory located in the current directory (using a relative path).
cd ..                # Navigate to the parent directory.
cd ../../work        # First, go up two levels from the current directory, then enter the 'work' directory there.
cd -                 # (Minus sign) Navigate to the previous directory you were in.
```
If you execute cd without any parameters, you will be taken to your home directory. This is very convenient.

How do you find out which directory you are currently in? (In case you get lost!)
There is a special command for this:
pwd (short for print working directory).

Example command:
`pwd`

You can also often see the current (working) directory as part of the command prompt, but we will cover the command prompt itself in a future lesson.
If you try to navigate to a directory that doesn't exist, you will receive an error message (which is logical).

---
## ✏️ | Creating Directories
<a name="#creating-directories"></a>
To create directories, you use the mkdir command (short for make directory). For example:

Example commands:
mkdir work # Creates a directory named 'work' in the current directory.
mkdir work/crypto # Creates a directory named 'crypto' inside the 'work' directory, assuming 'work' already exists in the current directory.

IMPORTANT! If the parent directory (e.g., work in the second example mkdir work/crypto) does not exist, the terminal will issue an error, and the subdirectory (crypto) will not be created. (There are options for mkdir to create parent directories automatically, which you might learn later).

In the commands above, we used relative paths. This means the specified directories are created RELATIVE to the current (working) directory.

You can also use an absolute path. In this case, the folder will be created at the specified location, provided that all preceding parent directories in the path exist.

Example command:
mkdir /root/projects # Creates the 'projects' directory ONLY in the /root directory, regardless of which directory you are currently in.

📝 | Homework

In your user's home directory (~), create a new folder. Choose a name yourself, preferably something short (e.g., my_stuff).
Navigate into the folder you just created. Inside it, create another folder with an arbitrary name (e.g., project_alpha).
Return to your home directory (cd ~ or just cd). From your home directory, create yet another new directory inside the one you created in task 2 (the sub-folder). For example, if you created ~/my_stuff/project_alpha, you would now create ~/my_stuff/project_alpha/notes while your current directory is ~. (Hope that's clear 😅)
Determine the absolute path to the directory you created in task 3 (e.g., the notes directory).
While you are in your home directory (~), determine at least two different relative paths to the directory you created in task 2 (e.g., project_alpha). List all you can find.

