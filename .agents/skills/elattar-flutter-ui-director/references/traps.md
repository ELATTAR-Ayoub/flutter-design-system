# Traps

| Trap | Correction |
| --- | --- |
| Styled local `Container`/`Text` | Use `DsCard`, `DsText`, variants, and foundation tokens. |
| Page-only color/radius/duration constant | Use semantic contracts; promote a foundation token only with cross-system evidence. |
| Rebuilding from memory | Search barrel, source, tests, and example first. |
| One-off page inside `lib/src/components/` | Keep it in product/example code. |
| Screenshot-only skeleton/toast | Wire real transitions and test them. |
| “Responsive” means shrinking desktop | Reflow hierarchy and interaction density at system breakpoints. |
| Decoration carries state | Use semantic text/controls; keep effects subordinate. |
| Token-guard exception as shortcut | Prove and document an external-integration requirement on the exact line. |
| Green analyzer without render review | Capture light/dark and narrow/wide states, then inspect them. |
