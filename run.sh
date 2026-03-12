# 1) Verify the isolated user actually exists
id openclaw || echo "USER_MISSING"

# 2) If missing, create the user
sudo sysadminctl -addUser openclaw -fullName "OpenClaw" -password 'ChangeThisPassword123'

# 3) Confirm user creation
id openclaw
dscl . -read /Users/openclaw NFSHomeDirectory

# 4) Create the home directory if macOS did not create it
sudo mkdir -p /Users/openclaw
sudo chown openclaw:staff /Users/openclaw
sudo chmod 700 /Users/openclaw

# 5) Move the project into the isolated user home
sudo mv "/Users/ofcskn/Documents/projects/ofcskn/openclaw" /Users/openclaw/

# 6) Fix ownership of the project
sudo chown -R openclaw:staff /Users/openclaw/openclaw

# 7) Restrict permissions
sudo chmod -R u+rwX,go-rwx /Users/openclaw/openclaw

# 8) Enter the isolated user shell
sudo -u openclaw -H zsh

# 9) Inside that shell run:
cd ~/openclaw
chmod +x docker-setup.sh
sed -i '' 's/\r$//' docker-setup.sh
./docker-setup.sh

# 10) Verify containers
docker ps
docker compose ps
