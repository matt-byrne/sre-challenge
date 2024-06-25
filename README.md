# SRE Challenge

## Introduction :wave:

This challenge is intended to utilise problem solving, research and monitoring skills required by a Site Reliability Engineer.

In completing the challenge, you're welcome to change all aspects of the initial repository, including:
* Directory and file structure.
* Terraform code and configuration.
* Github actions workflows.
* This README!

The solution should represent best practices, even if aspected of the starting solution are lacking them.

You shouldn't need any specific local software installed or to sign up any services or accounts.

Since this is not a DevOps challenge, Terraform scaffolding and pipelines to plan/apply it have been provided.

## Scenario :blue_book:

You're a Site Reliability Engineer tasked with configuring monitoring on a newly developed website. The website is hosted on a SaaS platform and as such there is no requirement to monitor infrastructure or (for the sake of this challenge) the platform itself.

The website is a basic brochureware website with a single piece of interactive functionality - A 'contact us' form. This form is very important to the client / product owners as it generates revenue through leads. The process of submitting the contact us form should be monitored to ensure it works consistently. (For the sake of this challenge, don't worry about generating bogus contact entries).

Additionally, general site availability should be tested and some content should be sampled to ensure it is rendering correctly to the end user.

Due to regulations in the client's field, the site must be secured by an SSL certificate all times.

All of these checks are considered *very* important and even a minute of downtime is considered serious and worth capturing.

(Hint: The test site is configured to break at regular intervals, so some of your alerts *will* fire.)

The website's domain name is https://witty-water-008de0c00.5.azurestaticapps.net/

## Challenge :question:

Your goal as a Site Reliability Engineer in a managed services business implementing similar sythetic checks very regularly is to avoid manual effort as much as possible and instead utilise standard Infrastructure-As-Code platforms to create the monitoring configuration(s). In this case, your team is using Terraform for other such practices so continuing to use Terraform makes the most sense. Your team uses New Relic as their standard observability platform so you should also use this.

You should utilise the existing Terraform configuration scaffolding and pipelines to:

1. Configure any relevant synthetic monitors against the website.
2. Send email alerts to the provided email address when the alerts fire.
3. Create a simple dashboard to track trends in failures of your synthetic checks over time.
4. Use your dashboards and alerts to report back your findings on regular failures in the website (A simple paragraph or two in a text file in your Pull Request will do).
5. Create a pull request back to this repository with all your changes.

## Provided Resources :toolbox:

The following resources are provided for your use when completing the challenge:

* Terraform configuration scaffolding
* GitHub Actions workflows to Plan/Apply Terraform
* Azure Storage Account & Container for Terraform state storage
* A Gmail account
* A New Relic account

Additionally, you will receive a set of credentials / secrets related to these items:

* GMail account username
* Gmail account password
* New Relic account username
* New Relic account password
* New Relic account ID
* New Relic API key
* Azure Client Secret
* Azure Storage Account Container name
* Azure Storage Account SAS token

(Note that Azure is used entirely for Terraform state storage - There is no need to provision or otherwise interact with Azure resources.)

## Setup :gear:

Some setup is required for the Terraform plan/apply pipelines to work in your own copy of this repository:

1. In the top right hand corner of this repository's main screen, click **Fork** to create a copy of it under your own account.
2. In your copy of the repository, go to **Settings -> Security -> Secrets and variables -> Actions**.
3. Create the following repository secrets by going to the **Secrets** tab and clicking **New repository secret**:
    * **ARM_CLIENT_SECRET** (Azure Client Secret)
    * **ARM_SAS_TOKEN** (Azure Storage Account SAS token)
    * **AZURE_STORAGE_BACKEND_CONTAINER_NAME** (Azure Storage Account Container name)
    * **NEW_RELIC_API_KEY** (New Relic API key)
4. Create the following repository variables by going to the **Variables** tab and clicking **New repository variable**:
    * **NEW_RELIC_ACCOUNT_ID** (New Relic account ID)