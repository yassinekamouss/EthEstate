# --- ÉTAPE 1: Build ---
FROM node:18-alpine AS builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier package.json et package-lock.json pour installer les dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier tout le reste du code source de l'application
COPY . .

# Lancer le build de production
RUN npm run build -- --configuration production

# --- ÉTAPE 2: Serve ---
# Utiliser une image Nginx légère
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers statiques buildés depuis l'étape "builder"
COPY --from=builder /app/dist/Estate-Rental/browser /usr/share/nginx/html

# Exposer le port 80 (port par défaut de Nginx)
EXPOSE 80
