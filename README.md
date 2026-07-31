# TeamQuest ⚔️

D&D-style character sheets for software teams. Instead of a flat HR profile,
every teammate has an RPG **character**: a class (their job role), six
attributes, skills with proficiency tiers, XP, and a level. Teams map to real
projects ("parties"), and when work gets done — a task shipped, a bug slain, a
client demo survived — teammates earn XP that visibly grows their character.

See [PRD.md](PRD.md) for the full product spec. This README documents what is
**currently implemented** (the MVP skeleton).

## Tech stack

- **Rails 8** (Ruby 3.2.2) with Hotwire (Turbo + Stimulus) and import maps
- **SQLite** for the database (plus Solid Cache / Solid Queue / Solid Cable)
- **Puma** web server, Propshaft asset pipeline
- Rails 8 built-in authentication generator (`has_secure_password` + session records)

## Getting started

```bash
bundle install
bin/rails db:prepare   # creates the DB, runs migrations, and seeds the skill library
bin/rails server       # serves on http://localhost:3000
```

For live-reload development (with a CSS/JS watcher if configured), `bin/dev`
also works. Run the test suite with:

```bash
bin/rails test
```

## How the app works

### 1. Accounts & authentication

- Email + password sign-up at `/registration/new`; login at `/session/new`.
  Signing up logs you in immediately.
- Sessions are database-backed (a `Session` row per login), and password reset
  scaffolding lives under `/passwords`.
- Every page except sign-up, login, and password reset requires authentication.
  The root path (`/`) redirects unauthenticated visitors to login.

### 2. Character creation ("forge your character")

A `User` has exactly one `Character`. After signing up you're routed to
`/my_character/new` — the forge — where you:

- **Pick a name and avatar** (preset emoji avatar set).
- **Choose a class** — one primary class and an optional subclass, from:
  Artificer (Developer), Illusionist (Designer), Bard (PM), Sentinel (QA),
  Mechanist (Ops/DevOps), Oracle (Data/Analyst), Herald (Marketing/BizDev).
  Classes are flavor only — they never gate functionality.
- **Assign attributes by point-buy** — distribute **30 points** across six
  stats (STR Execution, INT Technical depth, WIS Judgment, DEX Adaptability,
  CHA Communication, CON Consistency), each rated 1–10 with a **cap of 8 at
  creation**. The model validates the budget so you can't max everything.
- **Pick starting skills** from the seeded org skill library (~45 skills in
  five categories: engineering, design, product, operations, communication),
  each with a self-assessed tier: Novice → Apprentice → Adept → Expert → Master.
- **Write a backstory** (optional free text, in-character encouraged).

You can edit all of these later at `/my_character/edit`. Character sheets are
viewable by any logged-in user: `/characters` lists everyone, and
`/characters/:id` shows a sheet with class, attributes, skills, XP, and level.

### 3. Parties (teams)

- Any member can create a team at `/teams/new` — name, description, and a
  crest emoji. **The creator automatically becomes the team's admin.**
- `/teams` lists active teams; a team page (`/teams/:id`) shows the party
  roster and the team's XP feed.
- You can join an open team directly via its **Join** button
  (`POST /teams/:id/join`), and one person can belong to multiple parties.
- Memberships are soft-deleted (`left_at` timestamp), so leaving a team never
  erases XP history.

### 4. Invite links

Each team has a permanent 24-character invite token, giving a shareable URL:

```
http://localhost:3000/invite/<token>
```

- Visiting a valid invite shows the team and an **Accept** button; accepting
  joins you to the party (re-activating your old membership if you'd left).
- If you don't have a character yet, the invite token is stashed in your
  session and you're sent to the forge first — after creating your character,
  the pending invite completes and you land in the team.
- Invalid or archived-team tokens redirect home with an error.

### 5. XP grants

The recognition loop. From a team page, any **member of that team** can grant
XP (`/teams/:id/xp_grants/new`):

1. Pick one or more recipients from the party roster (multi-recipient grants
   supported — reward the whole party for a milestone in one action).
2. Pick a category, each with a default XP amount you can override (1–100):

   | Category | Default XP |
   |---|---|
   | Task completed (small / medium / large) | 10 / 25 / 50 |
   | Milestone / release shipped | 100 |
   | Bug slain | 15 |
   | Helped a teammate | 10 |
   | Knowledge sharing | 30 |
   | Client praise | 40 |
   | Custom | 25 |

3. Add an optional note ("Shipped the payment refactor 🔥") and submit.

Rules enforced by the model:

- **You cannot grant XP to yourself.**
- Every grant needs at least one recipient, and amounts are capped at 100.
- Grants are recorded per-team and appear publicly in the team feed — social
  visibility is the audit mechanism.
- **XP is event-sourced**: `xp_total` on a character is a denormalized sum
  that's updated atomically with each grant and always recomputable from the
  grant log. Grants support voiding (`void!` reverses the XP), enabling
  future admin moderation.

### 6. Levels

XP is global per character (earned across all your teams; team pages show the
team-scoped amount). Levels derive from total XP using the curve
`XP to reach level n = 100 × n × (n−1) / 2`:

| Level | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|
| Total XP needed | 100 | 300 | 600 | 1,000 | 1,500 |

Early levels come fast (the hook); later ones take sustained effort. Levels
are cosmetic prestige — they never unlock permissions.

## Data model

```
User (auth) ──1:1── Character (game identity: class, attributes, backstory, xp_total)
                      ├── Membership ──► Team (role: admin|member, soft-deleted via left_at)
                      ├── CharacterSkill ──► Skill (seeded library, tier per character)
                      └── XpGrantRecipient ──► XpGrant (granter, team, category, amount, note, voided_at)
```

Character is deliberately separate from User so auth concerns and game
concerns stay decoupled.

## Project status

This is **Phase 1 (MVP)** of the [release plan](PRD.md#9-release-plan):
auth, character creation, character sheets, parties, invite links, and XP
grants with levels are working. Not yet built: achievements & titles,
peer-grant daily caps, skill search, level-up celebrations, notifications,
org multi-tenancy, and integrations — see the PRD for the roadmap.
