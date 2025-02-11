#!/bin/bash

# Prompt the user for a project name
read -p "Enter your project name: " PROJECT_NAME
PROJECT_DIR=~/$PROJECT_NAME

# Check if the directory exists and prompt for overwrite
if [ -d "$PROJECT_DIR" ]; then
    read -p "The directory '$PROJECT_NAME' already exists. Overwrite? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" ]]; then
        echo "Aborting setup."
        exit 1
    fi
    rm -rf "$PROJECT_DIR"
fi

# Create project folder and navigate into it
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo "📂 Creating frontend..."
# Create Vite frontend
npm create vite@latest frontend -- --template vue
cd frontend
npm install

# Creating frontend folder structure
mkdir -p public src/assets src/components src/composables src/layouts \
         src/pages src/router src/store src/styles src/utils
touch src/App.vue src/main.js src/vite.config.js src/index.html \
      package.json postcss.config.js .eslintrc.js .prettierrc.js

cd ..

echo "📂 Creating backend..."
# Create backend folder and initialize Node.js project
mkdir -p backend/src/controllers backend/src/models backend/src/routes \
         backend/src/middleware backend/src/services
cd backend
npm init -y

# Changing import type
sed -i 's/"type": "commonjs"/"type": "module"/' package.json

# Install backend dependencies
npm install express cors dotenv

# Create backend files
touch index.js .env package.json .eslintrc.js

# Create server.js with basic Express setup
cat <<EOL > index.js
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

app.get('/api', (req, res) => {
  res.json({ message: 'Backend is working!' });
});

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOL

cd ..

echo "📂 Creating additional project files..."
# Create optional Docker setup folder
mkdir -p docker

# Create root project files
touch .gitignore README.md

echo "🔧 Configuring Vite proxy..."
# Modify Vite config to enable API proxy
cat <<EOL > frontend/vite.config.js
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': 'http://localhost:5001', // Proxy backend API
    }
  }
});
EOL

echo "✅ Setup complete!"
echo "Run 'cd ~/$PROJECT_NAME/backend && node src/server.js' to start the backend"
echo "Run 'cd ~/$PROJECT_NAME/frontend && npm run dev' to start the frontend"
