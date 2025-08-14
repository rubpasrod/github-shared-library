# Architecture

## Issue
We faced some problems when trying to organize by subdirectories, as we do on GitLab. In GitHub, this is not possible. We encountered the following issue every time when we attempted to reference a file located in a subdirectory:  
![Subdirectory Error](/docs/assets/errors/invalid_directory.png)  
This means it is impossible to reference a file that is not within the .github/workflows directory.  

## Solution

We have create d a new folder inside `.github` called `workflows-lib`. Inside this folder, we will have several subfolders, and inside each folder we will have the different actions to execute which will be composite actions so they can be referenced from another directory.

### Workflows Structure 
We have planned to organize the project as follows:
* We will have `main.yml` that triggers all the jobs (which in GitHub are not called stages, but jobs). These jobs will be defined in the workflow directory:
    * preflight
    * build
    * test
    * deploy
    * release  

* Inside `workflows-lib` folder, we will have the following subfolders:
    * core: general utilities for the project
    * maven: maven related actions
    * node: node.js related actions
    * templates: reusable templates for workflows
    * armorcode: ArmorCode specific workflows
    * defectdojo: DefectDojo specific workflows

## Different Design Ideas
1. **Main Alone:**   
Initially, we considered placing all the stages (such as preflight, build, etc.) inside a folder within `workflows-lib` and calling them from `main.yml` by creating a **composite action** for each *stage*.  
However, we encountered a limitation: **GitHub Actions does not allow composite jobs to contain other jobs, composite actions only have steps**.  
So, when visualized on GitHub, it appears like this:  
![Design Main Alone](/docs/assets/design/design_1.png)  
As shown above, it’s not easy to identify each individual step executed within the PreFlight process. This is just a demonstration with three steps, imagine executing every security tool in that sequence.  
**Workflow:**   
![Workflow Design 1](/docs/assets/design/workflow_1.png)  
![Workflow Design 1 Names](/docs/assets/design/workflow_1_left.png)  

2. **Main + `Stages`**:  
Next, we considered placing all the stages in the workflows directory along with the `main.yml`, and executing each of them as separate jobs within main.yml. Then, from each stage workflow, we would call the different composite actions for each task. This approach provides better modularity, but we lose the ability to have a single job (for example: PreFlight) that encapsulates everything.   
**Workflow:** 
![Workflow Design 2](/docs/assets/design/workflow_2.png  )
![Workflow Design 2 Names](/docs/assets/design/workflow_2_left.png)    
The problem is that, in the GitHub UI, there's no clear separation between stages like PreFlight, Build, etc. While we can name each job, if everything depends on everything else, it becomes difficult to distinguish between stages visually.  

3. **No Main Only `Stages`**:  
Lastly, we considered removing the `main.yml` entirely and calling each individual stage workflow directly. This provides a much clearer and more structured result in the UI.
The challenge with this approach is when outputs from one stage are needed in the next. If we take this approach, we’ll need to implement a way to pass outputs between workflows calls.
**Workflow:**   
![Workflow Design 3](/docs/assets/design/workflow_3.png)  
![Workflow Design 3 Names](/docs/assets/design/workflow_3_left.png)  