FROM rocker/r-bspm:22.04

# install nginx
RUN apt-get update && apt-get install -y nginx

# install R dependencies
RUN apt-get update && apt-get install -y r-cran-rmarkdown r-cran-blogdown

# install Hugo
RUN echo "options(blogdown.hugo.version = '0.78.2')" >> /etc/R/Rprofile.site
RUN Rscript -e "blogdown::install_hugo('0.78.2')"

# copy site
COPY . /site

# build site
RUN cd /site && Rscript -e "blogdown::build_site()"

EXPOSE 80

# configure site
RUN rm -rf /var/www/html && \
    rm -rf /etc/nginx/sites-enabled/default && \
    rm -rf /etc/nginx/sites-available/default && \
    cp /site/.config/nginx.conf /etc/nginx/sites-available/terourou && \
    ln -s /etc/nginx/sites-available/terourou /etc/nginx/sites-enabled/terourou

CMD ["nginx", "-g", "daemon off;"]
