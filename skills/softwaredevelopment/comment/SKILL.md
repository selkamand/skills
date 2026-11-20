---
name: comment
description: Write, review, and update source code comments for maintainers. Use whenever writing or changing R or Rust code, and when asked to add, edit, or review code comments in any language. Covers implementation comments. Use consumer-facing API documentation guidance for roxygen and Rustdoc.
---

# Comment code for maintainers

Close information gaps that could cost a future maintainer time or lead them to change the code incorrectly. Write for a teammate who has the code in front of them and lacks the context from this session. Use [Jon Gjengset’s “On comments”](https://blog.helsing.ai/posts/on-comments/) as the basis for deciding what merits a comment.

## Check every change

Before editing, read the comments that describe the changed code or depend on its behavior. Look beyond the immediate lines when a caller, test, or related implementation documents an affected assumption. After editing, check those comments against the resulting behavior and the paths they describe.

- Update or move comments when their claims or placement have become misleading. Remove obsolete or redundant comments when they carry no useful context. Preserve any rationale that still applies.
- For each changed area, decide whether there is new information a maintainer needs. If the comments need no edits, explain in the handoff why the existing claims still hold, where applicable, and why the change needs no new comment. Group changes with the same reason.
- For a comment review, ground each finding in the behavior and give its location. Edit the comments when asked to make changes.

## Capture the useful context

Put each comment next to the decision, constraint, or assumption a maintainer would encounter while editing. Keep it as short as the explanation allows. Use complete sentences and precise names. Skip narration that a reader can get from the next few lines.

- Explain what a correctness argument depends on, where the invariant is established, or what breaks if a maintainer changes a dependency, ordering, or representation.
- Preserve a workaround’s observed failure, the reason an apparently simpler approach fails, or the benefit and downside of a deliberate trade-off. Include the conditions that make that context relevant.
- For a non-obvious constant, explain where the value came from and what changing it would affect. For a borrowed algorithm or implementation, cite a stable source and explain meaningful departures. Outline the main steps of an algorithm when the implementation obscures them.
- Give a TODO enough context to act on. State what is deferred and why, and link a known issue when it helps. Follow the repository’s conventions for comment syntax and TODOs.

Use what the user explained, what you observed while making the change, and relevant code, tests, or history to check your claims. When the reason for a material choice is still unclear, add or update a nearby comment that says exactly what is unclear. Include any relevant behavior or constraint you could verify. Flag the same gap in the handoff with its file and line so the user can supply the missing context.

```r
# Export fixtures contain duplicate IDs. It is unclear why the last row
# for each ID takes precedence.
```
