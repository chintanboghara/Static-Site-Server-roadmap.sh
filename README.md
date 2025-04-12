# Static Site Server

This project demonstrates how to set up a basic Linux server to serve a static website using Nginx. It includes a deployment script to update the site on the server using rsync.

## Repository Structure

- **`static_site/`**: Directory containing the static site files.
  - **`index.html`**: The main HTML file for the website.
  - **`styles.css`**: CSS file for styling the website.
  - **`image.jpg`**: A sample image used in the website.
  - **`deploy.sh`**: A bash script to deploy the site to the server using rsync.
- **`README.md`**: This documentation file.

## Setup Instructions

Follow these steps to set up the server and deploy the static site:

### 1. Set Up the Server

- **Register and Create a Linux VM**:
  - Sign up for a cloud provider like [Microsoft Azure](https://azure.microsoft.com/en-us/free/)
  - Create a virtual machine (VM) using Ubuntu (e.g., 20.04 LTS).
  - Ensure SSH access is enabled and note the public IP address of the server.

- **Connect to the Server via SSH**:
  - Use the following command (replace placeholders with your actual values):
    ```bash
    ssh -i /path/to/your/private_key.pem username@your_server_ip
    ```
  - Ensure your private key has the correct permissions:
    ```bash
    chmod 400 /path/to/your/private_key.pem
    ```

### 2. Install and Configure Nginx

- **Update the Package List**:
  ```bash
  sudo apt update
  ```

- **Install Nginx**:
  ```bash
  sudo apt install nginx
  ```

- **Start and Enable Nginx**:
  - Ensure Nginx starts automatically on boot and is running:
    ```bash
    sudo systemctl enable nginx
    sudo systemctl start nginx
    ```
  - Check the status to confirm it's active:
    ```bash
    sudo systemctl status nginx
    ```

- **Allow HTTP Traffic (if firewall is active)**:
  - If UFW (Uncomplicated Firewall) is enabled, allow HTTP traffic:
    ```bash
    sudo ufw allow 'Nginx HTTP'
    ```

### 3. Create the Static Site Locally

- **Create a Directory for the Site**:
  ```bash
  mkdir static_site
  cd static_site
  ```

- **Create `index.html`**:
  ```html
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>My Static Site</title>
      <link rel="stylesheet" href="styles.css">
  </head>
  <body>
      <h1>Welcome to My Static Site</h1>
      <p>This is a simple static site served by Nginx.</p>
      <img src="image.jpg" alt="Sample Image">
  </body>
  </html>
  ```

- **Create `styles.css`**:
  ```css
  body {
      font-family: Arial, sans-serif;
      text-align: center;
  }
  h1 {
      color: blue;
  }
  ```

- **Add an Image**:
  - Place a sample image file (e.g., `image.jpg`) in the `static_site` directory.

### 4. Deploy the Site Using rsync

- **Install rsync (if not already installed)**:
  - On the server:
    ```bash
    sudo apt install rsync
    ```
  - On your local machine (if needed, e.g., for macOS: `brew install rsync`).

- **Sync Local Files to the Server**:
  - From your local machine, run:
    ```bash
    rsync -avz -e "ssh -i /path/to/your/private_key.pem" ./ username@your_server_ip:/var/www/html/
    ```
    - This command syncs the contents of `static_site/` to the server's `/var/www/html/` directory.

- **Set Correct Permissions on the Server**:
  - Nginx runs as the `www-data` user, so update ownership:
    ```bash
    ssh -i /path/to/your/private_key.pem username@your_server_ip "sudo chown -R www-data:www-data /var/www/html/*"
    ```

### 5. Access the Site

- **Visit the Site**:
  - Open a web browser and navigate to `http://your_server_ip` to view your static site.
  - If you have a domain name, you can point it to the server's IP address and configure Nginx accordingly (optional).

## Usage

- **Update the Site**:
  - Make changes to the files in `static_site/` on your local machine.

- **Deploy Changes**:
  - Run the `deploy.sh` script to sync the updated files to the server:
    ```bash
    ./deploy.sh
    ```
  - The script uses rsync to efficiently transfer only the changed files.

### deploy.sh Script

The `deploy.sh` script automates the deployment process. Configure it with your specific paths and server details:

```bash
#!/bin/bash

# Define variables
LOCAL_SITE_PATH="/path/to/static_site"
REMOTE_USER="username"
REMOTE_HOST="your_server_ip"
REMOTE_PATH="/var/www/html/"
SSH_KEY="/path/to/your/private_key.pem"

# Sync files
rsync -avz -e "ssh -i $SSH_KEY" $LOCAL_SITE_PATH/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH
```

- Replace the placeholders with your actual local site path, username, server IP, and SSH key path.
- Make the script executable:
  ```bash
  chmod +x deploy.sh
  ```

## Troubleshooting

- **Cannot connect to the server via SSH**:
  - Ensure the SSH key has the correct permissions (`chmod 400 private_key.pem`).
  - Verify the server's IP address and that SSH is allowed in the server's firewall settings.

- **Nginx not serving the site**:
  - Check if Nginx is running: `sudo systemctl status nginx`.
  - Ensure the site files are in `/var/www/html/` and have the correct permissions (`sudo chown -R www-data:www-data /var/www/html/*`).

- **rsync errors**:
  - Make sure rsync is installed on both the local machine and the server.
  - Verify the SSH key path, username, and server IP in the `deploy.sh` script.
