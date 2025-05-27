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


---------------------


