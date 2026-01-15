# Attack on Titan - Battle Simulator

A Phoenix web application that allows you to manage Titans and Student Squads, and simulate attacks on the walls.

## Getting Started

1. Install dependencies and setup database:
   ```bash
   mix setup
   ```

2. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

3. Visit [http://localhost:4000](http://localhost:4000) in your browser.

---

## Application Features

### Titans Management

| Action | URL |
|--------|-----|
| View all Titans | [http://localhost:4000/titans](http://localhost:4000/titans) |
| Add a new Titan | [http://localhost:4000/titans/new](http://localhost:4000/titans/new) |

**Titan Fields:**
- **Name** - Unique identifier for the titan
- **Power** - Float between 0.01 and 100.00
- **Is Special** - Checkbox (special titans have 2.5x power multiplier)

---

### Student Squads Management

| Action | URL |
|--------|-----|
| View all Squads | [http://localhost:4000/student_squads](http://localhost:4000/student_squads) |
| Add a new Squad | [http://localhost:4000/student_squads/new](http://localhost:4000/student_squads/new) |

**Student Squad Fields:**
- **Name** - Unique identifier for the squad
- **Number of Members** - Integer between 1 and 8
- **Group** - One of: `scout`, `garrison`, or `police`
- **Active** - Checkbox indicating if the squad is active

---

### Simulate Attack

| Action | URL |
|--------|-----|
| Simulate Attack | [http://localhost:4000/simulate_attack](http://localhost:4000/simulate_attack) |

Click the **"simulate"** button to run the battle simulation.

**Possible Outcomes:**
- **Victory** - Students overpower titans → Titans are deleted
- **Defeat** - Titans overpower students → All squads become inactive
- **Pyrrhic Victory** - Equal power → Titans deleted AND all squads inactive
- **Absolute Defeat** - No active scouts available → All squads inactive
- **No Attack** - No titans in database → Attack cannot happen

---

## Running Tests

```bash
# Run all unit tests
mix test

# Run BDD tests (requires ChromeDriver on port 64426)
mix white_bread.run
```
