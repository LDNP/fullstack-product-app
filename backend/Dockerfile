FROM ruby:3.2.0

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

# Install bundler and handle bundle installation properly
RUN gem install bundler:2.4.22
RUN bundle config set --local force_ruby_platform true
RUN bundle lock --update
RUN bundle install

# Expose API port
EXPOSE 3000

# Start Rails API server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]