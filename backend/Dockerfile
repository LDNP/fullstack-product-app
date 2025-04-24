FROM ruby:3.0.0

# Install system dependencies
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends nodejs postgresql-client

# Set working directory
WORKDIR /usr/src/app

# Copy Rails API backend files
COPY . .

# Set environment variables
ARG SECRET_KEY_BASE
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Install bundler and project gems
RUN gem install bundler:2.2.3
RUN bundle install

# Precompile static assets (HTML client lives in public/html-client)
RUN rails assets:precompile

# Run DB migrations
RUN rake db:migrate

# Expose API port
EXPOSE 3000

# Start Rails API server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]