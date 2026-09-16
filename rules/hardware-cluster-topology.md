# SOVEREIGN HARDWARE CLUSTER TOPOLOGY & BURST WORKER SPECIFICATION

- **Document ID**: SPEC-CLUSTER-TOPO-2026-09-06
- **Target Nodes**: `servv` (VPS), `thinkpad-arch` (Workstation), `tuf-gaming-arch` (Burst Worker)
- **Status**: RATIFIED & ACTIVE
- **Principle**: Decoupled Tri-Node Architecture (24/7 Cloud Ingress + Interactive Client + Burst Compute)

---

## 1. TRI-NODE FLEET TOPOLOGY & HARDWARE PROFILE

```text
+-----------------------------------------------------------------------------------+
|                            TAILSCALE ENCRYPTED MESH                               |
+-----------------------------------------------------------------------------------+
        ▲                                     ▲                               ▲
        │ (24/7 Always-On)                    │ (Interactive Client)          │ (On-Demand Burst)
        ▼                                     ▼                               ▼
+-----------------------+           +-----------------------+       +-----------------------+
|         servv         |           |     thinkpad-arch     |       |    tuf-gaming-arch    |
|   (100.67.53.119)     |           |    (100.68.194.103)   |       |     (100.69.47.16)    |
|-----------------------|           |-----------------------|       |-----------------------|
| Role: Cloud & Ingress |           | Role: Console / UI    |       | Role: Burst Worker    |
| OS: Debian 12 x86_64  |           | OS: Arch Linux LTS    |       | OS: Arch Linux LTS    |
| CPU: 2 vCPU           |           | CPU: i5-4300M (2C/4T) |       | CPU: Ryzen 7 (8C/16T) |
| RAM: 4GB              |           | RAM: 11GB DDR3        |       | RAM: 16GB DDR5        |
| Disk: 80GB SSD        |           | Disk: 1TB SATA        |       | Disk: 512GB NVMe SSD  |
| GPU: None             |           | GPU: Intel HD 4600    |       | GPU: NVIDIA RTX 2050  |
| Display: Headless     |           | Display: Healthy LCD  |       | Display: BROKEN / DEAD|
| Power: 24/7 Cloud PSU |           | Power: Healthy AC/BAT |       | Power: UNSTABLE/LIMIT |
+-----------------------+           +-----------------------+       +-----------------------+
```

### Detailed Node Specifications

| Metric / Attribute | Node 1: `servv` | Node 2: `thinkpad-arch` | Node 3: `tuf-gaming-arch` |
| :--- | :--- | :--- | :--- |
| **Hostname** | `VM-2-105-debian` (`servv`) | `thinkpad-arch` | `tuf-gaming-arch` |
| **Tailscale IP** | `100.67.53.119` | `100.68.194.103` | `100.69.47.16` |
| **Local LAN IP** | Cloud Public (`43.157.229.233`) | `192.168.0.127` | `192.168.0.110` |
| **Primary User** | `fuckadmin` | `fuckadmin` | `aomiqaza` |
| **Hardware Model** | Cloud KVM VPS | Lenovo ThinkPad T440p | ASUS TUF Gaming A15 (FA506NFR) |
| **Processor** | 2 vCPU Intel Xeon | Intel Core i5-4300M (2C/4T @ 2.60GHz) | **AMD Ryzen 7 7435HS (8C/16T)** |
| **Graphics** | None | Intel HD Graphics 4600 | **NVIDIA GeForce RTX 2050 (4GB)** |
| **Memory** | 4 GiB | 11 GiB DDR3 | **16 GiB DDR5** |
| **Storage** | 80 GiB SSD | 1 TB SATA | **512 GiB High-IOPS NVMe SSD** |
| **Physical Display**| Headless (Cloud) | Working Built-in Display | **BROKEN / DEAD (Blackout)** |
| **Power State** | 24/7 Always-On Grid | Stable Plugged-in Adapter | **FAULTY CHARGER / DRAINING** |
| **Network State** | Constant 24/7 Internet | Standard Home Internet | **Intermittent / Offline-Frequent** |

---

## 2. HARD CONSTRAINTS ON `tuf-gaming-arch` (NODE 3)

AI Agents operating across this cluster (specifically on VPS `servv`) MUST strictly respect these 4 immutable physical constraints:

### Constraint 1: Headless / Pure CLI Interaction Only
- The internal LCD is physically broken and completely non-functional.
- All access is strictly via SSH (`ssh tuf-gaming-arch` or `ssh aomiqaza@100.69.47.16`).
- **Prohibition**: AI agents must never waste resources building or troubleshooting GUI display pipelines (Niri, Wayland, X11, Display Managers) for interactive use on Node 3. All workflows must be pure terminal, headless background tasks, or headless API servers.

### Constraint 2: Power & Charger Vulnerability (STRICT NON-24/7)
- The laptop charger is faulty/unstable and cannot sustain 24/7 always-on power delivery.
- Running heavy tasks continuously will cause thermal trip, charger throttling, or battery drain.
- **Contract**: Node 3 is strictly an **On-Demand Burst Compute Worker**, NEVER a 24/7 daemon host.
- **Safe Execution Pattern**:
  ```bash
  # Any scheduled heavy job on Node 3 MUST gracefully shut down the machine upon completion
  ./run_heavy_job.sh && sudo systemctl poweroff
  ```
- Emergency shutdown must trigger if battery capacity drops below 10% to prevent dirty filesystem corruption on Btrfs/NVMe.

### Constraint 3: Intermittent & Offline Network
- Node 3 is frequently shut down or disconnected from the internet.
- **Contract for VPS AI**:
  1. AI agents on `servv` MUST NEVER assume Node 3 is online.
  2. Any dispatch to Node 3 must verify reachability first (`ping -c 1 -W 2 100.69.47.16` or `nc -zv -w 2 100.69.47.16 22`).
  3. Workloads sent to Node 3 must be self-contained (tools, models, dependencies pre-installed) and able to execute 100% offline.

---

## 3. WORKLOAD ALLOCATION MATRIX (WHO DOES WHAT)

```text
[ Task Type ]                  [ Optimal Node ]      [ Rationale ]
-------------------------------------------------------------------------------------------------
24/7 Web & Bot Ingress         -> servv (VPS)        Always-on IP, public ports, reliable SLA
Interactive Coding / Writing   -> thinkpad-arch      Healthy LCD, human keyboard, active terminal
Local LLM / SLM Inference      -> tuf-gaming-arch    RTX 2050 CUDA + 16 CPU threads (Ollama/GGUF)
Heavy Compilation (Rust/Kernel)-> tuf-gaming-arch    8C/16T Ryzen + NVMe (5x-10x faster than T440p)
Audio / Video AI Processing    -> tuf-gaming-arch    Whisper transcription, NVENC ffmpeg rendering
Cold Backup Storage Vault      -> thinkpad-arch      1TB SATA drive + Rclone multi-cloud sync
```

---

## 4. SSH & CREDENTIAL ARCHITECTURE

- **Authentication Matrix**:
  - `thinkpad-arch` -> `tuf-gaming-arch`: Key `~/.ssh/id_ed25519_thinkpad_pass` (authorized in `~/.ssh/authorized_keys` of `aomiqaza`).
  - `tuf-gaming-arch` -> `thinkpad-arch`: Dedicated key `~/.ssh/id_ed25519_tuf_gaming` (authorized in `~/.ssh/authorized_keys` of `fuckadmin`).
  - `tuf-gaming-arch` -> `servv`: Dedicated key `~/.ssh/id_ed25519_tuf_gaming`.
  - `thinkpad-arch` -> `servv`: Key `~/.ssh/id_ed25519_thinkpad_pass`.
- **Key Backups**:
  - TUF's private & public keys are safely backed up on ThinkPad at:
    [`/home/fuckadmin/.ssh/tuf_backup/id_ed25519_tuf_gaming`](file:///home/fuckadmin/.ssh/tuf_backup/id_ed25519_tuf_gaming)
- **AI Agent Identity on TUF**:
  - `agy` version `1.1.27` is installed at `/home/aomiqaza/.local/bin/agy`.
  - Active OAuth token and multi-account configurations are synced from ThinkPad master.
  - 1.908 modular agent skills are synced to `/home/aomiqaza/.gemini/config/skills/`.

---

## 5. OPERATIONAL PROTOCOL FOR AI AGENTS ON VPS (`servv`)

When an autonomous agent running on `servv` identifies a task requiring heavy computational capacity (e.g. LLM fine-tuning/inference, heavy compilation, media transcoding):

1. **Pre-Flight Reachability Gate**:
   ```bash
   if nc -zv -w 2 100.69.47.16 22 2>/dev/null; then
       echo "[CLUSTER] tuf-gaming-arch is ONLINE. Ready for burst offload."
   else
       echo "[CLUSTER] tuf-gaming-arch is OFFLINE. Deferring heavy job to local queue or awaiting manual boot."
   fi
   ```
2. **Work Packet Dispatch**:
   - Transfer input data/job scripts to `tuf-gaming-arch:~/jobs/<job-id>/`.
   - Trigger the execution remotely via SSH:
     ```bash
     ssh tuf-gaming-arch "cd ~/jobs/<job-id> && ./run.sh && rsync -avz output/ fuckadmin@100.67.53.119:~/output/ && sudo poweroff"
     ```
3. **No-Polling Invariant**:
   - VPS agent must not poll `tuf-gaming-arch` in an infinite loop while waiting for boot. If offline, notify the developer to power on the machine.
