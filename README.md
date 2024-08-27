# Github Profiles

![CI](https://github.com/caiodsc/github_profiles/actions/workflows/main.yml/badge.svg)
![Coverage Badge](https://img.shields.io/badge/Coverage-100%25-brightgreen)

Github Profiles Challenge.

# Configuration

## Prerequisites

1. [Git](https://git-scm.com/)
2. [asdf](https://asdf-vm.com/) (version manager)

## Project Setup

**1. Clone the Repository**

```bash
git clone https://github.com/caiodsc/github_profiles.git
cd github_profiles
```

**2. Install Ruby with asdf**

```bash
asdf install
```

**3. Install Dependencies**

```bash
gem install bundler
bundle install
```

**4. Configure PostgreSQL**

Edit the `config/database.yml` file.

Replace the `POSTGRES_USER`, `POSTGRES_PASSWORD` and the `DB_HOST` with your actual PostgreSQL credentials.

**5. Create the Database**

```bash
rails db:create
```

**6. Run Migrations**

```bash
rails db:migrate
```

# Quick Start

## Running Tests

Execute the test suite with RSpec:

```bash
rspec
```

After running your tests, open coverage/index.html in the browser of your choice. For example, in a Mac terminal, run the following command from your application's root directory:

```bash
open coverage/index.html
```

In a Debian/Ubuntu terminal:

```bash
xdg-open coverage/index.html
```



## Running RuboCop

Run RuboCop to check for code quality and style issues:

```bash
rubocop
```

## Running the Server

Run the server with the following command:

```bash
bin/dev
```

Once the server is running, access the site at [localhost:3000](http://localhost:3000).
