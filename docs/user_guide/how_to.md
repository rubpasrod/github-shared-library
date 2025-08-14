# GitHub Shared Library

## What is a Shared Library?
A shared library in GitHub Actions is a collection of reusable workflows and custom actions that you can share across multiple repositories. Think of it as a centralized and version-controlled toolbox for your automation and CI/CD pipelines. Instead of duplicating the same scripts and configurations in every project, you can define them once in a shared library and then reference them in your individual workflows.

This approach is particularly powerful for implementing DevSecOps practices throughout your Software Development Life Cycle (SDLC). DevSecOps is all about integrating security into every phase of software development, from initial planning to final deployment. A shared library becomes the backbone of this "shift-left" security strategy, ensuring that security checks are consistently and automatically applied to all your projects.

## Why Use a Shared Library?
- Consistency and Standardization: Enforce the use of approved security tools and processes across all your projects. This ensures that every application is subject to the same high standards of security scanning and vulnerability assessment.

- Reduced Duplication: Avoid the "copy-paste" anti-pattern for your CI/CD and security workflows. This not only saves time but also makes your pipelines cleaner and easier to understand.

- Simplified Maintenance: When you need to update a security tool, add a new check, or change a configuration, you only have to do it in one place. These changes are then automatically propagated to all projects that use the library.

- Enhanced Security Posture: By embedding security tools directly into the development pipeline, you can catch vulnerabilities early, before they reach production. This proactive approach significantly reduces risk and the cost of remediation.

## Our DevSecOps Shared Library
This shared library is designed to integrate security into your development workflow. It leverages a suite of powerful open-source security tools to provide comprehensive scanning and analysis.

All the findings from these security tools are then consolidated and uploaded to DefectDojo. This serves as our centralized vulnerability management platform, providing a comprehensive overview of our security posture. In DefectDojo, we can track, prioritize, and manage the remediation of all identified vulnerabilities, giving us a robust system of control over our application security.

## How to use it
To integrate our DevSecOps shared library into your application's repository, you need to create a new workflow file that calls the main template from the library. This is done by creating a call_template.yml file within the .github/workflows/ directory of your project. This calling workflow is a simple yet powerful way to execute the entire suite of security scans defined in our shared library against your code.

This is an example of the call-template:
```yaml
name: Shared Workflow 

on:
  push:
    branches:
      - develop # The branch you are using in your project 

jobs:
  main:
    uses: yggdrasilcorp/github-pipeline/.github/workflows/main.yml@develop # This is our repo, you don't need to change anything
    secrets:
      PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }} # It is important to save in your repo secrets the PAT to access to our repo.
      DEFECTDOJO_API_TOKEN: ${{ secrets.DEFECTDOJO_API_TOKEN }} # It is important to save in your repo secrets the token to upload each report.
    with:
      repository:  ${{ github.repository }}
      branch: "develop" # This is our repo branch, you don't need to change anything
```