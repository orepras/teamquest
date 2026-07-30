# PRD — TeamQuest
### D&D-style Character Sheets for Software Teams

| | |
|---|---|
| **Status** | Draft v0.1 |
| **Author** | Prasaja (with Claude) |
| **Date** | 2026-07-30 |
| **Product name** | "TeamQuest" (working title — see Open Questions) |

---

## 1. Overview

### 1.1 Summary
TeamQuest is a lightweight web app that turns each teammate's professional profile into an RPG-style **character sheet**. Instead of a flat HR profile, every person has a class (their job role), attributes, skills with proficiency levels, XP, and a level. Teams map to real projects. When work gets done — a task shipped, a bug slain, a client demo survived — teammates earn XP that visibly grows their character.

### 1.2 Problem statement
In a software house, individual growth and contribution are mostly invisible:

- Skill development happens but is never captured anywhere ("who here has actually done Terraform?").
- Recognition is ad-hoc — a Slack "nice work 🎉" that evaporates in a day.
- New joiners can't quickly see who's who on a project team and what each person is good at.
- Performance conversations rely on memory, not a record of accumulated contributions.

Existing tools don't fit: HR systems are formal and stale, project trackers (Jira/Linear) track *work* not *people*, and skill matrices in spreadsheets die within a month because updating them is a chore.

### 1.3 Product hypothesis
If updating your professional profile is **fun** (leveling up a character) instead of a chore (editing a spreadsheet row), people will actually keep it current — and the team gets an always-fresh, glanceable map of who can do what, plus a lightweight recognition loop.

### 1.4 Goals
1. Every team member has a living character sheet that reflects their real role, skills, and growth.
2. Granting recognition (XP) after completed work takes **under 15 seconds**.
3. Anyone can answer "who on this project knows X?" in one glance.
4. The product is fun enough that people open it without being told to.

### 1.5 Non-goals (v1)
- ❌ Not a performance review / appraisal tool. XP must never directly feed compensation decisions (see Risks §10).
- ❌ Not a project management tool. No task boards, no sprints — tasks live in your existing tracker; TeamQuest only records the *reward*.
- ❌ Not an HRIS. No leave, payroll, or org-chart management.
- ❌ No real-money or monetary rewards tied to XP in v1.
- ❌ No public profiles / cross-company visibility.

---

## 2. Target users & personas

| Persona | Role in product | Key need |
|---|---|---|
| **Rana — Developer (IC)** | Player | Wants her skill growth to be visible; enjoys the RPG framing; wants receiving recognition to feel good. |
| **Bimo — Project Manager** | Party Leader (team admin) | Wants a quick view of team capability and an easy way to reward completed work; wants onboarding new members to a project to be fast. |
| **Sari — Ops / Studio Lead** | Guild Master (org admin) | Wants a bird's-eye view across all project teams; manages roles, XP rules, and who can create teams. |
| **Dimas — New joiner** | Player | Day one: wants to know who's on his team, who to ask about what. |

**Primary market:** small–medium software houses / agencies (5–100 people), where one person is usually on 1–3 project teams at once.

---

## 3. Core concepts & game design

This is the heart of the product. The mapping from corporate reality → RPG mechanics:

| RPG concept | Corporate reality |
|---|---|
| Character | A person's profile (one character per user account) |
| Class | Job role: Developer, Designer, PM, QA, Ops/DevOps, Data, Marketing, Account/BizDev |
| Party / Guild | A team = one project (e.g. "Project Phoenix — Acme mobile app") |
| Attributes | Six core stats rated 1–10 (see §3.2) |
| Skills | Concrete competencies (React, Figma, client comms…) with proficiency tiers |
| XP & Level | Earned through completed work and contributions |
| Quests | Real tasks/milestones (referenced, not managed, in-app) |
| Achievements / Badges | Milestone recognitions ("First Deploy", "Bug Slayer ×50") |
| Titles | Cosmetic honorifics unlocked by level or achievement |

### 3.1 Classes
Each class has a name, an icon, and a flavor text. Classes are **org-configurable**, but ship with defaults:

| Class | Flavor |
|---|---|
| 🛠 Artificer (Developer) | Builds the machinery that makes everything run |
| 🎨 Illusionist (Designer) | Shapes what users see and feel |
| 📜 Bard (Project Manager) | Keeps the party aligned, negotiates with clients |
| 🛡 Sentinel (QA) | Guards the gates against bugs |
| ⚙️ Mechanist (Ops/DevOps) | Keeps the realm's infrastructure alive |
| 🔮 Oracle (Data/Analyst) | Reads the signs and predicts the future |
| 🗣 Herald (Marketing/BizDev) | Spreads word of the guild's deeds |

- A character has **one primary class** and optionally **one subclass** (e.g. Artificer / Illusionist for a design-engineer).
- Class is descriptive flavor — it does **not** gate any functionality.

### 3.2 Attributes
Six stats, rated 1–10, self-assessed at character creation and adjustable by the user (peer endorsement is a future idea, §11):

| Attribute | Meaning at work |
|---|---|
| **STR — Execution** | Shipping power; gets things done |
| **INT — Technical depth** | Domain/craft expertise |
| **WIS — Judgment** | Decision quality, prioritization, seeing traps ahead |
| **DEX — Adaptability** | Context-switching, learning speed, handling chaos |
| **CHA — Communication** | Writing, presenting, client-facing skill |
| **CON — Consistency** | Reliability, follow-through, stamina on long projects |

Attributes are **self-declared flavor**, not computed from XP in v1. They make the sheet feel personal and D&D-authentic; keeping them self-assessed avoids the tool becoming surveillance.

### 3.3 Skills
- A skill = a named competency with a proficiency tier: **Novice → Apprentice → Adept → Expert → Master**.
- Skills come from an **org-level skill library** (seeded with common ones: React, Node.js, Figma, copywriting, client communication, CI/CD, …). Users can request/add new skills (org admin can curate to prevent duplicates like "JS" vs "JavaScript").
- Each character lists their skills with tier. Skill tiers are self-assessed in v1, but each XP grant can **tag skills**, so a skill accumulates its own XP counter — giving evidence ("Rina: Figma — Adept, 1,240 XP across 31 quests").

### 3.4 XP & Leveling
- **XP is per-character and global** (not per-team): your character grows across all projects you're part of. Team pages show a filtered view of XP earned within that team.
- Level curve: standard escalating curve, e.g. `XP to reach level n = 100 × n × (n−1) / 2` (L2=100, L3=300, L4=600, L5=1000, …). Exact curve tunable; requirement is: early levels come fast (hook), later levels take sustained effort.
- **Levels are cosmetic prestige** — they unlock titles and badge frames, never permissions.

**XP sources (v1):**

| Event | Who grants | Suggested XP |
|---|---|---|
| Task completed (small / medium / large) | Team admin or peer | 10 / 25 / 50 |
| Milestone / release shipped | Team admin | 100 (whole party) |
| Bug fixed in production | Team admin or peer | 15 |
| Helping a teammate (assist) | Any peer | 10 |
| Knowledge sharing (demo, write-up, brown bag) | Team admin | 30 |
| Client praise received | Team admin | 40 |
| Custom event | Team admin | free-form 5–100 |

Every grant records: recipient(s), granter, XP amount, category, optional note ("Shipped the payment refactor 🔥"), optional skill tags, timestamp, team context.

**Anti-abuse guardrails (v1, keep simple):**
- Peers can grant max **50 XP per day** total; team admins max 500/day.
- You cannot grant XP to yourself.
- All grants are public in the team feed — social visibility is the main audit mechanism.
- Org admin can void any grant.

### 3.5 Achievements & Titles
Ship with a starter set; org admins can add custom ones later:

- **First Blood** — first XP earned
- **Level 5 / 10 / 20** — level milestones with titles ("Journeyman", "Veteran", "Legend")
- **Bug Slayer** — 10 bug-fix XP events
- **Party Animal** — member of 3+ teams
- **Mentor** — 10 assist grants received (given by you)
- **Full House** — earned XP in 5 different categories
- **Streak** — earned XP in 4 consecutive weeks

Achievements appear on the character sheet as badges. Titles are selectable — the user picks which unlocked title displays under their name.

---

## 4. User flows

### 4.1 First-time flow
```
Sign up / Log in
   └─► No character yet? ──► Character Creation (§4.2)
   └─► Has character ────► Home: team picker + own sheet
        └─► Join a team (browse/search or via invite link)
        └─► Create a team (if permitted)
```

### 4.2 Character creation (the magic moment — must feel like a game)
Step-by-step wizard, heavy on flavor:
1. **Name & avatar** — display name, pick avatar (preset fantasy-style avatar set in v1; upload later).
2. **Choose your class** — card-based picker with class art + flavor text; optional subclass.
3. **Assign attributes** — point-buy: distribute e.g. 30 points across the 6 stats (cap 8 at creation) — point-buy forces tradeoffs and prevents everyone being 10/10/10/10/10/10.
4. **Pick starting skills** — choose from library, set tiers.
5. **Backstory** (optional) — short free-text bio, in-character encouraged ("Forged in the fires of a 2-year enterprise Java migration…").
6. **Sheet reveal** — animated presentation of the completed character sheet. Shareable moment.

Target completion time: **< 5 minutes**.

### 4.3 Everyday loops
- **The Player loop:** open app → see own sheet / recent XP received → check team feed → (occasionally) grant an assist to a teammate.
- **The Party Leader loop:** task done in real tracker → open team page → "Grant XP" → pick member(s), category, note → done in <15s. Weekly: milestone grant to whole party.
- **The lookup loop:** "who knows Flutter?" → team roster or org-wide skill search → see characters with that skill, sorted by tier/XP.

### 4.4 Team (party) flows
- **Create team:** name, project description, banner/crest picker. Creator becomes team admin.
- **Join team:** via invite link, or browse org's team directory and request to join (admin approves).
- **Team page:** party roster (mini sheet cards), team XP feed, team stats (total XP, level distribution, skill coverage matrix).

---

## 5. Feature requirements

Priority: **P0** = MVP must-have, **P1** = fast-follow, **P2** = later.

### 5.1 Auth & accounts
| ID | Requirement | Priority |
|---|---|---|
| A1 | Email + password sign-up/login | P0 |
| A2 | Google OAuth login | P1 |
| A3 | Organization = top-level tenant; users belong to exactly one org; join via org invite link | P0 |
| A4 | Roles: Org Admin, Team Admin (per team), Member | P0 |
| A5 | Password reset via email | P0 |

### 5.2 Character sheet
| ID | Requirement | Priority |
|---|---|---|
| C1 | Creation wizard per §4.2 (class, attributes point-buy, skills, backstory) | P0 |
| C2 | Sheet view: avatar, name, title, class/subclass, level + XP progress bar, attributes (radar or bar display), skill list with tiers, badges, recent XP log | P0 |
| C3 | Edit own sheet (all self-declared fields) anytime | P0 |
| C4 | View any teammate's sheet (read-only) within your org | P0 |
| C5 | Per-team XP breakdown on sheet ("Project Phoenix: 850 XP") | P1 |
| C6 | Printable / shareable sheet image ("character card" export) | P2 |
| C7 | Avatar upload / generated avatars | P2 |

### 5.3 Teams
| ID | Requirement | Priority |
|---|---|---|
| T1 | Create team (name, description, crest); creator = team admin | P0 |
| T2 | Invite to team via link; request-to-join from directory | P0 |
| T3 | Team page: roster of member cards, team XP feed | P0 |
| T4 | A user can belong to multiple teams | P0 |
| T5 | Team skill-coverage matrix (skills × members grid) | P1 |
| T6 | Archive team when project ends (sheet history preserved) | P1 |
| T7 | Team-level stats & charts (XP over time, category breakdown) | P2 |

### 5.4 XP & gamification
| ID | Requirement | Priority |
|---|---|---|
| X1 | Grant XP: pick member(s) → category → amount (from category default, editable within bounds) → note → optional skill tags | P0 |
| X2 | Multi-recipient grant (whole party or subset) in one action | P0 |
| X3 | XP feed per team (public within team), org-wide activity feed | P0 |
| X4 | Level computation + level-up moment (celebration animation, feed entry) | P0 |
| X5 | Peer grants with daily caps per §3.4 | P1 (v1 can be admin-grant only) |
| X6 | Achievements engine (starter set §3.5) | P1 |
| X7 | Selectable titles | P1 |
| X8 | Org admin: void a grant, adjust XP category defaults & caps | P1 |
| X9 | Leaderboards (see Risks — opt-in, team-scoped, time-boxed "this month" only) | P2 |
| X10 | Custom org achievements | P2 |
| X11 | Webhook/integration: auto-XP from Jira/Linear/GitHub events | P2 |

### 5.5 Discovery
| ID | Requirement | Priority |
|---|---|---|
| D1 | Org member directory with class/skill filters | P1 |
| D2 | Skill search: "who has skill X" ranked by tier + skill XP | P1 |

### 5.6 Notifications
| ID | Requirement | Priority |
|---|---|---|
| N1 | In-app notification when you receive XP / achievement / level-up | P0 |
| N2 | Email digest (weekly summary of your gains + team highlights) | P2 |
| N3 | Slack integration (XP grants posted to team channel) | P2 |

---

## 6. Information architecture & data model (sketch)

```
Organization
 ├── User (auth identity, org role)
 │     └── Character (1:1 with User)
 │           ├── class, subclass, attributes{6}, backstory, avatar, title
 │           ├── CharacterSkill (skill_id, tier, skill_xp)
 │           ├── xp_total (denormalized), level (derived)
 │           └── AchievementUnlock[]
 ├── Team (project)
 │     ├── TeamMembership (user_id, team_role: admin|member, joined_at, left_at)
 │     └── XPGrant (granter_id, team_id, category, amount, note, created_at, voided_at?)
 │           └── XPGrantRecipient (character_id, skill_tags[])
 ├── Skill (org library: name, category, aliases)
 └── Achievement (org library: rule definition)
```

Key decisions:
- **XP is event-sourced**: `xp_total` is always recomputable from the grant log — enables voiding, auditing, and future rule changes.
- Character is separate from User so auth concerns and game concerns stay decoupled.
- `left_at` on membership: leaving a team never deletes earned XP.

---

## 7. UX principles

1. **Sheet first.** The character sheet is the product's face — it should look like a lovingly designed game artifact (parchment/fantasy or clean-modern theme, TBD), not a CRUD form.
2. **Granting XP is the most frequent admin action** — it must be reachable in ≤2 clicks from the team page and completable in <15 seconds.
3. **Celebrate loudly, log quietly.** Level-ups and achievements get animation and feed fanfare; everything else stays calm.
4. **Flavor is skippable.** All fantasy flavor (backstory, class names) is optional or renameable — some orgs/people will want it toned down. Corporate-safe class names available as a display toggle ("Artificer" ↔ "Developer").
5. **Responsive web** — desktop-first layout, fully usable on mobile (checking sheets and granting XP happen in hallways).

---

## 8. Success metrics

| Metric | Target (3 months post-launch, per active org) |
|---|---|
| Character creation completion rate (started → finished wizard) | ≥ 85% |
| % of org members with a character | ≥ 90% |
| Weekly active grant rate (≥1 XP grant per team per week) | ≥ 80% of active teams |
| Median time to complete an XP grant | < 15 s |
| WAU / registered users | ≥ 50% |
| Sheet edits per user per month (proxy for "profile stays fresh") | ≥ 1 |

Counter-metric to watch: XP inflation (median weekly XP per user drifting up over time without corresponding activity) — signals the recognition losing meaning.

---

## 9. Release plan

### Phase 1 — MVP (all P0s)
Auth + org, character creation wizard, character sheets, teams (create/join/roster/feed), admin XP grants with categories & notes, levels + level-up celebration, in-app notifications.
**MVP litmus test:** one real team uses it for 2 sprints and grants XP without being reminded.

### Phase 2 — Social & depth (P1s)
Peer grants + caps, achievements & titles, skill search/directory, team skill matrix, per-team XP breakdown, grant voiding & org config, Google OAuth.

### Phase 3 — Reach (P2s)
Tracker integrations (auto-XP from Jira/Linear/GitHub), Slack notifications, monthly team-scoped leaderboards, custom achievements, sheet image export, email digests.

---

## 10. Risks & mitigations

| Risk | Mitigation |
|---|---|
| **Gamification backfires** — XP becomes a metric people game, or feels like surveillance | XP never feeds permissions or (by policy) performance reviews; grants are public; caps limit farming; attributes stay self-assessed. State this explicitly in onboarding copy. |
| **Leaderboard toxicity** — ranking humans breeds resentment | Leaderboards deferred to P2, and then only opt-in per team, time-boxed monthly, celebrating "most improved" style categories rather than raw totals. |
| **Novelty cliff** — fun for 3 weeks, then abandoned | The retention anchor is *utility* (skill lookup, living team roster), not just fun. Achievements/streaks add mid-term hooks; integrations (Phase 3) remove manual effort. |
| **Grant fatigue for team admins** | Multi-recipient grants, category defaults, <15s flow; Phase 3 auto-XP from trackers. |
| **Cringe factor** — fantasy flavor alienates some users | Flavor toggle (§7.4); backstory optional; professional display mode. |
| **Skill library rot** — duplicates and junk skills | Org-admin curation + alias merging (D1/D2 era). |

## 11. Future ideas (explicitly out of scope, parked)
- Peer endorsement of attributes/skills (LinkedIn-style, but weighted)
- Quests-as-objects: post a bounty task in-app, claim it, complete for XP
- Character art generation / cosmetic unlock shop (spend earned "gold")
- Cross-org public profile ("adventurer's license") for portfolios
- Season resets / prestige system
- Manager analytics dashboards (⚠️ tension with the anti-surveillance stance — needs careful thought)

## 12. Open questions
1. **Product name** — "TeamQuest" is a placeholder. Alternatives: Guildhall, PartySheet, WorkForge, Fellowship.
2. **Multi-org users?** v1 assumes one org per account. Freelancers may need more — accept the limitation?
3. **Who can create teams?** Any member, or org-admin-gated? (Draft assumption: any member; org admin can restrict via a setting.)
4. **Can XP be granted retroactively / backdated?** Draft: no, keep the log honest.
5. **Theming direction** — full fantasy skin vs. clean modern UI with fantasy accents? (Affects design effort significantly.)
6. **Self-hosted or SaaS-only?** Software houses sometimes insist on self-hosting.
