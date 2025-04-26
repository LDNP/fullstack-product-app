# Use Ruby as the base image
FROM ruby:3.2.0

# Install system dependencies
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs npm postgresql-client

# Set working directory
WORKDIR /usr/src/app

# Copy the entire project to the container
COPY . .

# Build the React frontend
WORKDIR /usr/src/app/react-client
RUN npm install
RUN npm run build

# Copy React build output into Rails public folder
WORKDIR /usr/src/app/backend
RUN mkdir -p public/react-client
RUN cp -r /usr/src/app/react-client/build/* public/react-client/

# Install Rails app dependencies
RUN gem install bundler:2.4.22
RUN bundle install

# Expose Rails server port
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]