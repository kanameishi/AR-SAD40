# Intent: LFS bootstrap

Objective: configure this repository so `_ref/` and `data/` are Git LFS-managed roots, create a zero-length synchronization placeholder in `data/`, and publish the authorized change to the current remote branch.

Scope:
- Inspect repository state and bounded metadata for `_ref/`, `data/`, existing `.gitattributes`, and reference-project LFS patterns.
- Add or update only the LFS/configuration files needed for `_ref/` and `data/`.
- Create `data/` with one zero-length placeholder file.
- Stage, commit, and push only task-owned paths after validation.

Exclusions:
- Preserve pre-existing untracked `_chapters/` and `scripts/` unless later explicitly authorized.
- Do not read binary/LFS blob contents.
- Do not rewrite Git history or run Git LFS history migration.
- Do not delete or move existing `_ref/` material.

Acceptance gates:
- `.gitattributes` tracks `_ref/**` and `data/**` through Git LFS using the chosen repository pattern.
- `data/` contains a zero-length placeholder suitable for Git synchronization.
- Bounded metadata confirms in-scope file presence and no unintended broad data reads.
- `git check-attr filter diff merge text` confirms LFS attributes for `_ref/` and the data placeholder.
- Complete staged diff contains only task-owned paths.
- Commit is created with configured human Git identity unchanged and pushed to the current upstream branch.

Stop conditions:
- Existing active harness state belongs to another writer.
- Existing staged or dirty in-scope paths have unresolved ownership.
- Git LFS is unavailable and cannot be validated.
- Exact staging would include unrelated `_chapters/` or `scripts/` work.
