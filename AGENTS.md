# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project overview
- Framework: Ruby on Rails 7 (Ruby 3.3.6), Minitest.
- Database: SQLite for development/test; PostgreSQL in production (see `Gemfile`).
- Frontend: Hotwire (Turbo + Stimulus), Bootstrap, and a hybrid asset setup:
  - JS bundling via `jsbundling-rails` with esbuild. Entrypoint: `app/javascript/application.js` → bundles to `app/assets/builds` (exposed via `app/assets/config/manifest.js`).
  - Importmap is present and pins Stimulus controllers (`config/importmap.rb`, `pin_all_from app/javascript/controllers`).
  - CSS via `cssbundling-rails` using Sass (built into `app/assets/builds/application.css`).
  - Live reload via `hotwire-livereload` (see `config/environments/development.rb`).
- Domain model (high level):
  - Users authenticate via `has_secure_password`. Posts belong to Users. Categories exist as a separate resource. Pagination uses `will_paginate`.
- Routing highlights: `root "pages#index"`; standard RESTful routes for `posts`, `users`; `categories` except destroy; session routes at `/login` and `/logout`.

## Commands you’ll use most
Setup
- Install Ruby gems and prepare DB: `bin/setup`
- Install JS deps: `yarn install`

Run locally (with live reload and asset watchers)
- All-in-one dev process (Rails + JS/CSS watchers): `bin/dev`
  - Uses Foreman with `Procfile.dev` to run: Rails server on port 3000, `yarn build --watch`, and `yarn build:css --watch`.

Build assets (on demand)
- JS bundle: `yarn build`
- CSS bundle: `yarn build:css`

Database
- Create/migrate/prepare: `bin/rails db:prepare`
- Migrate only: `bin/rails db:migrate`
- Drop & recreate (local): `bin/rails db:reset`

Tests (Minitest)
- Run entire test suite: `bin/rails test`
- Run a folder: `bin/rails test test/controllers`
- Run a single file: `bin/rails test test/models/category_test.rb`
- Run a single test by line: `bin/rails test test/integration/create_category_test.rb:12`
- System tests only: `bin/rails test test/system`

Other handy
- Rails console: `bin/rails console`
- Rails server (without asset watchers): `bin/rails server -p 3000`

## Architecture and code layout (big picture)
- Controllers coordinate auth and authorization:
  - `ApplicationController` exposes `current_user`, `logged_in?`, and `require_user` for gating actions.
  - Admin-only actions (e.g., creating Categories) are enforced via a `before_action` check.
- Views and partials:
  - Layouts and shared partials under `app/views/layouts` and `app/views/shared` provide site-wide chrome (navigation, flash messages) and error rendering.
- Pagination:
  - User and Post listing actions paginate via `will_paginate` (e.g., 5-per-page behavior).
- Frontend pipeline:
  - JS: author changes in `app/javascript/application.js` (imports Turbo, Stimulus controllers via `./controllers`, and Bootstrap). esbuild outputs to `app/assets/builds` with a public path of `assets/`.
  - Stimulus controllers live in `app/javascript/controllers` and are pinned via Importmap. If you add controllers, ensure they’re importable by the bundler or pinned by Importmap (consistent usage is recommended when extending the JS layer).
  - CSS: Sass builds `app/assets/stylesheets/application.bootstrap.scss` to `app/assets/builds/application.css` using the `build:css` script.
  - Sprockets serves built artifacts via the manifest in `app/assets/config/manifest.js`.
- Dev experience:
  - `bin/dev` auto-installs Foreman if necessary and orchestrates Rails + asset watchers + live reload. Live reload watches views, JS, and build outputs (see `config/environments/development.rb`).

## Notes for future changes
- When adding JS libraries, prefer adding them to `package.json` and importing from `app/javascript/application.js` so esbuild bundles them. Keep Importmap vs bundler usage consistent to avoid duplicate loads.
- For new resource pages, follow existing RESTful patterns in controllers (`before_action` usage for auth and ownership) and add pagination where listing.
