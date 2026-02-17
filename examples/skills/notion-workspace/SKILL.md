---
name: notion-workspace
description: "Notion API for your workspace. Use when creating, reading, updating, or querying Notion pages and databases. Contains API patterns, property types, and critical gotchas."
---

# Notion Workspace

Notion API patterns, property types, and known issues.

## Auth

```bash
source ~/.secrets.env
# Sets NOTION_API_KEY (starts with ntn_)
```

Or use env var directly: `$NOTION_API_KEY`

## API Version

<!-- Check Notion's changelog for the latest stable version. Some newer versions have bugs. -->

**Use `Notion-Version: 2022-06-28` for ALL requests.** Known issues with newer versions:

- Database properties don't get created on POST
- data_source_id returns null
- Property updates silently succeed but don't apply

If Notion releases a fix, test thoroughly before switching.

## Database IDs

<!-- Replace these with YOUR database IDs. Find them in the URL when you open a database:
     https://notion.so/YOUR_WORKSPACE/DATABASE_ID?v=VIEW_ID
     The DATABASE_ID is the 32-char hex string. Format with dashes: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -->

| Database | ID | Notes |
|----------|-----|-------|
| Content | `YOUR-DATABASE-ID` | Posts, articles, etc. |
| Projects | `YOUR-DATABASE-ID` | Active projects |
| Notes | `YOUR-DATABASE-ID` | Quick notes |

## CRITICAL: Pages vs Databases

Some Notion "databases" are actually **pages**. Do NOT use page IDs with `/databases/` endpoints. Query page children via:

```bash
curl -s "https://api.notion.com/v1/blocks/PAGE_ID/children" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28"
```

If you get a 404 or unexpected response on a "database," check whether it's actually a page.

## Common Patterns

### Query a database

```bash
curl -s -X POST "https://api.notion.com/v1/databases/{DB_ID}/query" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{"filter": {"property": "Status", "select": {"equals": "Active"}}}'
```

### Create a page in a database

```bash
curl -s -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{
    "parent": {"database_id": "DB_ID_HERE"},
    "properties": {
      "Name": {"title": [{"text": {"content": "Title"}}]},
      "Status": {"select": {"name": "Active"}}
    }
  }'
```

### Add blocks to a page

```bash
curl -s -X PATCH "https://api.notion.com/v1/blocks/{PAGE_ID}/children" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{"children": [...]}'
```

Use `"after": "BLOCK_ID"` to insert after a specific block.

## JSON Parsing

**Always use Python for JSON parsing, NEVER jq.** jq fails on null values which Notion returns frequently.

```bash
curl -s ... | python3 -c "
import json, sys
data = json.load(sys.stdin)
# parse here
"
```

## Rate Limits

- ~3 requests/second average
- Add `sleep 0.4` between sequential API calls
- Batch operations where possible

## Property Types Quick Reference

- Title: `{"title": [{"text": {"content": "..."}}]}`
- Select: `{"select": {"name": "Option"}}`
- Multi-select: `{"multi_select": [{"name": "A"}, {"name": "B"}]}`
- Number: `{"number": 42}`
- Rich text: `{"rich_text": [{"text": {"content": "..."}}]}`
- Date: `{"date": {"start": "2026-01-15"}}`
- URL: `{"url": "https://..."}`
- Checkbox: `{"checkbox": true}`

## DO NOT

- Use newer API versions without testing (property bugs)
- Use jq for JSON parsing (null value crashes)
- Use page IDs as database IDs
- Forget to `source ~/.secrets.env` before API calls
- Make more than 3 requests/second
