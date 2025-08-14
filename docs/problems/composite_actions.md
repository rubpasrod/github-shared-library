# Composite Actions
As we said in our [architecture](./architecture.md) document, we have to use Composite Actions in our workflows to keep our project organized.  
*A composite Action is a way to group multiple steps into a single reusable unit.*  
Composite Actions are executed inside a **job step**, meaning they cannot be used as a **job**. They must be called inside the `steps` section of a job.

## Limitations of Composite Actions
One of the main challenges with Composite Actions is that they cannot directly expose outputs from jobs. Since they are executed at the step level, sharing their outputs with other jobs requires explicitly promoting those outputs to the job level. This involves writing each output again and again, which becomes increasingly complex and less maintainable when there are many outputs involved.

## Why we didn't used Composite Actions for load_variables.yml
We initially considered implementing Load Variables as a Composite Action. However, due to the limitation described above, specifically, the complexity of sharing outputs from steps to jobs, we opted for not using a Composite Action in this case.

Instead, we decided to define a reusable workflow (load_variables.yml) located in `.github/workflows` directory. This approach allows us to:
* Call it as a job not a step, what means that we write less lines.
* Use the outputs of the job directly in other jobs.
 
**Load Variables as a Composite Action:**  
![Load Variable Composite](/docs/assets/code/composite_load.png)  
**Load Variables as a Job:**  
![Load Variable Not Composite](/docs/assets/code/not_composite_load.png)  
