# WCF DevOps Homework

## Overview
Your mission, should you choose to accept it, is deploy and scale two applications (Web API and Auth API) to incoming requests.

## Tasks

- Deploy the sample python applications to a cluster of nodes using a container orchestration framework
- Web API should be publicly accessible over HTTPS
- Auth API should NOT be accessible via the public internet
- Please show how you would auto-scale the number of nodes and containers as the number of requests increases

## Deliverables

Have the following ready to share with folks:

- A Dockerfile for each application
- Framework for deploying containers to a group of nodes
- Documentation on continuous delivery process to ship to a production environment
- Scripts and/or docs involved with automatically scaling the application and nodes horizontally based on requests

For your work, DO NOT fork this repo!  Create a new repo using public Github or Gitlab account, use a unique name and send us the final product!

## FAQ

*Is this a local or non-local cluster?*

Either one will do, completely your choice.  Some candidates decide to do a more local build out using an orhcestration solution running on their laptops, while others prefer to use a cloud provider.

*Is there a cloud account I'm supposed to deploy to?*

No... if you choose to build on a specific cloud, that is perfectly fine, but we do not have any dedicated accounts for you to use.  We'd recommend you minimize spend if you go with this option, this exercise should fit neatly into free tier offerings.

*How should I document things?*

Screen caps/recordings are a viable option to document or demo something.  What we are really looking to see is the thought process and how you go about coming up with a solution.  Or you could use Markdown or Asciidoctor inside your repo.  Whatever it happens to be, we're looking for you to do a show and tell during any follow up conversations.


## Notes

- Again, please do NOT fork or submit a PR to this repo!
- It's perfectly fine to show your work through git commits (using well written commit messages)
- You are welcome to change the python applications and their requirements in any way you see fit
- We are purposefully NOT being overly prescriptive in this assignment
- Thinking creatively about the solution is encouraged
- This assignment should take less than 3 hours to complete
- If you get stuck or need more information, please reach out for clarity
- We will review your submission and be in touch with next steps.
- Have fun!

## Getting Started in Local Development

This assumes you have `ab`, `sqlite3`, `python`, `pip`, `virtualenv` already installed.  If not (and running Ubuntu) you can use:
```
sudo apt-get install apache2-utils sqlite3 python3-pip
pip3 install virtualenv 
```

Please create and source your virtualenv before beginning; something like:
```
virtualenv -p python3 homework
source homework/bin/activate    # or python3 -m venv myenv
```

Initialize the database (only needs to be done once):
```
sqlite3 database.db < schema.sql
```

Running the apps locally:
```
pip install -r requirements.txt
python web_api.py
python auth_api.py
```

Making a request
```
curl -X POST -H 'Authorization: wcftoken' http://127.0.0.1:5000/check
```

Simulating a lot of requests
```
ab -m POST -H "Authorization: wcftoken" -n 500 -c 4 http://127.0.0.1:5000/check
```
