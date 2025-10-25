# Task-01:
# React Application with CI/CD Pipeline

A React application with automated CI/CD pipeline using GitHub Actions, Docker, and AWS EC2 deployment.

## Overview

This project is a standard React application created with `create-react-app`, featuring a complete CI/CD pipeline that automatically builds, tests, and deploys the application to AWS EC2 using Docker containers.

## Features

- **React Frontend**: Standard React application setup
- **Automated CI/CD**: GitHub Actions workflow for continuous integration and deployment
- **Containerization**: Docker-based deployment
- **Cloud Hosting**: Deployed on AWS EC2 instance

## Prerequisites

Before setting up this project, ensure you have:

- Node.js and npm installed
- Docker installed on your local machine and EC2 instance
- AWS EC2 instance with appropriate configuration
- GitHub repository
- Docker Hub account

## AWS EC2 Setup

### Instance Configuration

1. **Launch an EC2 instance** with your preferred Linux distribution
2. **Install Docker** on the instance:
   ```bash
   sudo apt-get update
   sudo apt-get install docker.io -y
   ```

3. **Add user to Docker group** (replace `username` with your EC2 username):
   ```bash
   sudo usermod -aG docker username
   ```

4. **Configure Security Group** to allow inbound traffic on port 3000:
   - Type: Custom TCP
   - Port Range: 3000
   - Source: 0.0.0.0/0 (or restrict to your IP)

5. **Generate or use existing PEM key** for SSH access

## GitHub Secrets Configuration

Add the following secrets to your GitHub repository (Settings → Secrets and variables → Actions):

| Secret Name | Description |
|------------|-------------|
| `AWS_HOST` | Public IP or hostname of your EC2 instance |
| `AWS_USERNAME` | Username for SSH access to EC2 (e.g., `ubuntu`, `ec2-user`) |
| `AWS_PEM_KEY` | Contents of your PEM file for EC2 SSH access |
| `DOCKERUSER` | Your Docker Hub username |
| `DOCKERPASS` | Your Docker Hub password or access token |

**Note**: The secret names must match exactly as they are referenced in the workflow file.

## Local Development

### Installation

```bash
# Clone the repository
git clone <your-repository-url>
cd <your-project-name>

# Install dependencies
npm install
```

### Running the Application

```bash
# Start development server
npm start
```

The application will run on `http://localhost:3000`

### Building for Production

```bash
# Create production build
npm run build
```

## CI/CD Pipeline

### Workflow Trigger

The CI/CD pipeline automatically triggers on:
- Push to `main` branch
- Pull requests to `main` branch (optional, based on your workflow configuration)

### Pipeline Steps

1. **Build**: Compiles the React application
2. **Test**: Runs test suite
3. **Dockerize**: Creates Docker image with the built application
4. **Push to Docker Hub**: Uploads the image to Docker Hub
5. **Deploy to EC2**: 
   - SSH into EC2 instance
   - Pull latest Docker image
   - Stop and remove old container
   - Run new container on port 3000

## Docker Configuration

The application runs in a Docker container exposed on port 3000. Make sure your `Dockerfile` is properly configured in the project root.

### Example Dockerfile

```dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
```

## Deployment

### Automatic Deployment

Simply push your changes to the `main` branch:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

The GitHub Actions workflow will automatically:
- Build and test your application
- Create a Docker image
- Push to Docker Hub
- Deploy to your EC2 instance

### Manual Deployment

If needed, you can manually deploy by SSH-ing into your EC2 instance:

```bash
# Pull the latest image
docker pull <dockerhub-username>/<image-name>:latest

# Stop and remove existing container
docker stop <container-name>
docker rm <container-name>

# Run new container
docker run -d -p 3000:3000 --name <container-name> <dockerhub-username>/<image-name>:latest
```

## Accessing the Application

Once deployed, access your application at:
```
http://<your-ec2-public-ip>:3000
```

## Troubleshooting

### Common Issues

1. **Port 3000 not accessible**
   - Check EC2 Security Group rules
   - Verify Docker container is running: `docker ps`

2. **Docker permission denied**
   - Ensure user is in docker group: `sudo usermod -aG docker $USER`
   - Log out and back in for changes to take effect

3. **Pipeline fails on deployment**
   - Verify all GitHub secrets are correctly set
   - Check EC2 instance is running
   - Verify SSH key has correct permissions

4. **Container not starting**
   - Check Docker logs: `docker logs <container-name>`
   - Verify image was built correctly

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── main.yml          # GitHub Actions workflow
├── public/                     # Public assets
├── src/                        # React source code
├── Dockerfile                  # Docker configuration
├── package.json               # Project dependencies
└── README.md                  # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please open an issue in the GitHub repository.
