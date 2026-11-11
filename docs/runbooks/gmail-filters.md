# Runbook: Gmail labels and filters

Project mail is sorted in the owner's Gmail by filters kept as code in [`config/gmail/filters.xml.tmpl`](../../config/gmail/filters.xml.tmpl) (ADR-0007, "Mail organization"). The template holds `{{GMAIL_USER}}` instead of the real address, so it is safe in the public repo.

## Current setup (2026-11-11)

| Label | Colour | Filter | Extra |
|---|---|---|---|
| `eduardiacob.dev` | — | parent only, holds the children below | — |
| `eduardiacob.dev/hello` | blue | `deliveredto:<gmail>+hello@gmail.com` | never spam |
| `eduardiacob.dev/ops` | orange | `deliveredto:<gmail>+ops@gmail.com` | never spam |
| `eduardiacob.dev/aws` | red | `deliveredto:<gmail>+aws@gmail.com` | never spam, always important |
| `eduardiacob.dev/accounts` | dark grey | from `cloudflare.com OR github.com OR brevo.com`, not delivered to a plus address | never spam |

- No filter archives or deletes mail: everything stays in the inbox and gets a label.
- `accounts` was applied to existing mail on import. Older GitHub mail from before the project (2022–2025) was unlabelled by hand, so the label only holds mail from 2026-11-11 on.
- The owner's pre-existing personal filters are left untouched.

## Re-import or restore

1. Render the template with the Gmail address from the Keychain, outside the repo:

   ```bash
   scripts/gmail-filters.sh "$TMPDIR/gmail-filters.xml"
   ```

2. Gmail > Settings > Filters and Blocked Addresses > Import filters > choose the file > Open file > select the 4 filters > tick "Apply new filters to existing email" > Create filters. Missing labels are created by the import.
3. Delete the rendered file: `rm "$TMPDIR/gmail-filters.xml"`.
4. If an existing filter is replaced, delete the old copy first, or Gmail keeps both.

Colours and the parent label are not part of the XML: set them by hand in the label menu (table above). Create the parent `eduardiacob.dev` and reload Gmail to see the children nested.

## Change a filter

Edit the template, re-import as above, then delete the old version of the changed filter in Gmail. Commit the template change with the reason in the message.
