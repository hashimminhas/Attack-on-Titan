# Attack on Titan - Battle Simulator

A Phoenix web application for managing Titans and Student Squads, and simulating tactical combat scenarios.

## Quick Start

```bash
mix setup          # Install dependencies and setup database
mix phx.server     # Start Phoenix server at http://localhost:4000
```

## Purpose

An **Attack on Titan-themed Battle Simulator** developed for an Agile Software Development project. Demonstrates proficiency in Agile practices, full-stack web development with Elixir/Phoenix, Test-Driven Development (TDD), database design, and complex business logic implementation.

## Features

### Titans Management
- **View all Titans**: [/titans](http://localhost:4000/titans)
- **Add new Titan**: [/titans/new](http://localhost:4000/titans/new)
- Fields: Name (unique), Power (0.01-100.00), Is Special (2.5x power multiplier)

### Student Squads Management
- **View all Squads**: [/student_squads](http://localhost:4000/student_squads)
- **Add new Squad**: [/student_squads/new](http://localhost:4000/student_squads/new)
- Fields: Name (unique), Members (1-8), Group (scout/garrison/police), Active status

### Battle Simulation
- **Simulate Attack**: [/simulate_attack](http://localhost:4000/simulate_attack)
- **Outcomes**: Victory (students win, titans deleted), Defeat (titans win, squads inactive), Pyrrhic Victory (equal power, both exhausted), Absolute Defeat (no active scouts), No Attack (no titans exist)

## Battle Logic

Power calculations determine outcomes:
- **Titan Power**: `Σ(power × (is_special ? 2.5 : 1.0))`
- **Student Power**: `Σ(num_members × group_weight)` where scout=20, garrison=15, police=1
- **Requirements**: At least one active scout squad needed, otherwise absolute defeat

## Tech Stack

### Backend
- **Phoenix 1.8.3** - Modern Elixir web framework
- **Elixir 1.15** - Functional programming on Erlang VM
- **Ecto 3.13** - Database wrapper and query language
- **PostgreSQL** - Primary database with constraint checking

### Frontend
- **Phoenix LiveView 1.1.0** - Real-time interactive experiences
- **HEEx Templates** - HTML-aware Elixir templating
- **Tailwind CSS v4** - Utility-first CSS with new `@import` syntax
- **daisyUI** - Tailwind component library
- **Heroicons** - SVG icon system
- **esbuild** - JavaScript bundler

### Testing & Development
- **White Bread 4.5** - BDD testing framework
- **Hound** - Browser automation (requires ChromeDriver)
- **ExUnit** - Built-in Elixir testing
- **Phoenix Live Dashboard** - Real-time debugging
- **Phoenix Live Reload** - Auto browser refresh

### Additional Tools
- **Req 0.5** - Modern HTTP client
- **Bandit 1.5** - Pure Elixir HTTP server
- **Telemetry** - Metrics and instrumentation
- **Swoosh 1.16** - Email composition

## Database Schema

### Titans Table
`id`, `name` (unique), `power` (float 0.01-100.00), `is_special` (boolean), `timestamps`

### Student Squads Table
`id`, `name` (unique), `num_members` (int 1-8), `group` (scout/garrison/police), `state` (boolean), `timestamps`

## Architecture

- **Context-based**: Business logic in bounded contexts (`AgileExam.Aot`)
- **Controller-based routing**: Traditional Phoenix controllers
- **Changeset validation**: Comprehensive constraint management
- **Transaction management**: Atomic battle simulations

## Development Commands

```bash
mix setup           # Complete project setup
mix precommit       # Run all checks (compile, format, test)
mix ecto.reset      # Drop and recreate database
mix test            # Run unit tests
mix white_bread.run # Run BDD tests (ChromeDriver on port 64426)
```

## Core Functionality

The application simulates tactical combat with:
- Two entities (Titans and Student Squads) with PostgreSQL persistence
- Power-based combat calculations with type multipliers
- Five battle outcomes based on power comparisons
- Squad type effectiveness (scouts most valuable, police least)
- Constraint validation and transactional integrity
