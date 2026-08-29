# Copy

Microcopy is where unfinished UI is most visible and cheapest to fix. These are
rules, not suggestions.

## Voice

- Plain words. Write what a colleague would say out loud.
- Second person for the user, first person plural only for things the product
  did: "You are offline", "We could not reach the server".
- Present tense. "Saving", not "Will be saved".
- No exclamation marks. No "Oops", "Uh oh", "Whoops", "Sorry about that".
- No "Please". It adds a word and no information.
- No internal vocabulary: entity, payload, endpoint, sync job, tenant, record id.

## Buttons and controls

- Verb plus object: "Create invoice", "Clear filters", "Sign in", "Delete
  project".
- The confirm button in a dialog repeats the verb of the action, never "OK".
- Sentence case, no trailing punctuation.
- Two to four words. If it needs more, the surrounding copy is missing.
- The same action is worded the same way everywhere in the product.

## Titles and headings

- Say what the thing is, not what section of the app it lives in.
- No colons introducing a second clause. Split into a title and a description.

## Empty states

Three parts, all required:

1. What is missing, stated as a fact: "No invoices yet".
2. Why, when the user could not have known: "Invoices appear here once a client
   is billed".
3. One control that fixes it: "Create invoice".

Filtered empty is different copy and a different action: "No invoices match
these filters", with "Clear filters". Never offer creation as the only exit
from a filtered view, and never write "No data".

## Loading

- Silence under roughly two seconds. A skeleton says enough.
- Past that, say what is running: "Uploading 3 files", "Preparing your export".
- Give a count or a proportion when one exists. "Loading" alone tells the user
  nothing they cannot see.
- Never "Please wait".

## Errors

Title, body, one next step. Full rules and a filled table in
[errors.md](errors.md). The two failures to avoid are printing the backend and
saying nothing about the user's data. Every error answers: is my work safe.

## Success

- Confirm only what the user cannot already see.
- Name the object: "Invoice INV-104 sent", not "Success".
- Offer undo where undo exists.

## Destructive confirmations

- The title asks the real question: "Delete 3 invoices?"
- The body names the consequence and whether it can be undone.
- The confirm button carries the verb. The cancel button says "Cancel".
- Never rely on the user reading the title only. The verb on the button must be
  enough on its own.

## Numbers, dates, names

- Format dates through the foundation's date formatting, never by hand.
- Never show a raw id where a name exists. When an id must appear, label it.
- Pluralize correctly, including the zero case.
- Never show a placeholder that leaked: "null", "undefined", "NaN", "-", or an
  empty string where a value was expected. Show an explicit "Not set".

## Checklist

- [ ] Buttons are verb plus object, consistent across the product.
- [ ] Empty states say what is missing, why, and what to do.
- [ ] Filtered empty is worded differently from truly empty.
- [ ] Loading past two seconds says what is running.
- [ ] Errors carry title, body, and one next step, and say whether data is safe.
- [ ] Success names the object and offers undo where it exists.
- [ ] Destructive confirmations name the consequence and carry the verb.
- [ ] No jargon, no placeholders, no raw ids, no exclamation marks.
