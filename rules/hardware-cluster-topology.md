# SOVEREIGN HARDWARE CLUSTER TOPOLOGY & FLEET BURST POOL SPECIFICATION

- **Document ID**: SPEC-CLUSTER-TOPO-2026-10-09 (MODERNIZED)
- **Target Nodes**: `serv-001` (VPS Ingress), `thinkpad-arch` (Workstation), **MeshCentral Multi-Burst Pool (`burst-001` .. `burst-043`+)**
- **Status**: RATIFIED & ACTIVE
- **Principle**: Sovereign Multi-Tier Cluster (24/7 Cloud Ingress + Interactive Client + Decentralized Multi-Burst Compute Pool)
- **Transport Standard**: **Channel 1 (MeshCentral Outbound WSS / port 443) is the SOLE active transport for workers**. Channels 2 (Tailscale) and 3 (Rathole) are OFFICIALLY DEPRECATED.

---

## 1. SOVEREIGN CLUSTER TOPOLOGY & FLEET HARDWARE PROFILE

```text
+-----------------------------------------------------------------------------------+
|               MESHCENTRAL OUTBOUND WSS TRANSPORT (CHANNEL 1 ACTIVE)               |
+-----------------------------------------------------------------------------------+
        ▲                                     ▲                               ▲
        │ (24/7 Always-On)                    │ (Interactive Client)          │ (On-Demand WSS Dispatch)
        ▼                                     ▼                               ▼
+-----------------------+           +-----------------------+       +-----------------------+
|       serv-001        |           |     thinkpad-arch     |       |   MULTI-BURST POOL    |
|    (Cloud Host VPS)   |           |    (Developer UI)     |       |  (burst-001 .. -043+) |
|-----------------------|           |-----------------------|       |-----------------------|
| Role: Ingress & Bot   |           | Role: Console / UI    |       | Role: Burst Compute   |
| OS: Debian 12 x86_64  |           | OS: Arch Linux LTS    |       | OS: Linux / Win11     |
| CPU: 2 vCPU           |           | CPU: i5-4300M (2C/4T) |       | CPU: High-Core / GPUs |
| RAM: 12GB             |           | RAM: 11GB DDR3        |       | RAM: 16GB+ Pool       |
| Ingress: 24/7 Daemons |           | Display: Healthy LCD  |       | Mode: Boot-to-Poweroff|
+-----------------------+           +-----------------------+       +-----------------------+
```

### Detailed Fleet Archetypes

| Archetype / Node | Identitas Host / Pool | Profil & Akses Transport | Peran & Beban Komputasi | Siklus Operasional |
| :--- | :--- | :--- | :--- | :--- |
| **Cloud Ingress (`serv-001`)** | `serv-001` (VPS Debian 12) | 24/7 Cloud Grid, Dokploy, Traefik | Live Trading Bot, Webhooks, Master Telemetry | 24/7 Always-On |
| **Interactive Cockpit (`thi`)** | `thinkpad-arch` | Arch Linux, Healthy Display | Manual terminal, code review, git management | Human interactive |
| **Multi-Burst Pool (`burst-*`)**| `burst-001` s/d `burst-043`+ | **MeshCentral WSS (Channel 1)** | Tabular ML Retraining, 365d Backtesting, Harvester | On-Demand (Boot -> Work -> Off) |
| **Pool Node: TUF (`burst-016`)**| `tuf-gaming-arch` (Ryzen 7 16T + RTX 2050) | MeshCentral WSS (Channel 1) | Heavy ML batch compute (`crypto-burst-trainer`) | On-Demand (Nightly Window) |

> [!IMPORTANT]
> **CHANNELS 2 & 3 DEPRECATION INVARIANT**:
> - Tailscale IP routing (`100.x.x.x`) [Channel 2] dan Rathole proxy tunnels (`:4040`) [Channel 3] **RESMI DIDEPRIEKASI**.
> - Seluruh AI Agent DILARANG KERAS berasumsi bahwa burst worker dapat diakses via Tailscale SSH atau IP langsung. Seluruh interaksi wajib melewati **Channel 1 (MeshCentral WSS via RPC `meshctrl` / `scripts/meshcentral_fleet_dispatcher.py`)**.
> - TUF / `burst-001` **BUKAN LAGI SATU-SATUNYA BURST WORKER**. Seluruh armada burst worker di MeshCentral adalah satu kesatuan compute pool.

---

## 2. HARD CONSTRAINTS ON BURST COMPUTE POOL (INCL. TUF / `burst-016`)

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
    `~/.ssh/tuf_backup/id_ed25519_tuf_gaming`
- **AI Agent Identity on TUF**:
  - `agy` version `1.1.27` is installed at `~/.local/bin/agy`.
  - Active OAuth token and multi-account configurations are synced from ThinkPad master.
  - 1.908 modular agent skills are synced to `~/.gemini/config/skills/`.

---

## 5. OPERATIONAL PROTOCOL FOR AI AGENTS ON VPS (`serv-001`)

When an autonomous agent running on `serv-001` identifies a task requiring heavy computational capacity (e.g. ML retraining, grid search backtesting, data harvesting):

1. **Fleet Discovery via Channel 1**:
   - Query currently online burst workers via MeshCentral RPC:
     ```bash
     .venv/bin/python scripts/meshcentral_fleet_dispatcher.py list
     ```
   - If no burst nodes are online, defer heavy jobs to local queue or alert via Telegram. Never poll in an infinite loop.

2. **Headless Execution via Channel 1 (Outbound WSS)**:
   - Dispatch job without SSH or Tailscale:
     ```bash
     .venv/bin/python scripts/meshcentral_fleet_dispatcher.py run --node burst-016 --cmd "..." --os linux
     ```

3. **Artifact Retrieval (Pull-Mode Pattern)**:
   - When remote job completes, it writes `reports/job_completed.json`.
   - VPS pulls artifacts into local directory using MeshCentral `Download` RPC:
     ```bash
     .venv/bin/python scripts/meshcentral_fleet_dispatcher.py download --node burst-016 --remote "models/regime_model.onnx" --local "models/"
     ```
   - For candlestick harvesting, run:
     ```bash
     .venv/bin/python scripts/meshcentral_fleet_dispatcher.py sync-harvester
     ```
