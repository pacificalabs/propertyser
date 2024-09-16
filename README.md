### Installation Instructions

#### Prerequisites

1. **Homebrew**: Ensure you have [Homebrew](https://brew.sh) installed.
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **RVM (Ruby Version Manager)**: Install RVM and the required Ruby version.
   ```bash
   \curl -sSL https://get.rvm.io | bash -s stable
   source ~/.rvm/scripts/rvm
   rvm install $(cat .ruby-version)
   rvm use $(cat .ruby-version) --default
   ```

3. **PostgreSQL**: Install PostgreSQL using Homebrew.
   ```bash
   brew install postgresql
   brew services start postgresql
   ```

4. **Bundler**: Ensure Bundler is installed.
   ```bash
   gem install bundler
   ```

5. **Foreman**: Install Foreman to manage multiple processes.
   ```bash
   gem install foreman
   ```

#### Setup

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. **Install Gems**:
   ```bash
   bundle install
   ```

3. **Setup the Database**:
   Create the database and run migrations.
   ```bash
   rails db:create
   rails db:migrate
   ```
   Update your user access details in the seeds.rb file.
   ```ruby
    @user_list = [{:firstname => "Tarun", :email => "tarun@pacificasearch.com", "password":"gdaymate", "username":"tarunm", is_admin:true, accepted_terms_and_conditions: true}]
   ```
   Seed the database.
   ```bash
   rails db:seed
   ```

5. **Start the Application**:
   Use Foreman to start all required processes (Puma server, Sidekiq worker, and CSS compilation).
   ```bash
   foreman start
   ```

   - **Web Server**: The app will be served by Puma at `http://127.0.0.1:5000`.
   - **CSS**: Sass will watch for changes and compile CSS.
