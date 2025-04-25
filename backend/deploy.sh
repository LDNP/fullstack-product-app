ssh -o StrictHostKeyChecking=no -i ssh_key.pem ubuntu@ec2-54-247-230-134.eu-west-1.compute.amazonaws.com <<EOF
  export DOCKER_USERNAME=${DOCKER_USERNAME}
  export IMAGE_NAME=${IMAGE_NAME}
  export CONTAINER_NAME="product-app"
  export SECRET_KEY_BASE=${SECRET_KEY_BASE}

  echo "Pulling the latest image from DockerHub..."
  docker pull \$DOCKER_USERNAME/\$IMAGE_NAME

  echo "Stopping and removing any existing containers with the name \$CONTAINER_NAME..."
  docker stop \$CONTAINER_NAME || true
  docker rm \$CONTAINER_NAME || true

  echo "Running database migrations..."
  docker run --rm \
    -e SECRET_KEY_BASE=\$SECRET_KEY_BASE \
    -e RAILS_ENV=production \
    -e DATABASE_URL=postgres://postgres:Kipper1985@172.17.0.1:5432/backend_production \
    \$DOCKER_USERNAME/\$IMAGE_NAME \
    rake db:migrate

  echo "Running the container in detached mode..."
  docker run -d -p 3000:3000 \
    --name \$CONTAINER_NAME \
    -e RAILS_ENV=production \
    -e SECRET_KEY_BASE=\$SECRET_KEY_BASE \
    -e DATABASE_URL=postgres://postgres:Kipper1985@172.17.0.1:5432/backend_production \
    \$DOCKER_USERNAME/\$IMAGE_NAME

  echo "Container logs:"
  docker ps -a
  docker logs \$CONTAINER_NAME
EOF