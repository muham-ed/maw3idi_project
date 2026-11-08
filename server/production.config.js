module.exports = {
  apps: [
    {
      name: 'didi-ride-backend',
      script: './index.js',
      instances: 'max',
      exec_mode: 'cluster',
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env_production: {
        NODE_ENV: 'production',
        PORT: 3000,
        DATABASE_URL: 'postgres://user:password@localhost:5432/didi_db',
        REDIS_URL: 'redis://localhost:6379',
        JWT_SECRET: 'super_secret_jwt_key_didi_2026',
        SSL_CERT_PATH: '/etc/letsencrypt/live/api.yourdomain.com/fullchain.pem',
        SSL_KEY_PATH: '/etc/letsencrypt/live/api.yourdomain.com/privkey.pem'
      }
    }
  ]
};
