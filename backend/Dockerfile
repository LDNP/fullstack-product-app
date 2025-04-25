FROM ruby:3.2.0

# Install system dependencies
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends nodejs npm postgresql-client

# Set working directory
WORKDIR /usr/src/app

# Copy the entire project so we can build the React app
COPY . .

# Build the React app
WORKDIR /usr/src/app/react-client
RUN npm install
RUN npm run build

# Create directory for React files
WORKDIR /usr/src/app/backend
RUN mkdir -p public/react-client/

# Copy the React build files to the Rails public directory
RUN cp -r /usr/src/app/react-client/build/* public/react-client/

# Set environment variables for Rails
ARG SECRET_KEY_BASE
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Install bundler and handle bundle installation
RUN gem install bundler:2.4.22
RUN bundle config set --local force_ruby_platform true
RUN bundle install

# Expose API port
EXPOSE 3000

# Start Rails API server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]