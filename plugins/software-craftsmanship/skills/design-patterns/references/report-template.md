# Report template (mode A: detect)

Use this structure. Keep it short and evidence-based; reply in the user's language.

```markdown
# Design pattern review: <scope>

## Summary
<2-3 sentences: main finding, count of patterns present / recommended>

## Patterns present
| Pattern | Where (file:line) | Explicit/Implicit | Healthy? | Note |
|---|---|---|---|---|

## Recommended patterns
### <Pattern> in <file:line>
- **Force/problem:** what hurts today
- **Evidence:** code signal (quote 1-3 lines)
- **Proposed change:** participants, minimal steps (idiomatic for <language>)
- **Cost/risk:** indirection added, migration effort
- **Priority:** high | medium | low

## Not recommended (considered and rejected)
- <Pattern>: why not (e.g. single variant, language feature already covers it)

## Next steps
1. ...
```

Rules: cite concrete locations; never recommend a pattern without a named force; include at least one "considered and rejected" item when any candidate was dismissed; end with a source line: Gamma, E., Helm, R., Johnson, R., & Vlissides, J. (1995). *Design patterns: Elements of reusable object-oriented software*. Addison-Wesley.
