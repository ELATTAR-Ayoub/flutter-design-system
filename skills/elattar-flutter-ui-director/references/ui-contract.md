# The UI contract

Write the contract before the widgets. It is short on purpose: if it takes more
than a few minutes, the surface is doing too much.

One contract per page. Sections inside the page get a `region` block each.
A reusable component gets the component form in
[component-spec.md](component-spec.md) instead.

## Form

```
surface: <name> (page | section | flow)
job: <one sentence, the user's goal, not the feature name>
primary action: <the single most important control, or "none: read only">
entry: <how the user arrives, and what is already known>

data:
  <source>: <what it returns, who owns it, can it be empty, can it be filtered>

regions:
  <region>:
    states: loading, refreshing, ready, empty, noResults, failed   # only those that apply
    empty: <copy and the next step control>
    noResults: <copy and the control that clears the filter>       # omit if unfilterable
    failed: <categories that can reach it, and the channel>

triggers:
  <control>: <channel> -> <what the user sees> -> <next step>

responsive:
  narrow: <structure, not "smaller">
  medium: <structure>
  wide: <structure>

a11y:
  labels: <icon only controls and their labels>
  focus: <order, and where focus goes after an overlay closes>
  announce: <which async changes are announced>

theming: <anything beyond "both themes verified">
open questions: <or "none">
```

Only include lines that carry information. A read only page with one region does
not need a triggers table with a single row saying nothing.

## Worked example

```
surface: InvoicesPage (page)
job: Find an invoice and see whether it is paid.
primary action: New invoice
entry: From the sidebar. Nothing is known about the user's intent.

data:
  invoices: paged list, billing service, can be empty, filtered by status and date

regions:
  header:
    states: ready
  filters:
    states: ready
    triggers cover the reset path
  list:
    states: loading, refreshing, ready, empty, noResults, failed
    empty: "No invoices yet. Create one to start billing." -> Button "New invoice"
    noResults: "No invoices match these filters." -> Button "Clear filters"
    failed: offline, timeout, server, unknown -> Alert inside the list region

triggers:
  New invoice: navigation -> the create route opens with the form focused -> fill and save
  Status filter: inline -> the list refreshes in place, count updates -> read results
  Row: navigation -> the invoice detail opens -> read or pay
  Retry in Alert: inline -> region returns to refreshing, then ready or failed -> read results
  Clear filters: inline -> filters reset, list returns to ready or empty -> read results

responsive:
  narrow: filters collapse into a Sheet, list becomes stacked Cards, action moves to the header
  medium: filters in a row above a Table with fewer columns
  wide: filters inline, full Table, detail opens beside the list

a11y:
  labels: filter icon button "Filter invoices", row action menu "Invoice actions"
  focus: the Sheet traps focus and returns it to the filter button on close
  announce: "12 invoices" after a filter change, and any failed state

theming: status colors carry meaning, so each status also carries text
open questions: none
```

## Rules

- Every region that can be empty declares both `empty` and, when it is
  filterable, `noResults`. They are different states with different copy.
- Every trigger names a channel from [feedback.md](feedback.md) and ends in a
  next step. A trigger whose next step is "nothing" is a dead press.
- `responsive` describes structure. "Smaller" and "scaled down" are not
  answers. See [responsive.md](responsive.md).
- `failed` names error categories from [errors.md](errors.md), not exceptions.
- The contract goes in the handoff, so a reviewer can compare it to what shipped.
