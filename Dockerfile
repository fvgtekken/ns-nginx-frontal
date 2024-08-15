# production stage
FROM nginx:stable-alpine as production


# Copy nginx config file
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf


# Expose port 
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
