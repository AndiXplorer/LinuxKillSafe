# Safe Kill Script

A Bash script to safely terminate processes while protecting critical system processes.

## Features
- Displays running processes sorted by memory usage.
- Prevents accidental termination of critical system processes.
- Allows termination by process name or PID.
- Supports force kill (`-f`) using SIGKILL (`kill -9`).
- Includes a dry run (`-d`) to show what would be killed without executing.

## Usage
```
./safe_kill.sh <PID|Process Name> [-f] [-d]
```

### Options:
- `-f` : Force kill (SIGKILL `-9`)
- `-d` : Dry run (Show what would be killed)

### Example Usage
```sh
./safe_kill.sh firefox
```
This will prompt for confirmation before terminating the Firefox process.

```sh
./safe_kill.sh 1234 -f
```
This will force kill the process with PID 1234 without confirmation.

```sh
./safe_kill.sh firefox -d
```
This will show what would be killed without actually terminating the process.

## Installation
1. Clone this repository:
   ```sh
   git clone https://github.com/AndiXplorer/LinuxKillSafe
   ```
2. Navigate to the directory:
   ```sh
   cd LinuxKillSafe
   ```
3. Give execution permissions:
   ```sh
   chmod +x safe_kill.sh
   ```
4. Run the script:
   ```sh
   ./safe_kill.sh
   ```

## Notes
- The script protects essential system processes (`systemd`, `gnome-shell`, `Xorg`, `init`).
- If a process name is provided, the script selects the oldest matching PID.
- Confirmation is required before killing a process unless `-f` is used.


## Contributions
Feel free to submit pull requests or issues if you have suggestions or improvements!