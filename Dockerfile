# base image for the first phase : build phase
FROM node:alpine as builderphase
# mentioning the workdirectory
WORKDIR '/app'
# coping the dependencies file
COPY package.json .
# install the dependencies
RUN npm install
# copy all other source code
COPY . .
# run the build process to make a build folder from
# the app to be used in the next RUN phase
RUN npm run build

# now the image for the second phase : run phase
FROM nginx as runphase
# exposing the port for deplyoing it to elasticbeanstalk
# this command only works with elasticbeanstalk and not
# on our local machine as its of no use for us
EXPOSE 80
# copying from a different phase
COPY --from=builderphase /app/build /usr/share/nginx/html
# the frist command is the phase from where we want
# to copy the files/folders from that is from
# builderphase then then file/folder path of the file
# that we want to copy next will be the destination
# we want to paste it to
