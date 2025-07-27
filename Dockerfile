# Use the official Rocket.Chat image from Docker Hub
FROM rocket.chat:latest

# Expose the default port
EXPOSE 3000

# Start the Rocket.Chat server
CMD ["node", "main.js"]
