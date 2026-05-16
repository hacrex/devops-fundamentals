# Phase 1: Linux Fundamentals Quiz

**Time Limit:** 30 minutes  
**Total Questions:** 20  
**Passing Score:** 80% (16 correct answers)

---

## Instructions
- Choose the BEST answer for each question
- Mark your answers on a separate sheet
- Review explanations after completing the quiz

---

## Questions

### 1. What does the `pwd` command do?
A) Print working directory  
B) Change directory  
C) List files  
D) Create directory  

<details><summary>✅ Answer</summary>A) Print working directory - Displays the current directory path</details>

### 2. Which permission setting gives the owner full access, group read and execute, and others read only?
A) 755  
B) 754  
C) 744  
D) 644  

<details><summary>✅ Answer</summary>B) 754 - Owner: rwx(7), Group: rx(5), Others: r(4)</details>

### 3. What is the purpose of the `/etc` directory?
A) User home directories  
B) Temporary files  
C) Configuration files  
D) System binaries  

<details><summary>✅ Answer</summary>C) Configuration files - Contains system and application configuration</details>

### 4. Which command would you use to view the last 10 lines of a file?
A) `head file.txt`  
B) `tail file.txt`  
C) `cat file.txt`  
D) `less file.txt`  

<details><summary>✅ Answer</summary>B) `tail file.txt` - Shows the end of a file (default 10 lines)</details>

### 5. How do you make a script executable?
A) `chmod +x script.sh`  
B) `chmod 777 script.sh`  
C) `execute script.sh`  
D) `run script.sh`  

<details><summary>✅ Answer</summary>A) `chmod +x script.sh` - Adds execute permission</details>

### 6. What does `grep "error" /var/log/app.log` do?
A) Deletes error lines from the log  
B) Counts errors in the log  
C) Searches for "error" in the log file  
D) Replaces "error" with blank  

<details><summary>✅ Answer</summary>C) Searches for "error" in the log file</details>

### 7. Which command shows all running processes?
A) `ps`  
B) `ps aux`  
C) `top`  
D) `list processes`  

<details><summary>✅ Answer</summary>B) `ps aux` - Shows detailed information about all processes</details>

### 8. What is the correct way to create a directory and its parent directories if they don't exist?
A) `mkdir -p /path/to/dir`  
B) `mkdir /path/to/dir`  
C) `create-dir /path/to/dir`  
D) `newdir /path/to/dir`  

<details><summary>✅ Answer</summary>A) `mkdir -p /path/to/dir` - The -p flag creates parent directories</details>

### 9. Which command displays disk space usage in human-readable format?
A) `du -h`  
B) `df -h`  
C) `disk -free`  
D) `space`  

<details><summary>✅ Answer</summary>B) `df -h` - Shows filesystem disk space usage</details>

### 10. What does `sudo` stand for?
A) Super User Do  
B) System User Do  
C) Substitute User Do  
D) Simple User Do  

<details><summary>✅ Answer</summary>C) Substitute User Do - Allows executing commands as another user</details>

### 11. How do you search for a pattern recursively in all files under a directory?
A) `grep "pattern" *`  
B) `grep -r "pattern" /path`  
C) `find "pattern"`  
D) `search "pattern"`  

<details><summary>✅ Answer</summary>B) `grep -r "pattern" /path` - Recursively searches directories</details>

### 12. Which command is used to change file ownership?
A) `chmod`  
B) `chown`  
C) `chgrp`  
D) `changeowner`  

<details><summary>✅ Answer</summary>B) `chown` - Changes file owner and group</details>

### 13. What does the `|` (pipe) operator do?
A) Redirects output to a file  
B) Combines two files  
C) Passes output of one command as input to another  
D) Creates a pipeline directory  

<details><summary>✅ Answer</summary>C) Passes output of one command as input to another</details>

### 14. Which file contains user password hashes?
A) `/etc/passwd`  
B) `/etc/shadow`  
C) `/etc/users`  
D) `/etc/passwords`  

<details><summary>✅ Answer</summary>B) `/etc/shadow` - Contains encrypted passwords</details>

### 15. What is the PID of the init process (systemd or init)?
A) 0  
B) 1  
C) 100  
D) It varies  

<details><summary>✅ Answer</summary>B) 1 - The first process started by the kernel</details>

### 16. Which command shows network interfaces and their IP addresses?
A) `ifconfig` or `ip addr`  
B) `netstat`  
C) `ping`  
D) `route`  

<details><summary>✅ Answer</summary>A) `ifconfig` or `ip addr` - Shows network interface configuration</details>

### 17. What does `rm -rf /tmp/test` do?
A) Removes the test directory and all contents  
B) Renames the test directory  
C) Reads the test directory  
D) Reports on the test directory  

<details><summary>✅ Answer</summary>A) Removes the test directory and all contents recursively and forcefully</details>

### 18. Which package manager is used in Ubuntu/Debian systems?
A) yum  
B) apt  
C) pacman  
D) zypper  

<details><summary>✅ Answer</summary>B) apt - Advanced Package Tool for Debian-based systems</details>

### 19. How do you check which user you are currently logged in as?
A) `user`  
B) `whoami`  
C) `id`  
D) Both B and C  

<details><summary>✅ Answer</summary>D) Both B and C - `whoami` shows username, `id` shows UID and groups</details>

### 20. What is the purpose of log rotation?
A) To delete old logs immediately  
B) To prevent logs from filling up disk space  
C) To encrypt logs  
D) To compress all logs permanently  

<details><summary>✅ Answer</summary>B) To prevent logs from filling up disk space - Rotates, compresses, and removes old logs</details>

---

## Score Calculation
- **20 correct:** 100% - Excellent!
- **18-19 correct:** 90-95% - Very Good
- **16-17 correct:** 80-85% - Passed ✓
- **Below 16:** Needs improvement - Review topics and retake

---

## Next Steps
- If you passed: Proceed to the [Linux Practical Challenge](../challenges/phase-01-linux-challenge.md)
- If you didn't pass: Review [Phase 1 Topics](../../phase-1-linux/) and retake this quiz
