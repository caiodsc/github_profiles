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

After running your tests, open `coverage/index.html` in the browser of your choice. For example, in a Mac terminal, run the following command from your application's root directory:

```bash
open coverage/index.html
```

In a Debian/Ubuntu terminal:

```bash
xdg-open coverage/index.html
```
Results:

![Captura de tela de 2024-08-26 23-19-07](https://github.com/user-attachments/assets/43a83b7e-1ccc-48e0-9684-1fa839b98935)


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

# Technical Details

## Key Technologies Used:

- **Tailwind CSS** - I utilized Tailwind CSS for the project's styling, as it offers a quick and efficient way to create modern and responsive layouts.

- **Stimulus** - I created a Stimulus controller to manage the CSS classes for the different processing states, such as processing, processed, etc. I believe this is a better solution than using decorators, as Stimulus is built into Rails and integrates seamlessly with the framework. A potential improvement here would be to have the controller manage all states at once, rather than having a separate controller for each state.

- **Active Job** - I used Active Job to handle the asynchronous scraping of profiles. One improvement would be to integrate Sidekiq and Redis, which would provide a more robust solution with features like retries and better job management. Sidekiq is more robust because it offers enhanced performance, better concurrency handling, and a built-in retry mechanism, making it ideal for production environments where reliability and efficiency are critical.

- **State Machine** - I implemented a state machine to manage the user's status, transitioning between pending, processing, processed, and failed. I consider this a best practice because it provides a clear and structured way to handle complex state transitions, ensuring that the system's logic remains consistent and predictable, especially when dealing with asynchronous operations and multiple state changes.

## URL Shortening

I implemented a secure URL shortening solution where the GitHub URL is stored in the database using [ActiveRecord's encryption](https://guides.rubyonrails.org/active_record_encryption.html) feature. ActiveRecord's encryption feature allows sensitive data, like URLs, to be securely stored in the database by encrypting it, which adds a layer of protection against unauthorized access. This ensures that even if the database is compromised, the actual URLs remain hidden and secure.

![Captura de tela de 2024-08-26 23-41-48](https://github.com/user-attachments/assets/bdb0daac-51d0-4c94-af44-4e944c19c471)


To manage the shortened URLs, I created a module named `ShortCode`. The approach involves generating a unique identifier for each user that differs from the standard id field in the database. This unique identifier is created using a stored generated column in PostgreSQL:

```ruby
add_column :users, :unique_identifier, :bigint, as: "('1' || LPAD(id::varchar, 5, '0') || '0')::bigint", stored: true
```

This unique identifier is then encoded using the `ShortCode` module, which converts it into a shorter, alphanumeric string that is displayed to users as the shortened URL. When someone clicks on this shortened URL, the application decodes it back to the unique identifier, finds the corresponding user in the database, and redirects to their GitHub URL, which is securely stored in its encrypted form. This entire process occurs in the `ShortLinksController`.

This approach not only ensures the security of the original URLs but also provides a user-friendly way to share links with a shorter and more manageable format. The use of unique identifiers and encoding adds an additional layer of abstraction, making the system both secure and efficient.

## Search Implementation with Scope

The search functionality is implemented using a `scope` in the `User` model, allowing for searches based on a user-provided term. The `SEARCH_COLUMNS` constant lists the columns to be searched, such as `name`, `github_name`, `location`, and `organization`, making it easy to update the searchable fields.

The scope creates a dynamic query that performs a case-insensitive search across these columns using `ILIKE`. This query is then used with ActiveRecord’s `where` clause to efficiently find matching records in the database.

A **potential enhancement** is to integrate Elasticsearch for indexing keywords. Elasticsearch could provide more advanced search capabilities, such as assigning weights to different columns to improve search relevance and performance.

## Future Enhancements

### Adding Authentication Layer with Devise

To further enhance the security and functionality of the URL shortening system, I would recommend implementing a user authentication layer using Devise. Devise is a flexible authentication solution for Rails applications, providing a range of features to manage user accounts securely.
