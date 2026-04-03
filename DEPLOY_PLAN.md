# Railway Deployment Plan: Minimal Repo

## Status

- ✅ Minimal deployment extracted: `deploy/railway-background-agent/` (2.3MB)
- ✅ Dockerfile fixed (ubuntu:24.04 runtime, simplified COPY)
- ✅ Git repo initialized, branch renamed to `main`
- ⏳ **BLOCKED**: GitHub repo needs to be created

## Manual Steps Required

### Step 1: Authenticate GitHub CLI
```bash
gh auth login
# Follow the prompts to authenticate
```

### Step 2: Create GitHub Repo
```bash
cd /Users/playra/trinity-w1/deploy/railway-background-agent
gh repo create gHashTag/trinity-railway-agent --public --description "Minimal Railway deployment for Trinity Background Agent API (Zig binary)" --source=. --remote=origin
git push -u origin main
```

**Alternative**: Create repo manually at https://github.com/new with name `trinity-railway-agent`, then:
```bash
git remote add origin https://github.com/gHashTag/trinity-railway-agent.git
git push -u origin main
```

### Step 3: Connect Railway to New Repo

In Railway dashboard (https://railway.app/project/AGENTS):

1. **Delete old service** (to clear broken state):
   - Go to `background-agent-railway` service
   - Settings → Delete service

2. **Create new service**:
   - Click "New Service" → "Deploy from GitHub repo"
   - Select `gHashTag/trinity-railway-agent`
   - Railway will automatically use the `Dockerfile` and `railway.json`

### Step 4: Verify Build

1. Watch build logs in Railway dashboard
2. Expected stages:
   - Build snapshot (should be <5MB now)
   - Install Zig 0.15.2
   - `zig build -Doptimize=ReleaseSafe background-agent-api`
   - Start container

### Step 5: Configure Environment Variables (if needed)

In Railway dashboard → Settings → Variables:
```
PORT=3000
DATABASE_URL=postgresql://...
```

## What's in the Minimal Repo

```
deploy/railway-background-agent/
├── Dockerfile              # Multi-stage build (ubuntu:24.04 runtime)
├── railway.json            # Railway service configuration
├── build.zig               # Zig build system
├── src/
│   ├── background_agent/   # API source code
│   └── vsa/                # VSA library
├── vm.zig                  # VM implementation
├── hybrid.zig              # Hybrid layer
├── c_api.zig               # C API bindings
├── science.zig             # Scientific computing
└── vsa_jit.zig             # JIT compiler

Total: ~2.3MB, 67 files
```

## Rollback (if needed)

```bash
# Reconnect Railway to original repo
# In Railway dashboard: Delete service → Create from gHashTag/trinity
# This will re-encounter the 17GB snapshot issue
```

## Success Criteria

- ✅ Railway snapshot succeeds (<5MB)
- ✅ Zig build completes
- ✅ Container starts
- ✅ Healthcheck passes
- ✅ API responds on `https://background-agent-railway-production.up.railway.app`
