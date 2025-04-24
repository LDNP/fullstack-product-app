# SSH into EC2 instance
ssh -o StrictHostKeyChecking=no -i ssh_key.pem ubuntu@ec2-54-247-230-134.eu-west-1.compute.amazonaws.com << "ENDSSH"
  # Set variables inside the SSH session
  DOCKER_USERNAME="${DOCKER_USERNAME}"
  IMAGE_NAME="${IMAGE_NAME}"
  CONTAINER_NAME="product-app"
  SECRET_KEY_BASE="${SECRET_KEY_BASE}"

  # Pull the latest image from DockerHub
  echo "Pulling the latest image from DockerHub..."
  docker pull $DOCKER_USERNAME/$IMAGE_NAME

  # Stop any existing container
  echo "Stopping and removing any existing containers with the name $CONTAINER_NAME..."
  docker stop $CONTAINER_NAME || true
  docker rm $CONTAINER_NAME || true

  # Run migrations first
  echo "Running database migrations..."
  docker run --rm \
    -e SECRET_KEY_BASE=$SECRET_KEY_BASE \
    -e RAILS_ENV=production \
    -e DATABASE_URL=postgres://postgres:Kipper1985@172.17.0.1:5432/backend_production \
    $DOCKER_USERNAME/$IMAGE_NAME \
    rake db:migrate

  # Run the container in detached mode
  echo "Running the container in detached mode..."
  docker run -d -p 3000:3000 \
    --name $CONTAINER_NAME \
    -e RAILS_ENV=production \
    -e SECRET_KEY_BASE=$SECRET_KEY_BASE \
    -e DATABASE_URL=postgres://postgres:Kipper1985@172.17.0.1:5432/backend_production \
    $DOCKER_USERNAME/$IMAGE_NAME

  # Optionally, check if the container is running and output the logs for debugging (optional)
  echo "Checking container status..."
  docker ps -a
  docker logs $CONTAINER_NAME

ENDSSH

# Remove the key file when done
rm ssh_key.pem