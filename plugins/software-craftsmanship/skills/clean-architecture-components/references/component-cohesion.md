# Component cohesion: REP, CCP, CRP

## Core statements
- **REP**: the granule of reuse is the granule of release. Group only code that
  makes sense to version, announce and document together, under one theme.
- **CCP**: group what changes for the same reasons at the same time; separate
  what changes apart (SRP at component scale, tied to OCP-style strategic closure).
- **CRP**: group what is reused together; do not make consumers depend on
  classes they do not use (ISP at component scale). Mostly a rule about what to keep apart.

## Trade-offs
- REP and CCP are inclusive: they enlarge components. CRP is exclusive: it shrinks them.
- Only REP+CRP: a small edit touches many components.
- Only CCP+REP: many unneeded releases reach consumers.
- Only CCP+CRP: weak release story, hard to reuse.

## Which dominates when
- Young project, one team, few consumers: CCP first (develop-ability > reuse). Few fat components.
- Growing project, other teams start consuming: REP and CRP gain weight, so split
  into focused, versioned components.
- Mature library: CRP/REP dominate; stability of the public surface matters more
  than internal convenience.
Layout will shift with time; revisit it when who-uses-what changes.

## Symptoms
- One feature change edits 4+ components (CCP violated, or REP/CRP over-applied).
- Consumer rebuilds for releases that never touched what it uses (CRP).
- Component with no nameable theme, "utils", "common", "misc" (REP).
- Consumers import one class but must install the whole package (CRP).
- Changelog entries unrelated to each other (REP).

## Fix steps
1. For each component, list reasons to change; if more than one, split along them (CCP).
2. List which consumers use which parts; parts used by disjoint consumers go to separate components (CRP).
3. Merge components that always change and release together (CCP/REP).
4. Give each a name stating its theme, a version, and a changelog (REP).
5. Check the split does not create a cycle (see acyclic-dependencies.md).

## Example (original)
`shop-core` holds `Cart`, `Pricing`, `PdfInvoice`, `SmtpMailer`. Pricing rules
change monthly; invoice layout changes yearly; mailer swaps rarely. A mobile
app wants only `Cart`+`Pricing` but pulls in PDF and SMTP libraries.
```
Before: shop-core {Cart, Pricing, PdfInvoice, SmtpMailer}
After:  shop-cart-pricing {Cart, Pricing}   # change together, reused together
        shop-invoicing    {PdfInvoice}      # depends on shop-cart-pricing
        shop-mail         {SmtpMailer}      # independent
```
Pricing edits now release one component; mobile depends on one small package.

## Language notes
- Python: one distribution (pyproject) per component; top-level packages inside
  are not components unless published separately. Extras (`pkg[pdf]`) soften CRP.
- npm workspaces: each workspace with its own package.json and version is a component; use scoped names.
- Java: Maven/Gradle modules or JPMS modules; one artifact per component.
- Go: a module (go.mod) is the release unit; packages inside it share a version, so split modules only when versions must diverge.
- .NET: assembly/NuGet package is the unit; avoid one giant "Common.dll".

Source: Martin (2017), Ch. 13.
