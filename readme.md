# Roboshop Shell Scripting - DRY Version

This project automates the deployment of the Roboshop e-commerce application using Shell Scripting and AWS CLI(Command Line Interface).

The primary aim is to avoid the repetitive code and implement DRY (Don't Repeat Yourself) principles for a professional, modular setup.

## Project Highlights

* Modular Architecture: Centralized logic using a common.sh file.

* DRY Principles: Shared functions for Node.js, Java, Python, and Nginx application setups.

* Reliability: Idempotent checks (prevents duplicate users/instances) and automated service lifecycle management.

* Detailed Logging: Centralized logging in /var/log/shell-roboshop/ with script execution timers.

# Pre-requisites

* Infrastructure: 10 EC2 instances (RHEL 9 recommended) named according to the services.

* Access: Root/Sudo access on all instances.

* AWS CLI: Configured on your workspace to manage Route53 records and EC2 instance states.

# How to Deploy the Services

* Clone the repository: git clone https://github.com/javeed-mohd/shell-roboshop-common.git

  cd shell-roboshop-common/

* Run the scripts: Execute the scripts for each service.

* It is recommended to start with the databases first:

# Databases

sudo sh mongodb.sh

sudo sh redis.sh

sudo sh mysql.sh

sudo sh rabbitmq.sh

# Application Services (BACKEND)

sudo sh catalogue.sh

sudo sh user.sh

sudo sh cart.sh

sudo sh shipping.sh

sudo sh payment.sh

# Web Serer(FRONTEND)

sudo sh frontend.sh

# Outcome

I spent significant time debugging sed(Streamline editor) quoting issues, S3 URL logic, and cross-service permissions (RabbitMQ). Overall, it was a great hands-on experience in automating application...