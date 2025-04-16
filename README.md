# Static Site Server

This project demonstrates how to configure a basic Linux server using Nginx to serve a static website. It also includes a deployment script that uses `rsync` to update the site on the server.

## Repository Structure

```plaintext
.
├── static_site/           # Static site source files
│   ├── index.html         # Main HTML file
│   ├── styles.css         # CSS for site styling
│   ├── image.jpg          # Sample image used in the website
│   └── deploy.sh          # Deployment script to sync site via rsync
└── README.md              # This documentation file
```

## Setup Instructions

### 1. Set Up the Server

#### a. Create a Linux VM
- Sign up with a cloud provider (e.g., [Microsoft Azure](https://azure.microsoft.com/en-us/free/)) and create an Ubuntu (e.g., 20.04 LTS) virtual machine.
- Ensure SSH access is enabled and note your server’s public IP address.

#### b. Connect via SSH
Replace placeholders with your actual key path, username, and server IP:

```bash
ssh -i /path/to/your/private_key.pem username@your_server_ip
```

Ensure proper SSH key permissions:

```bash
chmod 400 /path/to/your/private_key.pem
```

### 2. Install and Configure Nginx

#### a. Update and Install
Update the package list and install Nginx:

```bash
sudo apt update
sudo apt install nginx
```

#### b. Enable and Start Nginx
Ensure Nginx starts automatically on boot and is running:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```

#### c. Configure Firewall (if applicable)
If using UFW, allow HTTP traffic:

```bash
sudo ufw allow 'Nginx HTTP'
```

### 3. Create the Static Site Locally

#### a. Directory and Files Setup
Create a directory for your site and navigate into it:

```bash
mkdir static_site
cd static_site
```

#### b. Create `index.html`
Example content for `index.html`:

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

#### c. Create `styles.css`
Example content for `styles.css`:

```css
body {
    font-family: Arial, sans-serif;
    text-align: center;
}
h1 {
    color: blue;
}
```

#### d. Add an Image
Place a sample image file named `image.jpg` in the `static_site` directory.

### 4. Deploy the Site Using rsync

#### a. Install rsync
- On the server:

  ```bash
  sudo apt install rsync
  ```

- On your local machine, install rsync as needed (for example, on macOS use Homebrew: `brew install rsync`).

#### b. Sync Files to the Server
From your local machine, execute the command below (update placeholders accordingly):

```bash
rsync -avz -e "ssh -i /path/to/your/private_key.pem" ./static_site/ username@your_server_ip:/var/www/html/
```

#### c. Set Correct Permissions on the Server
Nginx runs as the `www-data` user, so update ownership on the server:

```bash
ssh -i /path/to/your/private_key.pem username@your_server_ip "sudo chown -R www-data:www-data /var/www/html/*"
```

## Deployment Script (`deploy.sh`)

The `deploy.sh` script automates the deployment process using rsync. Customize it with your specific server details.

```bash
#!/bin/bash

# Define variables
LOCAL_SITE_PATH="/path/to/static_site"
REMOTE_USER="username"
REMOTE_HOST="your_server_ip"
REMOTE_PATH="/var/www/html/"
SSH_KEY="/path/to/your/private_key.pem"

# Sync files to the server
rsync -avz -e "ssh -i $SSH_KEY" $LOCAL_SITE_PATH/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH
```

Make the script executable:

```bash
chmod +x static_site/deploy.sh
```

Run the script to deploy changes:

```bash
./static_site/deploy.sh
```

## Access the Site

Open a web browser and navigate to:

```plaintext
http://your_server_ip
```

If you own a domain name, you may point it to your server’s IP address and update the Nginx configuration accordingly.

## Troubleshooting

- **SSH Issues:**
  - Ensure the SSH key permissions are correct (`chmod 400`).
  - Verify the server’s IP and that SSH access is allowed through any active firewall.

- **Nginx Issues:**
  - Confirm Nginx is active: `sudo systemctl status nginx`
  - Make sure the site files are correctly placed in `/var/www/html/` and ownership is set to `www-data`.

- **rsync Errors:**
  - Ensure `rsync` is installed on both the local machine and the server.
  - Double-check the SSH key path, username, and server IP in your `deploy.sh` script.
