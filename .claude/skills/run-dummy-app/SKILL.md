---
name: run-dummy-app
description: Launch the test/dummy Rails app and click through its UI in headless Chrome (guest, user and admin sessions) to see a front-end change working - dates, live WebSocket updates, forms.
---

# Run and drive the dummy app

The dummy app in `test/dummy` is the only UI in this repo.
Its JS lives in `test/dummy/frontend` and is compiled into the committed bundle `test/dummy/app/assets/bundles/`.
`chromium-cli` and Node Playwright are not installed; drive Chrome with `selenium-webdriver` from the Gemfile instead.

## 1. Prerequisites

Redis on port 6380 (ActionCable, `test/dummy/config/cable.yml`):

```bash
nc -z localhost 6380 || docker compose up -d redis
```

After editing anything under `test/dummy/frontend`, rebuild the bundle (from the repo root) or the browser runs the old code:

```bash
npm run build
```

## 2. Start the server

Port 3000 is often taken by another local app - check before assuming it is the dummy app.
Use 3456.
macOS has no `timeout`, so poll with a loop:

```bash
cd test/dummy && (bin/rails server -p 3456 -b 127.0.0.1 > /tmp/dummy-server.log 2>&1 &)
for i in $(seq 1 40); do curl -sf -o /dev/null http://127.0.0.1:3456/articles && break; sleep 1; done
```

Stop it with `lsof -ti:3456 -sTCP:LISTEN | xargs kill`.

## 3. Accounts

- Admin: `admin@example.com` / `secret` (from `db/seeds.rb`; run `bin/rails db:seed` in `test/dummy` if missing).
- User: dev users' passwords are unknown, so create a throwaway confirmed one:

```bash
cd test/dummy && bin/rails runner 'u = User.find_or_initialize_by(email: "uitest@example.com"); u.assign_attributes(username: "uitest", password: "secret123", password_confirmation: "secret123", confirmed: true); u.save!'
```

## 4. Drive

Edit the steps at the bottom of [drive.rb](drive.rb), then from the repo root:

```bash
bundle exec ruby .claude/skills/run-dummy-app/drive.rb 2>&1 | grep -v 'warning:'
```

It prints each page's text and console errors and saves screenshots to `$TMPDIR/loco-dummy-drive/` (override with `OUT=`).
Look at the screenshots.
Use one browser per role (guest, user, admin) to watch live updates arrive over the WebSocket.

## Routes worth knowing

| Page | URL | Notes |
|---|---|---|
| Home / article list | `/` | published articles only |
| Public article + comment form | `/articles/:id` | 404 unless published |
| User articles | `/user`, `/user/articles/:id`, `/user/articles/:id/edit` | scoped to the signed-in user (404 otherwise) |
| New article | `/user/articles/new` | |
| Admin review | `/admin/articles/:id/edit` | `/admin/articles/:id` is JSON only (406) |
| Admin published list | `/admin/articles/published` | |

## Gotchas

- Creating an article stays on `/user/articles/new`; success shows on the submit button ("Article was successfully created.").
  Read the new id from the DB.
- Publish an article as its author with the "Publish" link (`#publish_article`) on `/user/articles/:id`.
- The bundle is a production build, so the webpack module cache is not reachable from the page.
  To inspect what the front end sends, wrap `window.fetch` or a DOM property with `execute_script`.
- Clean up test data afterwards.
  Destroying an article with comments fails, so delete comments first:

```bash
cd test/dummy && bin/rails runner 'u = User.find_by(email: "uitest@example.com"); ids = u.articles.pluck(:id); Comment.where(article_id: ids).delete_all; Article.where(id: ids).delete_all; u.reload.destroy!'
```
