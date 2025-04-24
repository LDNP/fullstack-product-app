#!/bin/bash

# SSH into EC2 instance
ssh -o StrictHostKeyChecking=no $EC2_USERNAME@$EC2_PUBLIC_DNS << 'EOF'
  
  # Pull the latest image from DockerHub
  docker pull $DOCKER_USERNAME/$IMAGE_NAME
  
  # Stop any existing container (if running)
  docker stop $CONTAINER_NAME || true
  docker rm $CONTAINER_NAME || true

  # Run the new container
  docker run -d -p 3000:3000 \
    --name $CONTAINER_NAME \
    -e RAILS_ENV=production \
    -e SECRET_KEY_BASE=$SECRET_KEY_BASE \
    $DOCKER_USERNAME/$IMAGE_NAME
  
EOF