# Roblox Tycoon

A classic tycoon-style game built on Roblox. Claim your own tycoon plot, buy equipment, generate income, and grow your fortune!

## Gameplay

- **Claim a Tycoon** — When you join, you're automatically assigned a free tycoon plot.
- **Buy a Dropper** — Touch the **Buy Dropper** button to purchase a machine that spawns MoneyCoin parts.
- **Collect Coins** — A conveyor moves the coins toward a collector. Touch the collector to claim the cash.
- **Upgrade Income** — After buying a dropper, you can upgrade your income multiplier to earn more per coin.
- **Progress Saves** — Your cash and income level are saved to Roblox DataStore, so you keep your progress between sessions.

## Project Structure

```
src/
├── ServerScriptService/
│   ├── LeaderstatsManager.server.luau   — Player data (cash, income level) & DataStore persistence
│   └── TycoonManager.server.luau         — Tycoon assignment, setup, and cleanup
├── ServerStorage/
│   └── Dropper/
│       └── DropperScript.server.luau     — MoneyCoin spawner (runs every 0.001s)
├── Workspace/
│   └── TycoonTemplate/                  — Template for each tycoon plot
│       ├── BuyDropperButton.script.luau  — Purchase dropper logic
│       ├── Collector.script.luau         — Collect coins & add to player's cash
│       ├── Conveyor.script.luau          — Push coins toward collector
│       ├── UpgradeIncomeButton.script.luau — Upgrade income multiplier
│       ├── PriceDisplay.UpdatePriceText.client.luau     — Show dropper price
│       └── UpgradePriceDisplay.UpdatePriceText.client.luau — Show upgrade price
└── StarterPlayer/
    └── PlayerScriptsLoader.client.luau   — Loads Roblox PlayerModule
```

## Tycoon Model Hierarchy

```
Tycoon (Model)
├── Owner (ObjectValue)          — Current owning player
├── IncomeMultiplier (NumberValue) — Income multiplier (1 = base, 101 = upgraded)
├── Floor (Part)                 — Base platform
├── DropperSpawnLocation (Part)  — Where the dropper spawns
├── BuyDropperButton (Part)      — Touch to buy dropper
│   └── Price (NumberValue)
├── Collector (Part)             — Touch to collect coins
├── Conveyor (Part)              — Moves coins toward collector
├── UpgradeIncomeButton (Part)   — Touch to upgrade (appears after buying dropper)
│   └── Price (NumberValue)
├── PriceDisplay (Part)          — Shows dropper price
│   └── SurfaceGui → SignFrame → PriceLabel
└── UpgradePriceDisplay (Part)   — Shows upgrade price
    └── SurfaceGui → SignFrame2 → PriceLabel2
```

## Setup

1. Open Roblox Studio
2. Create the tycoon model in Workspace.Tycoons
3. Place the scripts in their corresponding locations (matching the structure above)
4. Enable **Allow HTTP Requests** in Game Settings → Security (for DataStore)
5. Play!

## Known Issues

- **DropperScript** spawns coins every 0.001 seconds — this causes severe lag. Increase `task.wait()` to 1–2 seconds in production.
- **TycoonManager** has unreachable code at lines 74–87 (runs against undefined `tycoon` variable).
- Player removal doesn't fully reset the tycoon (buy buttons aren't restored).

## License

MIT
