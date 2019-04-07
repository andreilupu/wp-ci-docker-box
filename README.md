### [Work In Progress] A docker image for CI WordPress checks.
-----------------
While working with WordPress I feel like I'm always missing a docker image with all the tools needed for tasks like code checking, unit testing or CSS/JS linting.

Now I'm trying to create a docker image that has:
- wp-cli
- PHPCS
- WPCS
- PHPUnit
- NodeJS
- NPM

Hopefully this will work as a base image for a CircleCI workflow.
