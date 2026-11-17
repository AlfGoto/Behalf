# <Project> — Domain glossary

<One line: what the product does, in the domain's words.>

One term per concept. Agents use these words in code, docs, issues and UI text, and never the `_Avoid_` ones.

## <Area, e.g. Accounts>

**Workspace** — The space a customer pays for. Holds Projects and Members. One plan per Workspace.
_Avoid_: Team, Organization, Account

**Member** — A person with access to a Workspace. Has one Role.
_Avoid_: User (too vague), Seat

## <Another area, e.g. Billing>

**Plan** — What a Workspace pays for: Free, Pro, Business. Sets the limits.
_Avoid_: Tier, Subscription (a Subscription is the payment record, not the Plan)

**Published Item** — An item visible to the public. Limits count Published Items, not all items.
_Avoid_: Live item, Active item
