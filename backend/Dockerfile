# Start from ruby base
FROM ruby:3.2.0

# Install system dependencies
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs npm postgresql-client

# Set working directory
WORKDIR /usr/src/app

# Copy the full project
COPY . .

# Build React frontend
WORKDIR /usr/src/app/react-client
RUN npm install
ENV PUBLIC_URL=/react-client
RUN npm run build

# Copy the React build output into Rails public/react-client
WORKDIR /usr/src/app/backend
RUN mkdir -p public/react-client
RUN cp -r /usr/src/app/react-client/build/* public/react-client/

# Install Rails backend
RUN gem install bundler:2.4.22
RUN bundle install

# Expose the API port
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]