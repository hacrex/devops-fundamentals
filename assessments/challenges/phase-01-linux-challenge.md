# Phase 1: Linux Fundamentals - Practical Challenge

**Time Limit:** 60 minutes  
**Difficulty:** 🟢 Beginner  
**Total Points:** 100

---

## Scenario

You are a junior DevOps engineer at a startup. Your team lead has asked you to set up a basic Linux environment for a new web application deployment. You need to demonstrate your Linux skills by completing the following tasks.

---

## Task 1: Directory Structure Setup (15 points)

Create the following directory structure in your home directory:

```
~/webapp/
├── config/
├── logs/
├── scripts/
├── backups/
└── data/
```

**Requirements:**
- Create all directories in one command if possible
- Set appropriate permissions:
  - `config/`: 755 (owner can write, others can read/execute)
  - `logs/`: 775 (owner and group can write)
  - `backups/`: 700 (only owner can access)

**Deliverable:** Show the directory tree and permissions using `tree` or `ls -laR`

---

## Task 2: User and Permission Management (20 points)

1. Create a new user called `webappuser`
2. Add the user to a group called `webdevelopers` (create the group if it doesn't exist)
3. Change ownership of the `~/webapp` directory to `webappuser:webdevelopers`
4. Create a file called `secret.conf` in the `config/` directory with restricted permissions (600)

**Deliverable:** Show output of:
```bash
id webappuser
ls -la ~/webapp/
ls -la ~/webapp/config/
```

---

## Task 3: Log Analysis Script (25 points)

Create a bash script called `analyze_logs.sh` in the `scripts/` directory that:

1. Creates a sample log file with at least 20 lines containing:
   - INFO messages (10 lines)
   - WARN messages (5 lines)
   - ERROR messages (5 lines)

2. The script should then:
   - Count total number of lines
   - Count occurrences of ERROR, WARN, and INFO
   - Display the last 5 ERROR lines
   - Save the summary to a file called `log_summary.txt`

**Example log format:**
```
2024-01-15 10:00:01 INFO Application started successfully
2024-01-15 10:00:02 ERROR Database connection failed
2024-01-15 10:00:03 WARN Retrying connection attempt 1
```

**Deliverable:** 
- The script file (make it executable)
- Run the script and show the output
- Show contents of `log_summary.txt`

---

## Task 4: Process Management (15 points)

1. Start a background process: `sleep 300 &`
2. Find its PID using `ps` or `pgrep`
3. Change its priority using `renice` (increase nice value to 10)
4. Kill the process gracefully
5. Verify it's terminated

**Deliverable:** Show commands and output for each step

---

## Task 5: System Information Report (15 points)

Create a script called `system_report.sh` that generates a report containing:

1. Current date and time
2. Hostname
3. Kernel version
4. Total and available disk space
5. Memory usage (total, used, free)
6. Top 5 processes by CPU usage
7. List of users currently logged in

**Deliverable:** 
- The script file (make it executable)
- Run the script and save output to `system_info.txt`
- Show the contents of the report

---

## Task 6: File Operations and Text Processing (10 points)

Given a file `servers.txt` with the following content:
```
web-server-01,192.168.1.10,active
db-server-01,192.168.1.20,active
cache-server-01,192.168.1.30,inactive
app-server-01,192.168.1.40,active
backup-server-01,192.168.1.50,inactive
```

Perform the following:
1. Extract only active servers
2. Count how many active servers there are
3. Extract just the IP addresses of active servers
4. Sort the servers alphabetically

**Deliverable:** Show the commands used and their output

---

## Submission Requirements

Submit a single document or archive containing:

1. ✅ All scripts created (with execute permissions)
2. ✅ Screenshots or terminal output showing:
   - Directory structure
   - User and permission configurations
   - Script executions and outputs
   - Process management steps
   - System report
   - Text processing results

3. ✅ Brief explanation (2-3 sentences) for each task describing:
   - What you did
   - Why you chose those specific commands
   - Any challenges faced

---

## Evaluation Criteria

| Criteria | Points | Description |
|----------|--------|-------------|
| Task 1: Directory Setup | 15 | Correct structure and permissions |
| Task 2: User Management | 20 | Proper user/group creation and ownership |
| Task 3: Log Analysis | 25 | Functional script with correct output |
| Task 4: Process Mgmt | 15 | Successful process control |
| Task 5: System Report | 15 | Complete system information |
| Task 6: Text Processing | 10 | Correct filtering and manipulation |
| **Total** | **100** | |

**Passing Score:** 80 points

---

## Bonus Challenge (Extra 10 points)

Create a cron job that runs your `system_report.sh` script every day at 2 AM and saves the output with a timestamp in the filename.

**Deliverable:** Show your crontab entry and verify it's scheduled correctly.

---

## Resources Allowed

- ✅ Man pages (`man <command>`)
- ✅ Internet search
- ✅ Course materials
- ✅ Your notes

## Resources NOT Allowed

- ❌ Asking others to complete the work for you
- ❌ Using pre-written scripts from the internet (you must write your own)

---

## Next Steps

- **If you scored 80+:** Congratulations! Proceed to [Phase 2: Networking](../../phase-2-networking/)
- **If you scored below 80:** Review [Phase 1 Topics](../../phase-1-linux/) and retry the challenge

---

## Solution Guide

A detailed solution guide is available for instructors. Do not peek until you've completed the challenge!

[View Solution Guide](./solutions/phase-01-linux-solution.md) *(Instructor access only)*
