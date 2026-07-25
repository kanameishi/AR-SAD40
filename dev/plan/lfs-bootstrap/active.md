```json
{
  "schemaVersion": 2,
  "topicId": "lfs-bootstrap",
  "generation": 1,
  "writerId": "codex-lfs-bootstrap-20260725",
  "intent": {
    "path": "dev/plan/lfs-bootstrap/intent/INTENT-0001.md",
    "size": 1670,
    "mtimeNs": 1784984863009143718,
    "sha256": "3687e09f44a704c2928cda079ad8edfcb6d16aa157e2e79146d4e676bac9a2a3"
  },
  "previousReceipt": {
    "path": "dev/plan/lfs-bootstrap/receipts/RECEIPT-0001.json",
    "size": 1577,
    "mtimeNs": 1784985548727883348,
    "sha256": "f9b7fd914751f73b978984dbf06b1aaf42d86388c9028fa650267eac5074abcc"
  },
  "work": {},
  "liveRuns": {},
  "openConditions": [],
  "validation": [
    {
      "id": "bounded-lfs-inspection",
      "state": "VERIFIED",
      "authority": "DATA.md",
      "gate": "Use metadata/pointer/config reads only for _ref, data, and LFS patterns."
    },
    {
      "id": "lfs-attributes",
      "state": "VERIFIED",
      "authority": "git check-attr",
      "gate": "_ref/** and data/.gitkeep resolve to Git LFS attributes."
    },
    {
      "id": "staged-scope",
      "state": "VERIFIED",
      "authority": "GIT.md",
      "gate": "git diff --cached contains only task-owned paths."
    },
    {
      "id": "publication",
      "state": "VERIFIED",
      "authority": "git push",
      "gate": "Current branch push succeeds to its configured remote."
    }
  ],
  "evidence": [
    {
      "id": "initial-git-state",
      "kind": "observation",
      "value": "branch=main head=956d2b49beae75b2c270674b00606989f724ebe8 status-untracked=_chapters,_ref,scripts"
    },
    {
      "id": "lfs-pattern-decision",
      "kind": "observation",
      "value": "reference .gitattributes files in AR-SAC00.R, AR-SABP0.R, and AR-SABJ0.R track data/** and _ref/** with filter=lfs diff=lfs merge=lfs -text; this task uses folder-scoped patterns only."
    },
    {
      "id": "ref-metadata",
      "kind": "observation",
      "value": "_ref exists with fileCount=21 totalFileBytes=36230089; data and .gitattributes absent before task edit; no binary blobs read."
    },
    {
      "id": "result-summary",
      "kind": "path",
      "value": "dev/plan/lfs-bootstrap/results/lfs-bootstrap-summary.json"
    },
    {
      "id": "empty-placeholder-lfs-behavior",
      "kind": "observation",
      "value": "A zero-byte file under data/** remains the Git empty blob in the index with Git LFS 3.7.1, while git lfs status classifies it with empty-content LFS oid e3b0c44; future non-empty files under data/** use LFS pointers."
    },
    {
      "id": "staged-scope",
      "kind": "observation",
      "value": "git diff --cached and git diff --cached --check passed; staged paths are .gitattributes, _ref, data/.gitkeep, dev/SoT/ACTIVE.md, and dev/plan/lfs-bootstrap; _chapters and scripts remain unstaged."
    },
    {
      "id": "functional-commit",
      "kind": "observation",
      "value": "3cbac5906135b2a06026634adad57dff1920788f Configure LFS reference storage pushed to origin/main."
    },
    {
      "id": "push-result",
      "kind": "observation",
      "value": "git push origin main uploaded LFS objects 100% (21/21), 36 MB, and advanced origin/main from 956d2b4 to 3cbac59."
    },
    {
      "id": "terminal-receipt",
      "kind": "path|size|mtimeNs|sha256",
      "value": "dev/plan/lfs-bootstrap/receipts/RECEIPT-0001.json|1577|1784985548727883348|f9b7fd914751f73b978984dbf06b1aaf42d86388c9028fa650267eac5074abcc"
    }
  ],
  "exactNextAction": "No in-scope action remains; preserve out-of-scope _chapters/ and scripts/ unless separately authorized.",
  "semanticDigest": "sha256:785cc6b61049dc2396324d915066fc701ea90c25853b165d693f772efb543f7e"
}
```
