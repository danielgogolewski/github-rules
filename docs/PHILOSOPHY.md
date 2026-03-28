# ZeroDrift Philosophy

## The Core Idea

There is a difference between **building** and **replicating**.

Building = creative work. The source is an idea, a brief, a specification. Output is new.

Replicating = exact work. The source is a Figma file, a production database, a live WordPress site. Output must be identical to source.

AI agents are trained to build. They want to create, improve, optimize, clean up.
ZeroDrift forces them to replicate — which is a fundamentally different mode of operation.

---

## Why Drift Happens

Drift is not malicious. It comes from good intentions:

- "I'll round 13px to 14px — it's a cleaner number"
- "I'll install the latest version — it has security patches"
- "I'll clean up this content while I'm migrating it"
- "I'll fix this spacing inconsistency I noticed"

Each of these feels like the right thing to do. Each of these is drift.

The problem is not any single drift. The problem is that drift **compounds**.

After 6 months of small improvements, staging is no longer a replica of production.
After 20 components of "cleaner" spacing, the design system is no longer the Figma file.
After a "cleaned up" content migration, the client's published work has been altered without consent.

---

## The Roman Pizza Rule

> Pizza must taste the same in Rome and in NYC.
> If that requires shipping water from the Tiber — you ship the water.

This is not a metaphor about being inflexible. It's a metaphor about **source fidelity**.

The pizza in NYC could taste better with local water. Maybe it would. But it would not taste the same. And "the same" is the contract.

When a client says "migrate our site", they mean: what we have, exactly, somewhere else.
When a designer says "implement this", they mean: what I designed, exactly, in code.

"Better" is not in scope. "Exactly" is the contract.

---

## The rsync --delete Model

```bash
rsync -av --delete source/ destination/
```

The `--delete` flag is the key. Without it, rsync copies but does not clean. Files that existed in destination but not in source remain. Drift accumulates silently.

With `--delete`, destination becomes an exact mirror of source. Always. No orphans. No extras.

Every ZeroDrift operation should behave like `rsync --delete`:
- Extra in destination → removed
- Missing in destination → added
- Different in destination → replaced

The result is not "similar to" source. It IS source.

---

## What 1:1 Is NOT

- It is not a rule against improvement. Improve in a separate PR.
- It is not a rule against cleaning up. Clean up in a separate ticket.
- It is not inflexibility. It is clarity about what task is being performed.

When the task is **replication**, the output must be exact.
When the task is **creation**, creative judgment is appropriate.

ZeroDrift only governs replication tasks.

---

## The Tiber Water Principle

> If the replica requires a specific resource from the source — bring the resource. Do not find a substitute.

- Need exact prod DB snapshot? Take the snapshot. Don't generate fake data.
- Need exact config from prod? Copy it. Don't rewrite from memory.
- Need the paid font from the Figma file? Purchase it. Don't use "a similar free font".
- Need exact Node.js version? Set it in `.nvmrc`. Don't use "any 20.x".

The cost of sourcing the exact resource is always lower than the cost of drift discovered in production.

---

## The Acceptance Test

For visual implementation, there is one objective test:

Screenshot the browser. Export the Figma frame. Overlay at 50% in Photoshop.

If you see nothing — the implementation is 1:1.
If you see any outline, offset, or color difference — it is not done.

This test is not a suggestion. It is the definition of done.

---

*ZeroDrift was created from operational experience at [Hyperdata PSA](https://hyperdata.pl), distilled from years of WordPress migrations, Figma implementations, and AI-assisted development where "close enough" was never good enough.*
