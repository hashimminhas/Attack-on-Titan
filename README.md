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

---

## Project Overview

### Purpose

This project is an **Attack on Titan-themed Battle Simulator** developed as part of an Agile Software Development exam/project. The application simulates tactical combat scenarios between Titans and Student Squads, inspired by the popular manga and anime series "Attack on Titan" (進撃の巨人).

The primary goal is to demonstrate proficiency in:
- **Agile development practices** and rapid iteration
- **Full-stack web development** using modern Elixir/Phoenix patterns
- **Test-Driven Development (TDD)** with both unit and BDD testing
- **Database design** and constraint management
- **Form validation** and user input handling
- **Business logic implementation** with complex rule systems

### Core Functionality

The application manages two main entities (Titans and Student Squads) and simulates battle outcomes based on:
- **Power Calculations**: Titans have raw power (0.01-100.00) with special titans receiving a 2.5x multiplier
- **Squad Effectiveness**: Different squad types (scout, garrison, police) have varying combat weights (20, 15, 1 respectively)
- **Battle Rules**: Five possible outcomes based on power comparisons and squad availability
- **Data Persistence**: All entities are stored in PostgreSQL with proper constraints and validations

---

## Tech Stack

### Backend Framework
- **Phoenix 1.8.3** - Modern web framework for Elixir, using the latest patterns without Phoenix.View
- **Elixir ~> 1.15** - Functional programming language built on the Erlang VM
- **Ecto 3.13** - Database wrapper and query language for Elixir
- **PostgreSQL** - Primary database with advanced constraint checking

### Frontend Technologies
- **Phoenix HTML 4.1** - Server-rendered HTML templates
- **Phoenix LiveView 1.1.0** - Real-time, interactive web experiences
- **HEEx Templates** - HTML-aware Elixir templating with `.html.heex` extension
- **Tailwind CSS v4** - Utility-first CSS framework using the new `@import` syntax
- **daisyUI** - Tailwind CSS component library for enhanced UI components
- **Heroicons** - Beautiful hand-crafted SVG icons via Tailwind plugin
- **esbuild** - Fast JavaScript bundler for modern web apps
- **topbar** - Progress bar for page loading states

### Development & Testing Tools
- **Phoenix Live Dashboard** - Real-time performance and debugging dashboard
- **Phoenix Live Reload** - Automatic browser refresh during development
- **White Bread 4.5** - Behavior-Driven Development (BDD) testing framework
- **Gherkin** - Feature file syntax for BDD scenarios
- **Hound** - Browser automation for integration testing (requires ChromeDriver)
- **LazyHTML** - HTML parsing and testing utilities for Phoenix
- **ExUnit** - Built-in Elixir testing framework

### Additional Libraries
- **Req 0.5** - Modern HTTP client for Elixir (preferred over HTTPoison/Tesla)
- **Swoosh 1.16** - Email composition and delivery
- **Bandit 1.5** - Pure Elixir HTTP server
- **Telemetry** - Dynamic dispatching library for metrics and instrumentation
- **Gettext** - Internationalization and localization
- **Jason** - JSON parser and generator
- **DNS Cluster** - Distributed Erlang node discovery

### Database Schema

**Titans Table:**
- `id` (primary key)
- `name` (string, unique)
- `power` (float, 0.01-100.00)
- `is_special` (boolean, default: false)
- `inserted_at`, `updated_at` (timestamps)

**Student Squads Table:**
- `id` (primary key)
- `name` (string, unique)
- `num_members` (integer, 1-8)
- `group` (string, enum: scout/garrison/police)
- `state` (boolean, default: true for active)
- `inserted_at`, `updated_at` (timestamps)

### Architecture Patterns

- **Context-based architecture**: Business logic organized in bounded contexts (`AgileExam.Aot`)
- **Controller-based routing**: Traditional Phoenix controllers (no LiveView for CRUD operations)
- **Changeset validation**: Comprehensive validation including custom constraint requirements
- **Transaction management**: Atomic operations for battle simulations
- **Mix aliases**: Custom commands like `mix setup` and `mix precommit` for streamlined workflows

### Development Workflow

The project includes several Mix aliases for efficient development:
- `mix setup` - Complete project setup (deps, database, assets)
- `mix precommit` - Run all checks before committing (compile, format, test)
- `mix ecto.reset` - Drop and recreate the database
- `mix test` - Run unit tests
- `mix white_bread.run` - Run BDD feature tests

---

## Battle Simulation Logic

The attack simulation implements complex business rules:

1. **No Titans Check**: If no titans exist, attack cannot occur
2. **Scout Requirement**: At least one active scout squad must exist, or absolute defeat occurs
3. **Power Calculation**:
   - Titan Power: `Σ(power * (is_special ? 2.5 : 1.0))`
   - Student Power: `Σ(num_members * group_weight)` where scouts=20, garrison=15, police=1
4. **Outcome Determination**:
   - Titan Power > Student Power → Defeat (all squads deactivated)
   - Powers Equal → Pyrrhic Victory (titans deleted, squads deactivated)
   - Student Power > Titan Power → Victory (titans deleted)

---

## Project Structure

```
lib/
├── agile_exam/              # Business logic context
│   ├── aot.ex               # Main context module with CRUD and simulation
│   └── aot/
│       ├── titan.ex         # Titan schema and changeset
│       └── student_squad.ex # Student squad schema and changeset
├── agile_exam_web/          # Web interface layer
│   ├── router.ex            # Route definitions
│   ├── controllers/         # HTTP request handlers
│   └── components/          # Reusable UI components
test/                        # Unit tests
features/                    # BDD feature files
priv/repo/migrations/        # Database migrations
assets/                      # Frontend assets (JS, CSS)
```
