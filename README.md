# Peanut Blog

A modern blog platform built with Ruby on Rails, featuring user authentication, post management, categories, and admin functionality. Built with Hotwire (Turbo + Stimulus) for a reactive single-page application experience.

## Features

- 📝 **Post Management** - Create, edit, and delete blog posts with rich content
- 👥 **User Authentication** - Secure user registration and login with bcrypt
- 🏷️ **Categories** - Organize posts with customizable categories
- 🔐 **Admin Panel** - Administrative controls for managing users and content
- 📄 **Pagination** - Browse posts efficiently with will_paginate
- 🎨 **Modern UI** - Bootstrap 5 with custom styling
- ⚡ **Real-time Updates** - Action Cable with Redis for live features

## Ruby Version

This application requires:
- **Ruby 3.3.6**

## System Dependencies

### Required Software

- **Ruby 3.3.6** - Programming language runtime
- **Node.js/Yarn** - For JavaScript dependencies and asset compilation
- **SQLite3** - Database for development and test environments
- **PostgreSQL** - Database for production environment
- **Redis** - Required for Action Cable (WebSocket functionality)

### Optional Tools

- **Foreman** or **Overmind** - For running multiple processes in development (recommended)

## Configuration

### 1. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies
yarn install
```

### 2. Environment Setup

The application uses different databases for development, test, and production:
- **Development/Test:** SQLite3
- **Production:** PostgreSQL

No additional environment variables are required for basic setup. For production deployment, ensure you configure:
- `DATABASE_URL` for PostgreSQL connection
- `REDIS_URL` for Action Cable
- `RAILS_MASTER_KEY` or `config/credentials.yml.enc` for secrets

## Database Creation

### Development Environment

```bash
# Create the database
rails db:create

# Run migrations
rails db:migrate

# Load seed data (optional)
rails db:seed
```

### Test Environment

```bash
# Create and migrate test database
RAILS_ENV=test rails db:create db:migrate
```

## Database Initialization

The application includes three main models:

- **Users** - User accounts with authentication (username, email, password)
- **Posts** - Blog posts with title and description
- **Categories** - Organizational categories for posts

To populate the database with sample data:

```bash
rails db:seed
```

## How to Run the Application

### Using Foreman (Recommended)

The application uses `Procfile.dev` to manage multiple processes:

```bash
# Install foreman if you haven't already
gem install foreman

# Option 1: Use the provided dev script (wrapper around foreman)
bin/dev

# Option 2: Run foreman directly
foreman start -f Procfile.dev
```

This will start:
- Rails server on `http://localhost:3000`
- CSS auto-compilation (Sass)
- JavaScript auto-bundling (esbuild)

### Manual Start

If you prefer to run processes separately:

```bash
# Terminal 1 - Rails server
rails server -p 3000

# Terminal 2 - CSS compilation
yarn build:css --watch

# Terminal 3 - JavaScript bundling
yarn build --watch
```

### Start Redis

Redis is required for Action Cable functionality:

```bash
# macOS with Homebrew
brew services start redis

# Linux
sudo systemctl start redis

# Or run in foreground
redis-server
```

## How to Run the Test Suite

The application uses Rails' default testing framework with Capybara for system tests.

### Run All Tests

```bash
# Run all tests
rails test

# Run all tests including system tests
rails test:all
```

### Run Specific Test Types

```bash
# Unit tests (models)
rails test:models

# Controller tests
rails test:controllers

# Integration tests
rails test:integration

# System tests (browser-based)
rails test:system
```

### Run Individual Test Files

```bash
rails test test/models/user_test.rb
rails test test/controllers/posts_controller_test.rb
```

## Services

### Redis

Redis is used for:
- **Action Cable** - WebSocket connections for real-time features
- **Caching** - Performance optimization (if enabled)

Ensure Redis is running before starting the application:

```bash
# Check if Redis is running
redis-cli ping
# Should return: PONG
```

### Background Jobs

The application uses Active Job (Rails' built-in job framework). In development, jobs run inline. For production, consider configuring:
- Sidekiq (requires Redis)
- Delayed Job
- Resque

### Asset Pipeline

Assets are managed using:
- **CSS:** Sass with cssbundling-rails
- **JavaScript:** esbuild with jsbundling-rails
- **Importmaps:** For JavaScript module management

## Deployment Instructions

### Prerequisites

1. **Production Database:** Set up PostgreSQL
2. **Redis Server:** Ensure Redis is available
3. **Secret Key:** Configure Rails credentials

### Deployment Steps

```bash
# 1. Install production dependencies
bundle install --without development test

# 2. Precompile assets
RAILS_ENV=production rails assets:precompile

# 3. Set up database
RAILS_ENV=production rails db:create db:migrate

# 4. Start the server
RAILS_ENV=production rails server
```

### Environment Variables

Set the following for production:

```bash
DATABASE_URL=postgresql://user:password@localhost/peanut_blog_production
REDIS_URL=redis://localhost:6379/0
RAILS_MASTER_KEY=<your_master_key>
RAILS_ENV=production
```

### Recommended Hosting Platforms

- **Heroku** - Easy deployment with buildpacks
- **Render** - Modern alternative to Heroku
- **Fly.io** - Global deployment
- **Railway** - Simple Rails hosting

### Production Checklist

- [ ] Configure production database (PostgreSQL)
- [ ] Set up Redis for Action Cable
- [ ] Configure credentials/secrets
- [ ] Enable SSL/HTTPS
- [ ] Set up regular database backups
- [ ] Configure logging and monitoring
- [ ] Review security settings (CORS, CSP, etc.)

## Additional Information

### Code Quality

The project includes:
- **Rubocop** - Ruby linter for code quality
- **Bootstrap 5** - Modern responsive UI framework
- **Hotwire Livereload** - Automatic browser refresh in development

### Development Commands

```bash
# Run Rubocop linter
bundle exec rubocop

# Rails console
rails console

# Database console
rails dbconsole

# View routes
rails routes
```

### Project Structure

```
app/
├── controllers/    # Request handlers
├── models/         # Data models (User, Post, Category)
├── views/          # HTML templates
├── javascript/     # Stimulus controllers
└── assets/         # Stylesheets and images

config/
├── database.yml    # Database configuration
├── routes.rb       # URL routing
└── cable.yml       # Action Cable configuration
```

## License

This project is available for educational and personal use.

## Support

For issues or questions, please open an issue on the project repository.
