# Nested Loops

## Issue
We encountered issues with recursive workflows calls. For example, in our GitLab repository, we implemented five levels of nested calls, but GitHub Actions only supports three levels of nesting.
Our original call structure looked like this:  
`main.yml -> preflight.yml -> integrations-template.yml -> security-tool.yml -> security-template.yml`  
![Nested Loops Error](/docs/assets/errors/invalid_loops.png) 
**Purpose of Each File**
* **Main**: contains the calls to each stage (preflight, build, etc).
    * **Preflight**: contains all the jobs related to the preflight stage.
        * **Integrations Template**: wraps three main tasks: calling the security tool, uploading the report to DefectDojo, and uploading it to ArmorCode.
            * **Security-Tool**: defines the specific command for each security tool and passes it to the template.
                * **Security Template**: executes the tool's command and stores the results as an artifact.  

## Solution

Due to GitHub’s limitation (maximum of 3 levels of nested workflow calls), we had to simplify our structure.  
The updated structure is: `main.yml -> preflight.yml -> template.yml`  
Now, from preflight.yml, we pass all the required arguments to the template directly, including the command to execute the security tool.

To allow customization for each tool, we provide a separate **.env** file per tool containing the relevant variables.