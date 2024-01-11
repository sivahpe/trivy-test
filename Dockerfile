# Use the official Nginx base image
FROM nginx:latest as no-vulns

# Copy a custom HTML file to the default Nginx web root
# COPY index.html /usr/share/nginx/html/

# Expose port 80 for web traffic
EXPOSE 80

# CMD is not necessary for the image to function, but it's here for illustration
CMD ["nginx", "-g", "daemon off;"]
